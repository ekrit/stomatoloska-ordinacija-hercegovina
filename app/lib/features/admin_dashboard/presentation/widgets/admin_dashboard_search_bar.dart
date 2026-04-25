import 'package:flutter/material.dart';

import '../screens/admin_search_screen.dart';

/// Search field for the admin dashboard app bar; submits open [AdminSearchScreen].
class AdminDashboardSearchBar extends StatefulWidget {
  const AdminDashboardSearchBar({super.key, required this.width});

  final double width;

  @override
  State<AdminDashboardSearchBar> createState() => _AdminDashboardSearchBarState();
}

class _AdminDashboardSearchBarState extends State<AdminDashboardSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runSearch() {
    final q = _controller.text.trim();
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AdminSearchScreen(query: q),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _runSearch(),
        decoration: InputDecoration(
          hintText: 'Search patients, doctors, appointments...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Search',
            onPressed: _runSearch,
          ),
        ),
      ),
    );
  }
}
