import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopdeals/models/laptop.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;

final laptopProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance.collection('laptops').snapshots().map((
    snapshot,
  ) {
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'brand': data['brand'],
          'cpuBrand': data['cpuBrand'],
          'description': data['description'],
          'gpuBrand': data['gpuBrand'],
          'imagePath': data['imagePath'],
          'name': data['name'],
          'price': data['price'],
          'ram': data['ram'],
          'refreshRate': data['refreshRate'],
          'screenSize': data['screenSize'],
        };
      }).toList();
    }
    return <Map<String, dynamic>>[];
  });
});

final laptopListProvider = Provider<List<Laptop>>((ref) {
  final laptop = ref.watch(laptopProvider);
  return laptop.when(
    data: (data) {
      return data.map((laptop) {
        return Laptop(
          id: laptop['id'],
          name: laptop['name'],
          price: laptop['price'],
          imagePath: laptop['imagePath'],
          description: laptop['description'],
          cpu: laptop['cpuBrand'],
          gpu: laptop['gpuBrand'],
          ram: laptop['ram'],
          screenSize: laptop['screenSize'],
          refreshRate: laptop['refreshRate'],
        );
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
