// ignore_for_file: unused_import

import 'package:dawanama/screens/auth/login_screen.dart';
import 'package:dawanama/screens/splash/splash_screen.dart';
import 'package:dawanama/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nmpjyxijlvqclxdkrqll.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5tcGp5eGlqbHZxY2x4ZGtycWxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5NzUyMTcsImV4cCI6MjA3NzU1MTIxN30.JVWCft8u7EEPR7gikJB82X-MYwoXIpuNphX3z4bTIAI',
  );

  // runApp(const MyApp());
  runApp(const ProviderScope(child: DawaNamaApp()));
}

class DawaNamaApp extends StatelessWidget {
  const DawaNamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          title: 'DawaNama',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          // home: const SplashScreen(),
          initialRoute: '/',
          routes: {
            '/': (_) => const SplashScreen(),
            '/login': (_) => const LoginScreen(),
          },
        );
      },
    );
  }
}
