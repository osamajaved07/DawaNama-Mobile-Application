import 'dart:async';
import 'package:dawanama/screens/dashboard/dr_dashboard_screen.dart';
import 'package:dawanama/screens/dashboard/mr_dashboard_screen.dart';
import 'package:dawanama/services/secure_storage_service.dart';
import 'package:dawanama/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    // Delay for logo animation + navigation check
    Timer(const Duration(seconds: 3), _checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    final userType = await SecureStorageService.getUserRole();

    if (mounted) {
      if (userType == 'mr') {
        final userData = await SecureStorageService.getUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MRDashboardScreen(mrName: userData?['name'] ?? ''),
          ),
        );
      } else if (userType == 'doctor') {
        final userData = await SecureStorageService.getUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DoctorDashboardScreen(drName: userData?['name'] ?? ''),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 100.h),
              const SizedBox(height: 20),
              Text(
                "DawaNama",
                style: GoogleFonts.poppins(
                  fontSize: 26.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Powered by Nabi Qasim Pharmaceuticals",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),

              /// 🔹 Spinner Loader
              const SpinKitFadingCircle(color: Colors.white, size: 45.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
