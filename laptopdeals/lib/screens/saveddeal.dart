import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopdeals/provider/savedealprovider.dart';

class SavedDeals extends ConsumerWidget {
  const SavedDeals({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedDeals = ref.watch(saveDealProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Deals')),
      body: Center(
        child: ListView.builder(
          itemCount: savedDeals.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 100,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.network(savedDeals.toList()[index].imagePath!),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(savedDeals.toList()[index].name!),
                            Text(savedDeals.toList()[index].price.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
