// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/leaflet.dart';

class LeafletDetailScreen extends StatefulWidget {
  final Leaflet leaflet;

  const LeafletDetailScreen({Key? key, required this.leaflet})
    : super(key: key);

  @override
  State<LeafletDetailScreen> createState() => _LeafletDetailScreenState();
}

class _LeafletDetailScreenState extends State<LeafletDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutQuad,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.leaflet.title),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.leaflet.productName ?? 'Unknown Product',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Metadata Section
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        label: 'Language',
                        value: widget.leaflet.language.toUpperCase(),
                        icon: Icons.language,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildInfoCard(
                        label: 'Version',
                        value: 'v${widget.leaflet.version ?? '1.0'}',
                        icon: Icons.info,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildInfoCard(
                        label: 'Status',
                        value: widget.leaflet.status,
                        icon: Icons.check_circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // File Information
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('File Type:', widget.leaflet.fileType),
                        Divider(height: 16.h),
                        _buildDetailRow(
                          'File Size:',
                          widget.leaflet.fileSizeKb != null
                              ? '${widget.leaflet.fileSizeKb!.toStringAsFixed(2)} KB'
                              : 'N/A',
                        ),
                        Divider(height: 16.h),
                        _buildDetailRow(
                          'Downloads:',
                          '${widget.leaflet.downloadCount}',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Dates Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          'Created:',
                          _formatDate(widget.leaflet.createdAt),
                        ),
                        Divider(height: 16.h),
                        _buildDetailRow(
                          'Updated:',
                          _formatDate(widget.leaflet.updatedAt),
                        ),
                        if (widget.leaflet.approvalDate != null) ...[
                          Divider(height: 16.h),
                          _buildDetailRow(
                            'Approved:',
                            _formatDate(widget.leaflet.approvalDate),
                          ),
                        ],
                        if (widget.leaflet.expiryDate != null) ...[
                          Divider(height: 16.h),
                          _buildDetailRow(
                            'Expires:',
                            _formatDate(widget.leaflet.expiryDate),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Description
                if (widget.leaflet.description != null &&
                    widget.leaflet.description!.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        widget.leaflet.description!,
                        style: TextStyle(height: 1.6.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                // Dosage Information
                if (widget.leaflet.dosageInformation != null &&
                    widget.leaflet.dosageInformation!.isNotEmpty) ...[
                  Text(
                    'Dosage Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        widget.leaflet.dosageInformation!,
                        style: TextStyle(height: 1.6.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                // Side Effects
                if (widget.leaflet.sideEffects != null &&
                    widget.leaflet.sideEffects!.isNotEmpty) ...[
                  Text(
                    'Side Effects',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ..._buildTagList(widget.leaflet.sideEffects, Colors.red),
                  SizedBox(height: 16.h),
                ],

                // Contraindications
                if (widget.leaflet.contraindications != null &&
                    widget.leaflet.contraindications!.isNotEmpty) ...[
                  Text(
                    'Contraindications',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ..._buildTagList(
                    widget.leaflet.contraindications,
                    Colors.orange,
                  ),
                  SizedBox(height: 16.h),
                ],

                // Drug Interactions
                if (widget.leaflet.drugInteractions != null &&
                    widget.leaflet.drugInteractions!.isNotEmpty) ...[
                  Text(
                    'Drug Interactions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ..._buildTagList(
                    widget.leaflet.drugInteractions,
                    Colors.blue,
                  ),
                  SizedBox(height: 16.h),
                ],

                // Storage Instructions
                if (widget.leaflet.storageInstructions != null &&
                    widget.leaflet.storageInstructions!.isNotEmpty) ...[
                  Text(
                    'Storage Instructions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        widget.leaflet.storageInstructions!,
                        style: TextStyle(height: 1.6.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                // Warnings
                if (widget.leaflet.warnings != null &&
                    widget.leaflet.warnings!.isNotEmpty) ...[
                  Text(
                    'Warnings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ..._buildTagList(widget.leaflet.warnings, Colors.red),
                  SizedBox(height: 16.h),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Download started...'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Share functionality coming soon!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 24.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTagList(List<String>? tags, Color color) {
    if (tags == null || tags.isEmpty) return [];
    return [
      Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: tags
            .map(
              (tag) => Chip(
                label: Text(
                  tag,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
                backgroundColor: color,
              ),
            )
            .toList(),
      ),
    ];
  }
}
