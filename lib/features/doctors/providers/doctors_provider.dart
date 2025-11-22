// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/doctor.dart';
import '../repositories/doctors_repository.dart';

/// Provider for DoctorsRepository
final doctorsRepositoryProvider = Provider<DoctorsRepository>((ref) {
  final supabaseClient = Supabase.instance.client;
  return DoctorsRepository(supabaseClient: supabaseClient);
});

/// Provider to fetch doctors for logged-in MR
final doctorsProvider = FutureProvider.family<List<Doctor>, String>((
  ref,
  mrId,
) async {
  print('📱 DoctorsProvider triggered for MR: $mrId');
  final repository = ref.watch(doctorsRepositoryProvider);
  return repository.fetchDoctorsByMrId(mrId);
});

/// Provider to get distinct specialties for MR's doctors
final distinctSpecialtiesProvider = FutureProvider.family<List<String>, String>(
  (ref, mrId) async {
    final repository = ref.watch(doctorsRepositoryProvider);
    return repository.getDistinctSpecialties(mrId);
  },
);

/// Provider to get distinct cities for MR's doctors
final distinctCitiesProvider = FutureProvider.family<List<String>, String>((
  ref,
  mrId,
) async {
  final repository = ref.watch(doctorsRepositoryProvider);
  return repository.getDistinctCities(mrId);
});

/// Provider to refresh doctors list
final doctorsRefreshProvider = Provider((ref) {
  // This provider can be invalidated to refresh the doctors list
});
