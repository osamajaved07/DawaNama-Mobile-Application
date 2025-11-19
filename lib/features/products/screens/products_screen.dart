// ignore_for_file: use_build_context_synchronously, unused_result
import 'package:dawanama/features/products/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dawanama/features/products/products_providers.dart';
import 'package:dawanama/utils/theme/app_colors.dart';
import 'package:dawanama/features/products/product_model.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final categories = <String>[
    'All',
    'Cardiac',
    'Diabetes',
    'Vitamins',
    'Pain Relief',
    'Antibiotics',
    'Dermatology',
  ];

  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(() {
      ref.read(productsSearchQueryProvider.notifier).set(searchCtrl.text);
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Consumer(
          builder: (ctx, consumerRef, __) {
            final sort = consumerRef.read(productsSortProvider);
            String tmpSort = sort;
            String? tmpStatus = consumerRef.read(productsStatusFilterProvider);
            String? tmpManufacturer = consumerRef.read(
              productsManufacturerFilterProvider,
            );
            String? tmpTargetSpecialty = consumerRef.read(
              productsTargetSpecialtyFilterProvider,
            );

            final manufacturersAsync = consumerRef.watch(
              distinctManufacturersProvider,
            );
            final specialtiesAsync = consumerRef.watch(
              distinctTargetSpecialtiesProvider,
            );

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: StatefulBuilder(
                builder: (ctx, st) {
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Filters & Sorting',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Status filter
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Status',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              DropdownButton<String?>(
                                value: tmpStatus,
                                items: const [
                                  DropdownMenuItem(
                                    value: null,
                                    child: Text('Any'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Active',
                                    child: Text('Active'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Inactive',
                                    child: Text('Inactive'),
                                  ),
                                ],
                                onChanged: (v) => st(() => tmpStatus = v),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Manufacturer filter (dynamic from database)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Manufacturer',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              manufacturersAsync.when(
                                data: (manufacturers) {
                                  final items = <DropdownMenuItem<String?>>[
                                    const DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text('Any'),
                                    ),
                                    ...manufacturers.map(
                                      (m) => DropdownMenuItem<String?>(
                                        value: m,
                                        child: Text(m),
                                      ),
                                    ),
                                  ];
                                  return DropdownButton<String?>(
                                    value: tmpManufacturer,
                                    items: items,
                                    onChanged: (v) =>
                                        st(() => tmpManufacturer = v),
                                  );
                                },
                                loading: () => const SizedBox(
                                  width: 100,
                                  child: Text('...'),
                                ),
                                error: (_, __) => const Text('Error'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Target Specialty filter (dynamic from database)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Target Specialty',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              specialtiesAsync.when(
                                data: (specialties) {
                                  final items = <DropdownMenuItem<String?>>[
                                    const DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text('Any'),
                                    ),
                                    ...specialties.map(
                                      (s) => DropdownMenuItem<String?>(
                                        value: s,
                                        child: Text(s),
                                      ),
                                    ),
                                  ];
                                  return DropdownButton<String?>(
                                    value: tmpTargetSpecialty,
                                    items: items,
                                    onChanged: (v) =>
                                        st(() => tmpTargetSpecialty = v),
                                  );
                                },
                                loading: () => const SizedBox(
                                  width: 100,
                                  child: Text('...'),
                                ),
                                error: (_, __) => const Text('Error'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Sort by
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Sort by',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              DropdownButton<String>(
                                value: tmpSort,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'name.asc',
                                    child: Text('Name A → Z'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'name.desc',
                                    child: Text('Name Z → A'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'created_at.desc',
                                    child: Text('Newest'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'mrp.asc',
                                    child: Text('Price Low → High'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'mrp.desc',
                                    child: Text('Price High → Low'),
                                  ),
                                ],
                                onChanged: (v) => st(() => tmpSort = v!),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Apply and Reset buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    consumerRef
                                        .read(productsSortProvider.notifier)
                                        .set(tmpSort);
                                    consumerRef
                                        .read(
                                          productsStatusFilterProvider.notifier,
                                        )
                                        .set(tmpStatus);
                                    consumerRef
                                        .read(
                                          productsManufacturerFilterProvider
                                              .notifier,
                                        )
                                        .set(tmpManufacturer);
                                    consumerRef
                                        .read(
                                          productsTargetSpecialtyFilterProvider
                                              .notifier,
                                        )
                                        .set(tmpTargetSpecialty);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Apply'),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    consumerRef
                                        .read(productsSortProvider.notifier)
                                        .set('name.asc');
                                    consumerRef
                                        .read(
                                          productsStatusFilterProvider.notifier,
                                        )
                                        .set(null);
                                    consumerRef
                                        .read(
                                          productsManufacturerFilterProvider
                                              .notifier,
                                        )
                                        .set(null);
                                    consumerRef
                                        .read(
                                          productsTargetSpecialtyFilterProvider
                                              .notifier,
                                        )
                                        .set(null);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Reset'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _productCard(Product p) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(235, 4, 192, 192).withOpacity(0.95),
              const Color.fromARGB(255, 144, 191, 191).withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.r,
              offset: Offset(2.w, 3.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              // image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: p.imageUrl != null && p.imageUrl!.isNotEmpty
                    ? Image.network(
                        p.imageUrl!,
                        width: 72.w,
                        height: 72.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            width: 72.w,
                            height: 72.w,
                            color: Colors.white24,
                            child: Icon(Icons.broken_image),
                          );
                        },
                      )
                    : Container(
                        width: 72.w,
                        height: 72.w,
                        color: Colors.white24,
                        child: Icon(Icons.medical_services),
                      ),
              ),
              SizedBox(width: 12.w),
              // info
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'SKU: ${p.sku}',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        if (p.mrp != null)
                          Text(
                            'MRP: ${p.mrp!.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                        SizedBox(width: 8.w),
                        if (p.tradePrice != null)
                          Text(
                            'Trade: ${p.tradePrice!.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            /* favorite toggle */
                          },
                          icon: Icon(Icons.star_border, color: Colors.white),
                        ),
                        if (p.leafletsUrl != null)
                          IconButton(
                            onPressed: () {
                              /* open leaflet */
                            },
                            icon: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.white,
                            ),
                          ),
                        // if (p.targetSpecialty != null &&
                        //     p.targetSpecialty!.isNotEmpty)
                        //   Expanded(
                        //     child: Padding(
                        //       padding: EdgeInsets.only(left: 8.w),
                        //       child: Text(
                        //         p.targetSpecialty!.join(', '),
                        //         maxLines: 1,
                        //         overflow: TextOverflow.ellipsis,
                        //         style: GoogleFonts.poppins(
                        //           color: Colors.white70,
                        //           fontSize: 11.sp,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                    if (p.targetSpecialty != null &&
                        p.targetSpecialty!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Text(
                          p.targetSpecialty!.join(', '),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(productsListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Products',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _openFilters();
            },
            icon: const Icon(Icons.filter_alt_outlined),
          ),
          IconButton(
            onPressed: () {
              ref.refresh(productsListProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/bg6.jpg',
            ), // or NetworkImage('url')
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                0.3,
              ), // Optional: add overlay for better readability
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search + voice
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search by name or SKU',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: IconButton(
                        onPressed: () {
                          // optional voice search
                        },
                        icon: const Icon(Icons.mic, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Categories chips
              SizedBox(
                height: 46.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    final c = categories[i];
                    final selected =
                        ref.watch(productsSelectedCategoryProvider) == c;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ChoiceChip(
                        label: Text(
                          c,
                          style: GoogleFonts.poppins(
                            color: selected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: selected,
                        onSelected: (_) {
                          ref
                              .read(productsSelectedCategoryProvider.notifier)
                              .set(c);
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // content
              Expanded(
                child: listAsync.when(
                  data: (list) {
                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          'No products found',
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(productsListProvider);
                        await Future.delayed(const Duration(milliseconds: 600));
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 8.w,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, idx) {
                          return _productCard(list[idx]);
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: SpinKitFadingCircle(color: Colors.blue, size: 36.0),
                  ),
                  error: (e, st) => Center(
                    child: Text(
                      'Error: ${e.toString()}',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
