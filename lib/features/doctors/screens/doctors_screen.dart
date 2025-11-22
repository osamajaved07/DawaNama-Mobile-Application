// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/doctor.dart';
import '../providers/doctors_provider.dart';
import 'doctor_card.dart';

class DoctorsScreen extends ConsumerStatefulWidget {
  final String mrId;
  final String mrName;

  const DoctorsScreen({Key? key, required this.mrId, required this.mrName})
    : super(key: key);

  @override
  ConsumerState<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends ConsumerState<DoctorsScreen> {
  late TextEditingController _searchController;
  String? _selectedSpecialty;
  String? _selectedCity;
  String _sortBy = 'name'; // name, recent, contact

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Refresh doctors when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
        '📱 DoctorsScreen loaded - Refreshing doctors for MR: ${widget.mrId}',
      );
      print('🔍 Widget mrId value: "${widget.mrId}"');
      print('🔍 Widget mrId isEmpty: ${widget.mrId.isEmpty}');
      if (widget.mrId.isNotEmpty) {
        ref.invalidate(doctorsProvider(widget.mrId));
      } else {
        print('⚠️ WARNING: mrId is empty, cannot fetch doctors');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Doctor> _filterAndSort(List<Doctor> doctors) {
    var filtered = doctors.where((doctor) {
      // Search filter
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        if (!doctor.name.toLowerCase().contains(query) &&
            !(doctor.specialty?.toLowerCase().contains(query) ?? false) &&
            !(doctor.city?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      // Specialty filter
      if (_selectedSpecialty != null &&
          doctor.specialty != _selectedSpecialty) {
        return false;
      }

      // City filter
      if (_selectedCity != null && doctor.city != _selectedCity) {
        return false;
      }

      return true;
    }).toList();

    // Sorting
    switch (_sortBy) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'specialty':
        filtered.sort(
          (a, b) => (a.specialty ?? '').compareTo(b.specialty ?? ''),
        );
        break;
      case 'city':
        filtered.sort((a, b) => (a.city ?? '').compareTo(b.city ?? ''));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final doctorsAsyncValue = ref.watch(doctorsProvider(widget.mrId));
    final distinctSpecialties = ref.watch(
      distinctSpecialtiesProvider(widget.mrId),
    );
    final distinctCities = ref.watch(distinctCitiesProvider(widget.mrId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Doctors (${widget.mrName})'),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print('🔄 User triggered refresh');
          ref.invalidate(doctorsProvider(widget.mrId));
          await ref.read(doctorsProvider(widget.mrId).future);
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
                  hintText: 'Search doctors...',
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
                    // Specialty Filter
                    distinctSpecialties.when(
                      data: (specialties) => _buildFilterChip(
                        label: 'Specialty',
                        value: _selectedSpecialty,
                        items: specialties,
                        onChanged: (value) {
                          setState(() => _selectedSpecialty = value);
                        },
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    SizedBox(width: 8.w),

                    // City Filter
                    distinctCities.when(
                      data: (cities) => _buildFilterChip(
                        label: 'City',
                        value: _selectedCity,
                        items: cities,
                        onChanged: (value) {
                          setState(() => _selectedCity = value);
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
                          value: 'name',
                          child: Row(
                            children: [
                              Icon(Icons.sort_by_alpha, size: 18),
                              SizedBox(width: 8),
                              Text('Name (A–Z)'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'specialty',
                          child: Row(
                            children: [
                              Icon(Icons.medical_services, size: 18),
                              SizedBox(width: 8),
                              Text('Specialty'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'city',
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 18),
                              SizedBox(width: 8),
                              Text('City'),
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
                    if (_selectedSpecialty != null || _selectedCity != null)
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedSpecialty = null;
                              _selectedCity = null;
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

            // Doctors List
            Expanded(
              child: doctorsAsyncValue.when(
                data: (doctors) {
                  final filtered = _filterAndSort(doctors);

                  if (doctors.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_hospital,
                            size: 64.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No Doctors Yet',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 18.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'You have no doctors linked to your account',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No Doctors Found',
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
                      final doctor = filtered[index];
                      return DoctorCard(doctor: doctor);
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
                        'Loading Doctors...',
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
                        'Error Loading Doctors',
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
                        onPressed: () =>
                            ref.invalidate(doctorsProvider(widget.mrId)),
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
      case 'name':
        return 'Name';
      case 'specialty':
        return 'Specialty';
      case 'city':
        return 'City';
      default:
        return sortBy;
    }
  }
}
