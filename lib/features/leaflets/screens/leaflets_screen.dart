// ignore_for_file: avoid_print, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/leaflet.dart';
import '../providers/leaflets_provider.dart';
import '../providers/favorites_provider.dart';
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

  List<Leaflet> _filterAndSort(
    List<Leaflet> leaflets,
    Set<String> favoriteIds,
  ) {
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

      // Favorites filter - if sort is set to favorites, only show favorites
      if (_sortBy == 'favorites' && !favoriteIds.contains(leaflet.id)) {
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
      case 'favorites':
        // When favorites is selected, sort by latest first
        filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
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
        centerTitle: true,
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
                        const PopupMenuItem(
                          value: 'favorites',
                          child: Row(
                            children: [
                              Icon(Icons.favorite, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Favorites Only'),
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
                  final favoriteIds = ref.watch(favoritesProvider);
                  final filtered = _filterAndSort(leaflets, favoriteIds);
                  final favoriteLeaflets = filtered
                      .where((leaflet) => favoriteIds.contains(leaflet.id))
                      .toList();
                  final otherLeaflets = filtered
                      .where((leaflet) => !favoriteIds.contains(leaflet.id))
                      .toList();

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

                  return ListView(
                    padding: EdgeInsets.only(bottom: 16.h),
                    children: [
                      // When Favorites sort is selected, show only favorites with no section headers
                      if (_sortBy == 'favorites') ...[
                        ...filtered.map(
                          (leaflet) => LeafletCard(
                            leaflet: leaflet,
                            onRefresh: () => ref.invalidate(leafletsProvider),
                          ),
                        ),
                      ] else ...[
                        // Normal view: Favorites Section first, then All Leaflets
                        if (favoriteLeaflets.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Favorites',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    '${favoriteLeaflets.length}',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...favoriteLeaflets.map(
                            (leaflet) => LeafletCard(
                              leaflet: leaflet,
                              onRefresh: () => ref.invalidate(leafletsProvider),
                            ),
                          ),
                          Divider(height: 16.h),
                        ],

                        // All Leaflets Section
                        if (otherLeaflets.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                            child: Text(
                              'All Leaflets',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                            ),
                          ),
                          ...otherLeaflets.map(
                            (leaflet) => LeafletCard(
                              leaflet: leaflet,
                              onRefresh: () => ref.invalidate(leafletsProvider),
                            ),
                          ),
                        ],
                      ],
                    ],
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
            SizedBox(height: 28.h),
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
      case 'favorites':
        return 'Favorites';
      default:
        return sortBy;
    }
  }
}
