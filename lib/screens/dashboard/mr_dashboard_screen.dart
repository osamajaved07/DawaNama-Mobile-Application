// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unnecessary_import
import 'package:dawanama/features/dashboard/mr_dashboard_providers.dart';
import 'package:dawanama/features/auth/auth_controller.dart';
import 'package:dawanama/features/products/screens/products_screen.dart';
import 'package:dawanama/features/leaflets/screens/leaflets_screen.dart';
import 'package:dawanama/features/doctors/screens/doctors_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dawanama/utils/theme/app_colors.dart';

class MRDashboardScreen extends ConsumerWidget {
  final String mrName;

  const MRDashboardScreen({super.key, required this.mrName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final mrId = authState.userData?['id'] as String? ?? '';

    // DEBUG: Log the full userData structure
    print('🔍 AUTH STATE userData: ${authState.userData}');
    print('🔍 Extracted mrId: "$mrId"');

    final stats = [
      {'title': 'Total Products', 'value': '50'},
      {'title': 'Training Completed', 'value': '5 / 10'},
      {'title': 'Doctors Connected', 'value': '32'},
      {'title': 'New Leaflets', 'value': '3 this week'},
    ];

    final modules = [
      {
        'title': 'Products',
        'icon': Icons.medication,
        'color1': Colors.blue,
        'color2': Colors.lightBlueAccent,
      },
      {
        'title': 'Leaflets',
        'icon': Icons.description,
        'color1': Colors.teal,
        'color2': Colors.tealAccent,
      },
      {
        'title': 'Training Videos',
        'icon': Icons.play_circle_fill,
        'color1': Colors.orange,
        'color2': Colors.deepOrangeAccent,
      },
      {
        'title': 'Doctors',
        'icon': Icons.local_hospital,
        'color1': Colors.green,
        'color2': Colors.lightGreen,
      },
      {
        'title': 'Reports',
        'icon': Icons.assignment,
        'color1': Colors.purple,
        'color2': Colors.deepPurpleAccent,
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications,
        'color1': Colors.red,
        'color2': Colors.redAccent,
      },
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/bg6.jpg', fit: BoxFit.cover),
        ),

        Scaffold(
          // backgroundColor: AppColors.background,
          backgroundColor: const Color.fromARGB(51, 0, 0, 0),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: EdgeInsets.all(6.w),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
            ),
            title: Text(
              'Welcome, $mrName',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );
                  if (shouldLogout ?? false) {
                    await ref.read(authControllerProvider.notifier).logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.read(dashboardRefreshingProvider.notifier).state = true;

              await ref.read(authControllerProvider.notifier).fetchUser();

              await Future.delayed(const Duration(seconds: 1));
              ref.read(dashboardRefreshingProvider.notifier).state = false;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------- Your OLD WIDGETS HERE ----------
                    // Quick Stats Section
                    SizedBox(
                      height: 92.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: stats.length,
                        itemBuilder: (context, index) {
                          final stat = stats[index];
                          return Container(
                            width: 140.w,
                            margin: EdgeInsets.only(right: 12.w),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: const DecorationImage(
                                opacity: 0.5,
                                image: AssetImage("assets/images/bg9.jpg"),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: Colors.white60,
                                width: 2.w,
                              ),
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4E4D4D,
                                  ).withOpacity(0.5),
                                  blurRadius: 4.r,
                                  offset: Offset(2.w, 2.h),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stat['title']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    stat['value']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Modules Section
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: modules.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14.h,
                        crossAxisSpacing: 14.w,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final mod = modules[index];
                        return GestureDetector(
                          onTap: () {
                            if (mod['title'] == 'Products') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProductsScreen(),
                                ),
                              );
                            } else if (mod['title'] == 'Leaflets') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LeafletsScreen(),
                                ),
                              );
                            } else if (mod['title'] == 'Doctors') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DoctorsScreen(mrId: mrId, mrName: mrName),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${mod['title']} module coming soon!',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.black,
                              image: const DecorationImage(
                                // opacity: 0.7,
                                image: AssetImage("assets/images/bg5.jpg"),
                                fit: BoxFit.cover,
                              ),

                              // gradient: LinearGradient(
                              //   colors: [
                              //     mod['color1'] as Color,
                              //     mod['color2'] as Color,
                              //   ],
                              //   begin: Alignment.topLeft,
                              //   end: Alignment.bottomRight,
                              // ),
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 6.r,
                                  offset: Offset(2.w, 3.h),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  mod['icon'] as IconData,
                                  color: Colors.white,
                                  size: 40.sp,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  mod['title'] as String,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            currentIndex: 0,
            onTap: (index) {},
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.medication),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_fill),
                label: 'Training',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital),
                label: 'Doctors',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
