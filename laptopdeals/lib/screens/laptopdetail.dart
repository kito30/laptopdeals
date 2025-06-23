import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopdeals/models/laptop.dart';
import 'package:laptopdeals/provider/savedealprovider.dart';

class LaptopDetails extends ConsumerWidget {
  const LaptopDetails({super.key, required this.laptop});

  final Laptop laptop;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedDealsNotifier = ref.watch(saveDealProvider);
    return Scaffold(
      appBar: AppBar(title: Text(laptop.name ?? '')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            color: Colors.grey[100], // Background color
            child: Image.network(
              laptop.imagePath!,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.laptop, size: 100, color: Colors.grey),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[100]),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Laptop Name
                  Text(
                    laptop.name ?? 'Unknown Laptop',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    '\$${laptop.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        laptop.description ?? 'No description available',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Specifications
                  const Text(
                    'Specifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Column(
                    children: [
                      if (laptop.cpu != null && laptop.cpu!.isNotEmpty)
                        _buildSpecRow('CPU', laptop.cpu!),
                      if (laptop.gpu != null && laptop.gpu!.isNotEmpty)
                        _buildSpecRow('GPU', laptop.gpu!),
                      if (laptop.ram != null && laptop.ram!.isNotEmpty)
                        _buildSpecRow('RAM', laptop.ram!),
                      if (laptop.screenSize != null &&
                          laptop.screenSize!.isNotEmpty)
                        _buildSpecRow('Screen Size', '${laptop.screenSize}"'),
                      if (laptop.refreshRate != null &&
                          laptop.refreshRate!.isNotEmpty)
                        _buildSpecRow(
                          'Refresh Rate',
                          '${laptop.refreshRate}Hz',
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!savedDealsNotifier.contains(laptop))
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(saveDealProvider.notifier).saveDeal(laptop);
                        },
                        child: const Text('Save Deal'),
                      ),
                    ),
                  if (savedDealsNotifier.contains(laptop))
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(saveDealProvider.notifier)
                              .removeDeal(laptop);
                        },
                        child: const Text('Remove Deal'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
