import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/api/soh_extra_api.dart';
import '../../../core/utils/api_errors.dart';

/// In-app PayPal checkout for a freshly booked appointment.
///
/// Flow: create the order on the server (price comes from the catalog), let the
/// patient confirm, open PayPal's approval page in a WebView, then capture the
/// order as soon as PayPal redirects back to our return URL. Pops `true` when
/// the payment is captured.
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({
    super.key,
    required this.appointmentId,
    this.serviceName,
  });

  final int appointmentId;
  final String? serviceName;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

enum _Phase { loading, confirm, paying, done, failed }

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  _Phase _phase = _Phase.loading;
  PaymentOrderInfo? _order;
  String? _error;
  WebViewController? _webController;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    _createOrder();
  }

  Future<void> _createOrder() async {
    setState(() {
      _phase = _Phase.loading;
      _error = null;
    });
    try {
      final order = await SohExtraApi(ref.read(apiClientProvider))
          .createPaymentOrder(widget.appointmentId);
      if (!mounted) return;
      setState(() {
        _order = order;
        _phase = _Phase.confirm;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = extractApiErrorMessage(e, fallback: 'Plaćanje nije moguće pokrenuti.');
        _phase = _Phase.failed;
      });
    }
  }

  void _startWebView() {
    final order = _order;
    if (order == null || order.approvalUrl.isEmpty) {
      setState(() {
        _error = 'PayPal nije vratio link za odobrenje.';
        _phase = _Phase.failed;
      });
      return;
    }

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final handled = _handleReturnUrl(request.url);
            return handled ? NavigationDecision.prevent : NavigationDecision.navigate;
          },
          // Fallback: some redirect chains (HTTP 30x) bypass
          // onNavigationRequest, so also watch the effective URL.
          onUrlChange: (change) {
            final url = change.url;
            if (url != null) _handleReturnUrl(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(order.approvalUrl));

    setState(() {
      _webController = controller;
      _phase = _Phase.paying;
    });
  }

  bool _returnHandled = false;

  /// Returns true when the URL is one of our PayPal return/cancel routes
  /// and was acted upon (only once, even if both callbacks fire).
  bool _handleReturnUrl(String url) {
    if (url.contains('/paypal/return')) {
      if (!_returnHandled) {
        _returnHandled = true;
        _capture();
      }
      return true;
    }
    if (url.contains('/paypal/cancel')) {
      if (!_returnHandled) {
        _returnHandled = true;
        if (mounted) Navigator.of(context).pop(false);
      }
      return true;
    }
    return false;
  }

  Future<void> _capture() async {
    final order = _order;
    if (order == null || _capturing) return;
    _capturing = true;
    try {
      final paid = await SohExtraApi(ref.read(apiClientProvider)).capturePayment(order.paymentId);
      if (!mounted) return;
      if (paid) {
        setState(() => _phase = _Phase.done);
        await Future<void>.delayed(const Duration(milliseconds: 600));
        if (mounted) Navigator.of(context).pop(true);
      } else {
        setState(() {
          _error = 'Plaćanje nije završeno.';
          _phase = _Phase.failed;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = extractApiErrorMessage(e, fallback: 'Plaćanje nije moguće dovršiti.');
        _phase = _Phase.failed;
      });
    } finally {
      _capturing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plaćanje')),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    switch (_phase) {
      case _Phase.loading:
        return const Center(child: CircularProgressIndicator());

      case _Phase.confirm:
        return _buildConfirm();

      case _Phase.paying:
        final c = _webController;
        return c == null
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(controller: c);

      case _Phase.done:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 12),
              Text('Plaćanje završeno'),
            ],
          ),
        );

      case _Phase.failed:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 56),
                const SizedBox(height: 12),
                Text(_error ?? 'Plaćanje nije uspjelo.', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Plati kasnije'),
                    ),
                    FilledButton(
                      onPressed: _createOrder,
                      child: const Text('Pokušaj ponovo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildConfirm() {
    final order = _order!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Icon(Icons.payments_outlined,
              size: 56, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Platite svoj termin',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if ((widget.serviceName ?? '').isNotEmpty)
            Text(widget.serviceName!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Iznos za plaćanje'),
              trailing: Text(
                '${order.amount.toStringAsFixed(2)} EUR',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: _confirmAndPay,
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: const Text('Plati PayPal-om'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Plati kasnije'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndPay() async {
    final order = _order!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nastaviti na PayPal?'),
        content: Text(
          'You are about to pay ${order.amount.toStringAsFixed(2)} EUR via PayPal. '
          'Otvara se PayPal-ova sigurna stranica za plaćanje.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Nastavi')),
        ],
      ),
    );
    if (ok == true) {
      _startWebView();
    }
  }
}
