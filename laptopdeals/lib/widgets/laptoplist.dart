import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopdeals/provider/readlaptop.dart';
import 'package:laptopdeals/widgets/productcart.dart';

class LaptopList extends ConsumerWidget {
  const LaptopList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final laptopList = ref.watch(laptopListProvider);
    return ListView.builder(
      itemCount: laptopList.length,
      itemBuilder: (context, index) {
        return ProductCard(laptop: laptopList[index]);
      },
    );
  }
}
