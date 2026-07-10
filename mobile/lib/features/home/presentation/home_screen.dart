import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/utils/api_errors.dart';
import '../../../core/widgets/async_body.dart';
import '../../../core/widgets/section_header.dart';
import '../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes;
import '../../patient/presentation/providers/patient_data_providers.dart';
import '../../shop/presentation/product_catalog_screen.dart';
import 'product_detail_screen.dart';
import 'recommendations_providers.dart';
import 'services_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.onBook});

  final VoidCallback onBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final doctors = ref.watch(doctorsProvider);
    final recommended = ref.watch(recommendedProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(doctorsProvider);
          ref.invalidate(recommendedProductsProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader('Welcome'),
                    Text(
                      'Welcome, ${user?.firstName?.trim().isNotEmpty == true ? user!.firstName : 'there'}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your dental care, simplified.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: recommended.when(
                  data: (rec) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const SectionHeader('Recommended for you'),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Suggestions from our server use your visits, clinic popularity, and products you view.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                        if (rec.isEmpty)
                          Text(
                            'No recommendations yet — check back after more catalog data is available.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          )
                        else
                          SizedBox(
                            height: 168,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: rec.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, i) {
                                final item = rec[i];
                                return _ProductCard(
                                  product: item.product,
                                  hint: item.reasons.isNotEmpty ? item.reasons.first : null,
                                  onTap: () {
                                    Navigator.of(context).push<void>(
                                      MaterialPageRoute<void>(
                                        builder: (_) => ProductDetailScreen(
                                          product: item.product,
                                          reasons: item.reasons,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push<void>(
                                MaterialPageRoute<void>(
                                  builder: (_) => const ProductCatalogScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.storefront_outlined, size: 18),
                            label: const Text('Cijeli katalog proizvoda'),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(extractApiErrorMessage(e)),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader('Booking'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ready for your next visit?',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Choose a service, dentist, and time slot that works for you.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: onBook,
                              icon: const Icon(Icons.calendar_month),
                              label: const Text('Book Appointment'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.medical_services_outlined),
                        title: const Text('Naše usluge'),
                        subtitle: const Text('Pregledi, čišćenje, plombe i drugi zahvati sa cijenama.'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => const ServicesScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: AsyncBody(
                  value: doctors,
                  builder: (context, list) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const SectionHeader('Doctor List'),
                        if (list.isEmpty)
                          const Text('No dentists to show.')
                        else
                          ...list.map((d) => _DoctorTile(doctor: d)),
                      ],
                    );
                  },
                  onRetry: () => ref.invalidate(doctorsProvider),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    this.hint,
    this.onTap,
  });

  final ProductResponse product;
  final String? hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bytes = decodeUserPictureBytes(product.picture);
    return SizedBox(
      width: 210,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (bytes != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(bytes, width: 40, height: 40, fit: BoxFit.cover),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        product.name ?? 'Product',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                if (hint != null && hint!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      hint!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                const Spacer(),
                if (product.price != null)
                  Text(
                    '${product.price!.toStringAsFixed(2)} KM',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _doctorInitials(DoctorResponse d) {
  final a = (d.firstName ?? '').trim();
  final b = (d.lastName ?? '').trim();
  final i1 = a.isNotEmpty ? a[0] : '';
  final i2 = b.isNotEmpty ? b[0] : '';
  final s = ('$i1$i2').toUpperCase();
  return s.isEmpty ? 'D' : s;
}

class _DoctorTile extends StatelessWidget {
  const _DoctorTile({required this.doctor});

  final DoctorResponse doctor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(_doctorInitials(doctor)),
        ),
        title: Text(
          '${doctor.firstName ?? ''} ${doctor.lastName ?? ''}'.trim(),
        ),
        subtitle: Text(doctor.specialization ?? ''),
        trailing: doctor.rating != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 18, color: Colors.amber),
                  Text(doctor.rating!.toStringAsFixed(1)),
                ],
              )
            : null,
      ),
    );
  }
}
