import 'package:flutter/material.dart';
import '../models/leaflet.dart';

class LeafletDetailScreen extends StatelessWidget {
  final Leaflet leaflet;

  const LeafletDetailScreen({Key? key, required this.leaflet})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(leaflet.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language: ${leaflet.language}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text('Version: ${leaflet.version ?? 'N/A'}'),
            const SizedBox(height: 8.0),
            Text('File Type: ${leaflet.fileType}'),
            const SizedBox(height: 8.0),
            Text('Description: ${leaflet.description ?? 'N/A'}'),
            const SizedBox(height: 8.0),
            Text('Dosage Information: ${leaflet.dosageInformation ?? 'N/A'}'),
            const SizedBox(height: 8.0),
            Text('Side Effects: ${leaflet.sideEffects?.join(', ') ?? 'N/A'}'),
            const SizedBox(height: 8.0),
            Text(
              'Contraindications: ${leaflet.contraindications?.join(', ') ?? 'N/A'}',
            ),
            const SizedBox(height: 8.0),
            Text(
              'Drug Interactions: ${leaflet.drugInteractions?.join(', ') ?? 'N/A'}',
            ),
            const SizedBox(height: 8.0),
            Text(
              'Storage Instructions: ${leaflet.storageInstructions ?? 'N/A'}',
            ),
            const SizedBox(height: 8.0),
            Text('Warnings: ${leaflet.warnings?.join(', ') ?? 'N/A'}'),
            const SizedBox(height: 8.0),
            Text('Status: ${leaflet.status}'),
            const SizedBox(height: 8.0),
            Text('Download Count: ${leaflet.downloadCount}'),
          ],
        ),
      ),
    );
  }
}
