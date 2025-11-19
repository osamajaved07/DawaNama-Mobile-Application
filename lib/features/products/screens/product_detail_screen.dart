// ignore_for_file: depend_on_referenced_packages

import 'package:dawanama/features/products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: avoid_print
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: GoogleFonts.poppins()),
        backgroundColor: const Color.fromARGB(255, 133, 218, 218),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (product.imageUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    product.imageUrl!,
                    height: 180.h,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            SizedBox(height: 12.h),

            // Title and SKU / Created
            Text(
              product.name,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'SKU: ${product.sku}',
                    style: GoogleFonts.poppins(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy SKU',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: product.sku));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('SKU copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'Created: ${_formatDate(product.createdAt)}',
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12.sp),
            ),

            SizedBox(height: 12.h),

            // Status / Category / Manufacturer
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                Chip(label: Text(product.status)),
                if (product.category != null)
                  Chip(label: Text(product.category!)),
                if (product.manufacturer != null)
                  Chip(label: Text(product.manufacturer!)),
              ],
            ),

            SizedBox(height: 12.h),

            // Pricing and packing — use Wrap so chips can flow to next line on narrow screens
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                if (product.mrp != null)
                  Chip(label: Text('MRP: ${product.mrp!.toStringAsFixed(0)}')),
                if (product.tradePrice != null)
                  Chip(
                    label: Text(
                      'Trade: ${product.tradePrice!.toStringAsFixed(0)}',
                    ),
                  ),
                if (product.unitOfMeasure != null)
                  Chip(label: Text(product.unitOfMeasure!)),
                if (product.packSize != null)
                  Chip(label: Text('Pack: ${product.packSize!}')),
              ],
            ),

            SizedBox(height: 12.h),

            // Expiry handling
            if (product.expiryDateHandling)
              Row(
                children: [
                  Icon(
                    product.expiryDateHandling
                        ? Icons.event_available
                        : Icons.event_busy,
                    color: product.expiryDateHandling
                        ? Colors.green
                        : Colors.grey,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      product.expiryDateHandling
                          ? 'This product requires expiry date handling.'
                          : 'No expiry date tracking required.',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ],
              ),

            SizedBox(height: 14.h),

            // Description
            if (product.description != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    product.description!,
                    style: GoogleFonts.poppins(fontSize: 14.sp),
                  ),
                ],
              ),

            SizedBox(height: 14.h),

            // Key benefits
            if (product.keyBenefits != null && product.keyBenefits!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Benefits',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),
                  ...product.keyBenefits!.map(
                    (b) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check, size: 18.sp, color: Colors.green),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(b, style: GoogleFonts.poppins()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            SizedBox(height: 14.h),

            // Target specialties
            if (product.targetSpecialty != null &&
                product.targetSpecialty!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Specialty',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: product.targetSpecialty!
                        .map(
                          (s) => Chip(
                            label: Text(s),
                            backgroundColor: Colors.blue.shade50,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),

            SizedBox(height: 18.h),

            // Actions: View leaflet, Copy leaflet, Share — use Wrap so buttons can wrap on small screens
            Wrap(
              spacing: 12.w,
              runSpacing: 8.h,
              children: [
                ElevatedButton.icon(
                  onPressed: product.leafletsUrl != null
                      ? () => _openUrl(product.leafletsUrl!)
                      : null,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('View Leaflet'),
                ),
                ElevatedButton.icon(
                  onPressed: product.leafletsUrl != null
                      ? () {
                          Clipboard.setData(
                            ClipboardData(text: product.leafletsUrl!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Leaflet URL copied')),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Leaflet URL'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final shareText = StringBuffer();
                    shareText.writeln(product.name);
                    shareText.writeln('SKU: ${product.sku}');
                    if (product.mrp != null)
                      shareText.writeln('MRP: ${product.mrp}');
                    if (product.leafletsUrl != null)
                      shareText.writeln(product.leafletsUrl);
                    Clipboard.setData(
                      ClipboardData(text: shareText.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product info copied to clipboard'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    try {
      final d = dt.toLocal();
      // Format as DD-MM-YYYY HH:MM (day, month, year first)
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      final year = d.year.toString();
      final hour = d.hour.toString().padLeft(2, '0');
      final minute = d.minute.toString().padLeft(2, '0');
      return '$day-$month-$year $hour:$minute';
    } catch (e) {
      return dt.toString();
    }
  }
}
