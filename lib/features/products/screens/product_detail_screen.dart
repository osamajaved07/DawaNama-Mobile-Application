// ignore_for_file: depend_on_referenced_packages

import 'package:dawanama/features/products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(title: Text(product.name, style: GoogleFonts.poppins())),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrl != null)
              Center(
                child: Image.network(
                  product.imageUrl!,
                  height: 180.h,
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(height: 12.h),
            Text(
              product.name,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'SKU: ${product.sku}',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                if (product.mrp != null)
                  Chip(label: Text('MRP: ${product.mrp!.toStringAsFixed(0)}')),
                SizedBox(width: 8.w),
                if (product.tradePrice != null)
                  Chip(
                    label: Text(
                      'Trade: ${product.tradePrice!.toStringAsFixed(0)}',
                    ),
                  ),
                SizedBox(width: 8.w),
                Chip(label: Text(product.status)),
              ],
            ),
            SizedBox(height: 14.h),
            if (product.description != null)
              Text(
                product.description!,
                style: GoogleFonts.poppins(fontSize: 14.sp),
              ),
            SizedBox(height: 14.h),
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
            SizedBox(height: 18.h),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: product.leafletsUrl != null
                      ? () => _openUrl(product.leafletsUrl!)
                      : null,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('View Leaflet'),
                ),
                SizedBox(width: 12.w),
                ElevatedButton.icon(
                  onPressed: product.targetSpecialty != null ? () {} : null,
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
