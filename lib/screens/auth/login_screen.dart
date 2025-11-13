// ignore_for_file: deprecated_member_use

import 'package:dawanama/features/auth/auth_controller.dart';
import 'package:dawanama/screens/dashboard/dr_dashboard_screen.dart';
import 'package:dawanama/screens/dashboard/mr_dashboard_screen.dart';
import 'package:dawanama/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final selectedRoleProvider = StateProvider<String>((ref) => 'mr');
// final isLoadingProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idOrEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _selectedRole = "mr";

  // void handleLogin() async {
  //   final role = ref.read(selectedRoleProvider);
  //   final auth = ref.read(authProvider);
  //   final idOrEmail = idOrEmailController.text.trim();
  //   final password = passwordController.text.trim();

  //   if (idOrEmail.isEmpty || password.isEmpty) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Please enter all fields')));
  //     return;
  //   }

  //   ref.read(isLoadingProvider.notifier).state = true;

  //   final res = await auth.login(
  //     role: role,
  //     idOrEmail: idOrEmail,
  //     password: password,
  //   );

  //   ref.read(isLoadingProvider.notifier).state = false;

  //   if (res['success']) {
  //     // Navigate to Dashboard based on role
  //     if (role == 'mr') {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => const MRDashboardScreen()),
  //       );
  //     } else {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Login failed')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isLoggedIn && next.userData != null) {
        final role = next.userType;
        final user = next.userData;
        print("✅ Login Success: $user");

        if (role == 'mr') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MRDashboardScreen(mrName: user!['name'] ?? ''),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DoctorDashboardScreen()),
          );
        }
      } else if (next.errorMessage != null) {
        print("❌ Login Error: ${next.errorMessage}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "DawaNama",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Powered by Nabi Qasim Pharmaceuticals',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Role Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: "Select Role"),
                  items: const [
                    DropdownMenuItem(
                      value: "mr",
                      child: Text("Medical Representative"),
                    ),
                    DropdownMenuItem(value: "doctor", child: Text("Doctor")),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedRole = val ?? "mr");
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: idOrEmailController,
                  decoration: InputDecoration(
                    labelText: _selectedRole == "mr"
                        ? "Employee ID"
                        : "Email Address",
                  ),
                  validator: (val) =>
                      val!.isEmpty ? "This field cannot be empty" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (val) =>
                      val!.isEmpty ? "Password cannot be empty" : null,
                ),
                const SizedBox(height: 24),
                // 🔹 Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final role = _selectedRole;
                              final idOrEmail = idOrEmailController.text.trim();
                              final password = passwordController.text.trim();

                              print("🔹 Trying login:");
                              print("Role: $role");
                              print("ID/Email: '$idOrEmail'");
                              print("Password: '$password'");

                              ref
                                  .read(authControllerProvider.notifier)
                                  .login(role, idOrEmail, password);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: authState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
