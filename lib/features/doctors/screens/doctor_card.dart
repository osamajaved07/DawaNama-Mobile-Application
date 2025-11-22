import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: () {
          // Show doctor details dialog or navigate to detail screen
          _showDoctorDetails(context);
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Name and Specialty Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Circle
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade100,
                    ),
                    child: Center(
                      child: Text(
                        doctor.name.isNotEmpty
                            ? doctor.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        if (doctor.specialty != null &&
                            doctor.specialty!.isNotEmpty)
                          Text(
                            doctor.specialty!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Contact Information Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Phone
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 16.sp,
                          color: Colors.green.shade600,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            doctor.phone != null
                                ? '+92${doctor.phone.toString()}'
                                : 'N/A',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Email
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 16.sp,
                          color: Colors.orange.shade600,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            doctor.email ?? 'N/A',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Location Information
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14.sp,
                    color: Colors.red.shade600,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // City
                        if (doctor.city != null && doctor.city!.isNotEmpty)
                          Text(
                            doctor.city!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        // Clinic Address
                        Text(
                          doctor.clinicAddress,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Action Buttons
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Call Button
                  if (doctor.phone != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Call functionality coming soon!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(Icons.phone, size: 14.sp),
                        label: Text('Call', style: TextStyle(fontSize: 11.sp)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                  if (doctor.phone != null) SizedBox(width: 8.w),
                  // Email Button
                  if (doctor.email != null && doctor.email!.isNotEmpty)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email functionality coming soon!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(Icons.mail, size: 14.sp),
                        label: Text('Email', style: TextStyle(fontSize: 11.sp)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                  if (doctor.email != null && doctor.email!.isNotEmpty)
                    SizedBox(width: 8.w),
                  // Details Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showDoctorDetails(context);
                      },
                      icon: Icon(Icons.info, size: 14.sp),
                      label: Text('Details', style: TextStyle(fontSize: 11.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDoctorDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(doctor.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Specialty', doctor.specialty ?? 'N/A'),
              _buildDetailRow('City', doctor.city ?? 'N/A'),
              _buildDetailRow('Clinic Address', doctor.clinicAddress),
              _buildDetailRow(
                'Phone',
                doctor.phone != null ? '+92${doctor.phone}' : 'N/A',
              ),
              _buildDetailRow('Email', doctor.email ?? 'N/A'),
              _buildDetailRow('ID', doctor.id),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
