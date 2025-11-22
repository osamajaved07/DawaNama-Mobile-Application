// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/doctor.dart';

class DoctorsRepository {
  final SupabaseClient supabaseClient;

  DoctorsRepository({required this.supabaseClient});

  /// Fetch all doctors linked to a specific MR
  Future<List<Doctor>> fetchDoctorsByMrId(String mrId) async {
    try {
      print('🔍 Fetching doctors for MR: $mrId');
      print('🔍 mrId isEmpty: ${mrId.isEmpty}');
      print('🔍 mrId length: ${mrId.length}');

      if (mrId.isEmpty) {
        print('⚠️ ERROR: mrId is empty! Cannot query with empty UUID');
        return [];
      }

      final response = await supabaseClient
          .from('doctors')
          .select('*')
          .eq('mrs_id', mrId)
          .order('name', ascending: true);

      print('📊 Raw data from database: $response');
      print('📦 Number of doctors: ${response.length}');

      final doctors = (response as List<dynamic>)
          .map((json) => Doctor.fromJson(json as Map<String, dynamic>))
          .toList();

      print('✅ Doctors fetched: ${doctors.length} doctors found for MR $mrId');
      for (var doc in doctors) {
        print('   - ${doc.name} (${doc.specialty ?? 'No specialty'})');
      }

      return doctors;
    } catch (e) {
      print('❌ Error fetching doctors: $e');
      rethrow;
    }
  }

  /// Fetch a single doctor by ID
  Future<Doctor?> fetchDoctorById(String doctorId) async {
    try {
      print('🔍 Fetching doctor: $doctorId');

      final response = await supabaseClient
          .from('doctors')
          .select('*')
          .eq('id', doctorId)
          .maybeSingle();

      if (response == null) {
        print('❌ Doctor not found: $doctorId');
        return null;
      }

      final doctor = Doctor.fromJson(response);
      print('✅ Doctor fetched: ${doctor.name}');
      return doctor;
    } catch (e) {
      print('❌ Error fetching doctor: $e');
      rethrow;
    }
  }

  /// Get distinct specialties for a specific MR's doctors
  Future<List<String>> getDistinctSpecialties(String mrId) async {
    try {
      if (mrId.isEmpty) {
        print('⚠️ ERROR: mrId is empty! Cannot query specialties');
        return [];
      }

      final response = await supabaseClient
          .from('doctors')
          .select('specialty')
          .eq('mrs_id', mrId)
          .order('specialty', ascending: true);

      final specialties = <String>{};
      for (var item in response as List<dynamic>) {
        final specialty =
            (item as Map<String, dynamic>)['specialty'] as String?;
        if (specialty != null && specialty.isNotEmpty) {
          specialties.add(specialty);
        }
      }

      final sortedSpecialties = specialties.toList();
      print('🏥 Found ${sortedSpecialties.length} distinct specialties');
      return sortedSpecialties;
    } catch (e) {
      print('❌ Error fetching specialties: $e');
      return [];
    }
  }

  /// Get distinct cities for a specific MR's doctors
  Future<List<String>> getDistinctCities(String mrId) async {
    try {
      if (mrId.isEmpty) {
        print('⚠️ ERROR: mrId is empty! Cannot query cities');
        return [];
      }

      final response = await supabaseClient
          .from('doctors')
          .select('city')
          .eq('mrs_id', mrId)
          .order('city', ascending: true);

      final cities = <String>{};
      for (var item in response as List<dynamic>) {
        final city = (item as Map<String, dynamic>)['city'] as String?;
        if (city != null && city.isNotEmpty) {
          cities.add(city);
        }
      }

      final sortedCities = cities.toList();
      print('📍 Found ${sortedCities.length} distinct cities');
      return sortedCities;
    } catch (e) {
      print('❌ Error fetching cities: $e');
      return [];
    }
  }
}
