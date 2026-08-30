import 'package:flutter/material.dart';

/// Asks for a cancellation reason. The server requires one: it is stored in the
/// appointment's status history and sent to the other party in the
/// notification, so cancelling silently is no longer possible.
Future<String?> promptCancelReason(BuildContext context) async {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final reason = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Otkazati termin?'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Vaša posjeta će biti označena kao otkazana.'),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              maxLines: 3,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Razlog otkazivanja',
                hintText: 'Npr. spriječen/a sam, javit ću se za novi termin.',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'Razlog otkazivanja je obavezan.';
                if (t.length < 3) return 'Razlog mora imati najmanje 3 znaka.';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Odustani'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState?.validate() != true) return;
            Navigator.pop(ctx, controller.text.trim());
          },
          child: const Text('Da, otkaži'),
        ),
      ],
    ),
  );
  controller.dispose();
  return reason;
}
