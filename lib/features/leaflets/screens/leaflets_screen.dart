import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/leaflets_provider.dart';
import 'leaflet_detail_screen.dart'; // Import the LeafletDetailScreen

class LeafletsScreen extends ConsumerWidget {
  const LeafletsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leafletsAsyncValue = ref.watch(leafletsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Leaflets')),
      body: leafletsAsyncValue.when(
        data: (leaflets) => ListView.builder(
          itemCount: leaflets.length,
          itemBuilder: (context, index) {
            final leaflet = leaflets[index];
            return ListTile(
              title: Text(leaflet.title),
              subtitle: Text('Language: ${leaflet.language}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeafletDetailScreen(leaflet: leaflet),
                  ),
                );
              },
            );
          },
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.black)),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
