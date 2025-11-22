// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/leaflet.dart';
import 'leaflet_detail_screen.dart';

class LeafletCard extends StatelessWidget {
  final Leaflet leaflet;
  final VoidCallback onRefresh;

  const LeafletCard({Key? key, required this.leaflet, required this.onRefresh})
    : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getLanguageLabel(String language) {
    const languageMap = {'en': 'EN', 'ur': 'UR', 'es': 'ES', 'fr': 'FR'};
    return languageMap[language.toLowerCase()] ?? language.toUpperCase();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'draft':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  LeafletDetailScreen(leaflet: leaflet),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Product Name and Menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leaflet.productName ?? 'Unknown Product',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          leaflet.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'view':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LeafletDetailScreen(leaflet: leaflet),
                            ),
                          );
                          break;
                        case 'download':
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Download started...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          break;
                        case 'share':
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Share functionality coming soon!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          break;
                        case 'favorite':
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 18),
                            SizedBox(width: 8),
                            Text('View'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'download',
                        child: Row(
                          children: [
                            Icon(Icons.download, size: 18),
                            SizedBox(width: 8),
                            Text('Download'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share, size: 18),
                            SizedBox(width: 8),
                            Text('Share'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'favorite',
                        child: Row(
                          children: [
                            Icon(Icons.favorite_border, size: 18),
                            SizedBox(width: 8),
                            Text('Favorite'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Badges Row: Version, Language, Status
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  // Version Badge
                  Chip(
                    label: Text(
                      'v${leaflet.version ?? '1.0'}',
                      style: TextStyle(fontSize: 11.sp, color: Colors.white),
                    ),
                    backgroundColor: Colors.blue.shade600,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                  ),

                  // Language Chip
                  Chip(
                    label: Text(
                      _getLanguageLabel(leaflet.language),
                      style: TextStyle(fontSize: 11.sp, color: Colors.white),
                    ),
                    backgroundColor: Colors.teal.shade600,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                  ),

                  // Status Chip
                  Chip(
                    label: Text(
                      leaflet.status,
                      style: TextStyle(fontSize: 11.sp, color: Colors.white),
                    ),
                    backgroundColor: _getStatusColor(leaflet.status),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Meta Information Row: Date and Downloads
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Updated',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatDate(leaflet.updatedAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Downloads',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.download_rounded,
                            size: 14.sp,
                            color: Colors.blue.shade600,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${leaflet.downloadCount}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Featured Indicator
              if (leaflet.isFeatured)
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      border: Border.all(color: Colors.amber.shade300),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14.sp,
                          color: Colors.amber.shade700,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Featured',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber.shade700,
                          ),
                        ),
                      ],
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
