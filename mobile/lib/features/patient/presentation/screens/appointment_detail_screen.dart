import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/api/soh_extra_api.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/utils/appointment_labels.dart';
import '../../../booking/presentation/payment_screen.dart';
import '../providers/patient_data_providers.dart';
import '../providers/patient_repository_providers.dart';
import 'patient_findings_screen.dart';

/// Full detail view for a single appointment: schedule, dentist, service,
/// status, payment, and the contextual actions (pay, refund, cancel, findings).
class AppointmentDetailScreen extends ConsumerWidget {
  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
    this.doctorName,
    this.serviceName,
  });

  final AppointmentResponse appointment;
  final String? doctorName;
  final String? serviceName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = appointment;
    final df = DateFormat.yMMMMEEEEd();
    final tf = DateFormat.Hm();
    final start = a.startTime;
    final end = a.endTime;
    final theme = Theme.of(context);

    final status = a.status;
    final isUpcoming =
        status == AppointmentStatuses.requested || status == AppointmentStatuses.accepted;
    final canPay = isUpcoming && a.isPaid != true;
    final canRefund = a.isPaid == true && a.paymentId != null && status != AppointmentStatuses.completed;

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  start != null ? df.format(start) : '—',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              if (a.isPaid == true)
                Chip(
                  avatar: Icon(Icons.check_circle, size: 16, color: Colors.green.shade800),
                  label: const Text('Paid / Plaćeno'),
                  backgroundColor: Colors.green.shade50,
                ),
            ],
          ),
          if (start != null)
            Text(
              '${tf.format(start)}${end != null ? ' – ${tf.format(end)}' : ''}',
              style: theme.textTheme.titleMedium,
            ),
          const Divider(height: 28),
          _row(context, Icons.medical_services_outlined, 'Dentist', doctorName ?? 'Dentist'),
          _row(context, Icons.healing_outlined, 'Service', serviceName ?? 'Service'),
          _row(context, Icons.flag_outlined, 'Status', appointmentStatusLabel(status)),
          if ((a.doctorNote ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Doctor note', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(a.doctorNote!),
          ],
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (canPay && a.id != null)
                FilledButton.icon(
                  onPressed: () => _pay(context, ref, a),
                  icon: const Icon(Icons.account_balance_wallet_outlined),
                  label: const Text('Pay now'),
                ),
              if (canRefund)
                OutlinedButton.icon(
                  onPressed: () => _refund(context, ref, a),
                  icon: const Icon(Icons.currency_exchange),
                  label: const Text('Request refund'),
                ),
              if (a.id != null)
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => PatientFindingsScreen(appointmentId: a.id!),
                    ),
                  ),
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('Findings'),
                ),
              if (isUpcoming && a.id != null)
                OutlinedButton.icon(
                  onPressed: () => _cancel(context, ref, a),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _pay(BuildContext context, WidgetRef ref, AppointmentResponse a) async {
    final paid = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PaymentScreen(appointmentId: a.id!, serviceName: serviceName),
      ),
    );
    ref.invalidate(myAppointmentsProvider);
    if (paid == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment completed.')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _refund(BuildContext context, WidgetRef ref, AppointmentResponse a) async {
    final paymentId = a.paymentId;
    if (paymentId == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request refund?'),
        content: const Text(
          'We will refund your payment via PayPal and cancel this appointment. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes, refund')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await SohExtraApi(ref.read(apiClientProvider)).refundPayment(paymentId);
      ref.invalidate(myAppointmentsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Refund completed. Appointment cancelled.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Refund failed.'))),
        );
      }
    }
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref, AppointmentResponse a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel appointment?'),
        content: const Text('This will mark your visit as cancelled.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes, cancel')),
        ],
      ),
    );
    if (ok != true) return;
    if (a.id == null ||
        a.patientId == null ||
        a.doctorId == null ||
        a.serviceId == null ||
        a.roomId == null ||
        a.startTime == null ||
        a.endTime == null) {
      return;
    }
    try {
      await ref.read(patientCareRepositoryProvider).updateAppointment(
            a.id!,
            AppointmentUpsertRequest(
              patientId: a.patientId!,
              doctorId: a.doctorId!,
              serviceId: a.serviceId!,
              roomId: a.roomId!,
              startTime: a.startTime!,
              endTime: a.endTime!,
              status: AppointmentStatuses.cancelled,
              doctorNote: a.doctorNote,
            ),
          );
      ref.invalidate(myAppointmentsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment cancelled.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Could not cancel.'))),
        );
      }
    }
  }
}
