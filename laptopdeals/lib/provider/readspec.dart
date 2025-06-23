import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider for specs data that automatically updates, update on the go
final specsProvider = StreamProvider<Map<String, List<String>>>((ref) {
  return FirebaseFirestore.instance
      .collection('laptopspecs')
      .doc('specs')
      .snapshots() // listen for live changes from firestore
      .map((doc) {
        if (doc.exists) {
          final data = doc.data()!;
          return {
            'brands': List<String>.from(data['brand'] ?? []),
            'cpuBrands': List<String>.from(data['cpubrand'] ?? []),
            'gpuBrands': List<String>.from(data['gpuBrands'] ?? []),
            'ramOptions': List<String>.from(data['ram'] ?? []),
            'screenSizes': List<String>.from(data['screenSize'] ?? []),
            'refreshRates': List<String>.from(data['refreshRate'] ?? []),
          };
        }
        // return empty map if doc does not exist
        else {
          return <String, List<String>>{};
        }
      });
});

//  providers for each spec type
final brandsProvider = Provider<List<String>>((ref) {
  final specs = ref.watch(specsProvider);
  return specs.when(
    data: (data) => data['brands'] ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
});

final cpuBrandsProvider = Provider<List<String>>((ref) {
  final specs = ref.watch(specsProvider);
  return specs.when(
    data: (data) => data['cpuBrands'] ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
});

final gpuBrandsProvider = Provider<List<String>>((ref) {
  final specs = ref.watch(specsProvider);
  return specs.when(
    data: (data) => data['gpuBrands'] ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
});

final ramOptionsProvider = Provider<List<String>>((ref) {
  final specs = ref.watch(specsProvider);
  return specs.when(
    data: (data) => data['ramOptions'] ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
});

final screenSizesProvider = Provider<List<String>>((ref) {
  final specs = ref.watch(specsProvider);
  return specs.when(
    data: (data) => data['screenSizes'] ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
});

final refreshRatesProvider = Provider<List<String>>((ref) {
  final specs = ref.watch(specsProvider);
  return specs.when(
    data: (data) => data['refreshRates'] ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
});
