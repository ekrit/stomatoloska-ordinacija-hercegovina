import 'package:flutter/material.dart';

import '../utils/api_errors.dart';

/// One page of results plus the (optional) total count the server reported.
class PagedData<T> {
  const PagedData({required this.items, this.total});
  final List<T> items;
  final int? total;
}

typedef PagedFetcher<T> = Future<PagedData<T>> Function(
    String query, int page, int pageSize);

/// Reusable list with a search box, server-side pagination, and prev/next
/// controls. Every admin list uses this so paging/search behave identically.
///
/// Bump [refreshKey] (e.g. after an edit/delete) to force a reload of the
/// current page.
class PaginatedSearchView<T> extends StatefulWidget {
  const PaginatedSearchView({
    super.key,
    required this.fetch,
    required this.itemBuilder,
    this.searchHint = 'Pretraži…',
    this.pageSize = 20,
    this.emptyLabel = 'Nema podataka za prikaz.',
    this.refreshKey = 0,
  });

  final PagedFetcher<T> fetch;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String searchHint;
  final int pageSize;
  final String emptyLabel;
  final int refreshKey;

  @override
  State<PaginatedSearchView<T>> createState() => _PaginatedSearchViewState<T>();
}

class _PaginatedSearchViewState<T> extends State<PaginatedSearchView<T>> {
  final _searchController = TextEditingController();
  String _query = '';
  int _page = 0;
  bool _loading = true;
  String? _error;
  List<T> _items = const [];
  int? _total;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant PaginatedSearchView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshKey != widget.refreshKey) {
      _load();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.fetch(_query, _page, widget.pageSize);
      if (!mounted) return;
      setState(() {
        _items = result.items;
        _total = result.total;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = extractApiErrorMessage(e, fallback: 'Listu nije moguće učitati.');
        _loading = false;
      });
    }
  }

  void _submitSearch(String value) {
    setState(() {
      _query = value.trim();
      _page = 0;
    });
    _load();
  }

  int? get _totalPages {
    final total = _total;
    if (total == null) return null;
    if (total == 0) return 1;
    return (total / widget.pageSize).ceil();
  }

  bool get _hasNext {
    final pages = _totalPages;
    if (pages != null) return _page < pages - 1;
    // Unknown total: allow next while the page came back full.
    return _items.length == widget.pageSize;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: widget.searchHint,
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _submitSearch('');
                      },
                    ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _submitSearch,
          ),
        ),
        Expanded(child: _buildBody()),
        _buildPager(),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text('Pokušaj ponovo')),
            ],
          ),
        ),
      );
    }
    if (_items.isEmpty) {
      return Center(child: Text(widget.emptyLabel));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) => widget.itemBuilder(context, _items[i]),
    );
  }

  Widget _buildPager() {
    final pages = _totalPages;
    final label = pages != null
        ? 'Page ${_page + 1} of $pages'
        : 'Page ${_page + 1}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Prethodna',
            onPressed: _page > 0
                ? () {
                    setState(() => _page -= 1);
                    _load();
                  }
                : null,
          ),
          Text(label),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Sljedeća',
            onPressed: _hasNext
                ? () {
                    setState(() => _page += 1);
                    _load();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
