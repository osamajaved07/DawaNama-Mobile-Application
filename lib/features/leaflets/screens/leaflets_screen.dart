import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/leaflet.dart';
import '../providers/leaflets_provider.dart';
import 'leaflet_card.dart';

class LeafletsScreen extends ConsumerStatefulWidget {
  const LeafletsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LeafletsScreen> createState() => _LeafletsScreenState();
}

class _LeafletsScreenState extends ConsumerState<LeafletsScreen> {
  late TextEditingController _searchController;
  String? _selectedProduct;
  String? _selectedLanguage;
  String? _selectedStatus;
  String _sortBy = 'latest'; // latest, oldest, name_asc, name_desc, downloads

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Invalidate the provider when the screen is first loaded to fetch latest data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('📱 LeafletsScreen loaded - Refreshing leaflets...');
      ref.invalidate(leafletsProvider);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Leaflet> _filterAndSort(List<Leaflet> leaflets) {
    var filtered = leaflets.where((leaflet) {
      // Search filter
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        if (!leaflet.title.toLowerCase().contains(query) &&
            !(leaflet.productName?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      // Product filter
      if (_selectedProduct != null && leaflet.productName != _selectedProduct) {
        return false;
      }

      // Language filter
      if (_selectedLanguage != null &&
          leaflet.language.toLowerCase() != _selectedLanguage!.toLowerCase()) {
        return false;
      }

      // Status filter
      if (_selectedStatus != null &&
          leaflet.status.toLowerCase() != _selectedStatus!.toLowerCase()) {
        return false;
      }

      return true;
    }).toList();

    // Sorting
    switch (_sortBy) {
      case 'latest':
        filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case 'name_asc':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'name_desc':
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'downloads':
        filtered.sort((a, b) => b.downloadCount.compareTo(a.downloadCount));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final leafletsAsyncValue = ref.watch(leafletsProvider);
    final distinctProducts = ref.watch(distinctProductsProvider);
    final distinctLanguages = ref.watch(distinctLanguagesProvider);
    final distinctStatuses = ref.watch(distinctStatusesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaflets'),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print('🔄 User triggered refresh');
          ref.invalidate(leafletsProvider);
          await ref.read(leafletsProvider.future);
        },
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search leaflets...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              ),
            ),

            // Filters and Sort Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    // Product Filter
                    distinctProducts.when(
                      data: (products) => _buildFilterChip(
                        label: 'Product',
                        value: _selectedProduct,
                        items: products,
                        onChanged: (value) {
                          setState(() => _selectedProduct = value);
                        },
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    SizedBox(width: 8.w),

                    // Language Filter
                    distinctLanguages.when(
                      data: (languages) => _buildFilterChip(
                        label: 'Language',
                        value: _selectedLanguage,
                        items: languages,
                        onChanged: (value) {
                          setState(() => _selectedLanguage = value);
                        },
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    SizedBox(width: 8.w),

                    // Status Filter
                    distinctStatuses.when(
                      data: (statuses) => _buildFilterChip(
                        label: 'Status',
                        value: _selectedStatus,
                        items: statuses,
                        onChanged: (value) {
                          setState(() => _selectedStatus = value);
                        },
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    SizedBox(width: 8.w),

                    // Sort Dropdown
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() => _sortBy = value);
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'latest',
                          child: Row(
                            children: [
                              Icon(Icons.schedule, size: 18),
                              SizedBox(width: 8),
                              Text('Latest First'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'oldest',
                          child: Row(
                            children: [
                              Icon(Icons.history, size: 18),
                              SizedBox(width: 8),
                              Text('Oldest First'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'name_asc',
                          child: Row(
                            children: [
                              Icon(Icons.sort_by_alpha, size: 18),
                              SizedBox(width: 8),
                              Text('Name (A–Z)'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'name_desc',
                          child: Row(
                            children: [
                              Icon(Icons.sort_by_alpha, size: 18),
                              SizedBox(width: 8),
                              Text('Name (Z–A)'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'downloads',
                          child: Row(
                            children: [
                              Icon(Icons.download, size: 18),
                              SizedBox(width: 8),
                              Text('Most Downloaded'),
                            ],
                          ),
                        ),
                      ],
                      child: Chip(
                        label: Text(_sortByLabel(_sortBy)),
                        onDeleted: null,
                        avatar: const Icon(Icons.sort),
                      ),
                    ),

                    // Clear Filters Button
                    if (_selectedProduct != null ||
                        _selectedLanguage != null ||
                        _selectedStatus != null)
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedProduct = null;
                              _selectedLanguage = null;
                              _selectedStatus = null;
                            });
                          },
                          icon: Icon(Icons.close, size: 16.sp),
                          label: Text(
                            'Clear',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Leaflets List
            Expanded(
              child: leafletsAsyncValue.when(
                data: (leaflets) {
                  final filtered = _filterAndSort(leaflets);
                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 64.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No Leaflets Found',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 18.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Try adjusting your filters',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filtered.length,
                    padding: EdgeInsets.only(bottom: 16.h),
                    itemBuilder: (context, index) {
                      final leaflet = filtered[index];
                      return LeafletCard(
                        leaflet: leaflet,
                        onRefresh: () => ref.invalidate(leafletsProvider),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.black),
                      SizedBox(height: 16.h),
                      Text(
                        'Loading Leaflets...',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: Colors.red.shade400,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Error Loading Leaflets',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 18.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(leafletsProvider),
                        icon: const Icon(Icons.refresh),
                        label: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return PopupMenuButton<String?>(
      onSelected: onChanged,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String?>(
          value: null,
          child: Row(
            children: [
              Icon(Icons.close, size: 16.sp, color: Colors.grey.shade600),
              SizedBox(width: 8.w),
              Text('Clear', style: TextStyle(fontSize: 12.sp)),
            ],
          ),
        ),
        ...items.map(
          (item) => PopupMenuItem<String>(
            value: item,
            child: Text(item, style: TextStyle(fontSize: 12.sp)),
          ),
        ),
      ],
      child: Chip(
        label: Text(value ?? label, style: TextStyle(fontSize: 12.sp)),
        avatar: value != null ? Icon(Icons.check, size: 14.sp) : null,
        backgroundColor: value != null
            ? Colors.blue.shade100
            : Colors.grey.shade200,
      ),
    );
  }

  String _sortByLabel(String sortBy) {
    switch (sortBy) {
      case 'latest':
        return 'Latest';
      case 'oldest':
        return 'Oldest';
      case 'name_asc':
        return 'A–Z';
      case 'name_desc':
        return 'Z–A';
      case 'downloads':
        return 'Downloads';
      default:
        return sortBy;
    }
  }
}
