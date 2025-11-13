// ignore_for_file: avoid_print

import 'package:dawanama/features/auth/auth_state.dart';
import 'package:dawanama/services/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController();
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState());
  final storage = const FlutterSecureStorage();
  final supabase = Supabase.instance.client;

  /// ✅ Login Function with secure storage & role-based handling
  Future<void> login(String role, String idOrEmail, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      Map<String, dynamic>? user;

      if (role == "mr") {
        user = await supabase
            .from('mrs')
            .select()
            .ilike('employee_id', idOrEmail.trim())
            .eq('password', password.trim())
            .maybeSingle();
      } else {
        user = await supabase
            .from('doctors')
            .select()
            .ilike('email', idOrEmail.trim().toLowerCase())
            .eq('password', password.trim())
            .maybeSingle();
      }

      print("🔹 Role: $role");
      print("🔹 idOrEmail: $idOrEmail");
      print("🔹 Password: $password");
      print("🔹 Supabase Response: $user");

      if (user != null) {
        // ✅ Save in Secure Storage
        await SecureStorageService.saveUserData(role: role, userData: user);

        // ✅ Update State
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          userType: role,
          userData: user,
        );

        print("✅ Login Success and data stored securely.");
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Invalid credentials, please try again.",
        );
      }
    } catch (e) {
      print("❌ Login Exception: $e");
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// ✅ Logout Function
  Future<void> logout() async {
    await SecureStorageService.clear(); // 🧹 Clear all saved data
    state = const AuthState();
    print("👋 User logged out and storage cleared.");
  }
}
