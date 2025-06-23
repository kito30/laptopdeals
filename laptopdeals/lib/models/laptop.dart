class Laptop {
  const Laptop({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.cpu,
    required this.gpu,
    required this.ram,
    required this.screenSize,
    required this.refreshRate,
  });

  final String? id;
  final String? name;
  final double? price;
  final String? imagePath;
  final String? description;
  final String? cpu;
  final String? gpu;
  final String? ram;
  final String? screenSize;
  final String? refreshRate;
}
