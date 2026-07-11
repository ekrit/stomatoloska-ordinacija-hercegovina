import 'package:flutter/material.dart';

import '../screens/admin_add_patient_screen.dart';
import '../screens/admin_appointments_list_screen.dart';
import '../screens/admin_doctors_list_screen.dart';
import '../screens/admin_genders_list_screen.dart';
import '../screens/admin_medical_records_screen.dart';
import '../screens/admin_office_locations_screen.dart';
import '../screens/admin_orders_list_screen.dart';
import '../screens/admin_payments_list_screen.dart';
import '../screens/admin_product_categories_screen.dart';
import '../screens/admin_products_list_screen.dart';
import '../screens/admin_reviews_list_screen.dart';
import '../screens/admin_roles_list_screen.dart';
import '../screens/admin_rooms_list_screen.dart';
import '../screens/admin_services_list_screen.dart';
import '../screens/admin_reports_list_screen.dart';
import '../../../admin_users/presentation/screens/users_list_screen.dart';

/// Action buttons only (no card chrome). Use inside a fixed-height panel with [Expanded].
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  static const double rowExtent = 52;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem('Add Patient', Icons.person_add_alt_1_outlined),
      _ActionItem('Manage Users', Icons.group_outlined),
      _ActionItem('Edit Office Info', Icons.edit_outlined),
      _ActionItem('Manage Appointments', Icons.calendar_today_outlined),
      _ActionItem('Generate Reports', Icons.bar_chart_outlined),
      _ActionItem('Manage Products', Icons.inventory_2_outlined),
      _ActionItem('Manage Services', Icons.design_services_outlined),
      _ActionItem('Manage Rooms', Icons.meeting_room_outlined),
      _ActionItem('Manage Genders', Icons.wc_outlined),
      _ActionItem('Payments', Icons.payments_outlined),
      _ActionItem('Manage Doctors', Icons.medical_services_outlined),
      _ActionItem('Manage Roles', Icons.badge_outlined),
      _ActionItem('Product Categories', Icons.category_outlined),
      _ActionItem('Reviews', Icons.reviews_outlined),
      _ActionItem('Orders', Icons.receipt_long_outlined),
      _ActionItem('Medical Records', Icons.description_outlined),
    ];

    final buttonStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      alignment: Alignment.center,
      minimumSize: Size.zero,
    );

    return GridView.builder(
      shrinkWrap: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: rowExtent,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return SizedBox.expand(
          child: OutlinedButton.icon(
            onPressed: () => _onAction(context, index),
            style: buttonStyle,
            icon: Icon(action.icon, size: 18),
            label: Text(
              action.label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  void _onAction(BuildContext context, int index) {
    void push(Widget page) {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => page),
      );
    }

    switch (index) {
      case 0:
        push(const AdminAddPatientScreen());
        break;
      case 1:
        push(const UsersListScreen());
        break;
      case 2:
        push(const AdminOfficeLocationsScreen());
        break;
      case 3:
        push(const AdminAppointmentsListScreen());
        break;
      case 4:
        push(const AdminReportsListScreen());
        break;
      case 5:
        push(const AdminProductsListScreen());
        break;
      case 6:
        push(const AdminServicesListScreen());
        break;
      case 7:
        push(const AdminRoomsListScreen());
        break;
      case 8:
        push(const AdminGendersListScreen());
        break;
      case 9:
        push(const AdminPaymentsListScreen());
        break;
      case 10:
        push(const AdminDoctorsListScreen());
        break;
      case 11:
        push(const AdminRolesListScreen());
        break;
      case 12:
        push(const AdminProductCategoriesScreen());
        break;
      case 13:
        push(const AdminReviewsListScreen());
        break;
      case 14:
        push(const AdminOrdersListScreen());
        break;
      case 15:
        push(const AdminMedicalRecordsScreen());
        break;
    }
  }
}

/// Standalone card with title + grid (e.g. narrow layouts).
class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final rows = (16 / 2).ceil();
                final h = rows * QuickActionsGrid.rowExtent + (rows - 1) * 8.0;
                return SizedBox(
                  height: h,
                  child: const QuickActionsGrid(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem(this.label, this.icon);

  final String label;
  final IconData icon;
}
