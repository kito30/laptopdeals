import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptopdeals/services/devicepicker/imagepicker.dart';
import '../provider/readspec.dart';
import '../services/storage/firestorage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class DealForm extends ConsumerStatefulWidget {
  const DealForm({super.key});

  @override
  ConsumerState<DealForm> createState() => _DealFormState();
}

class _DealFormState extends ConsumerState<DealForm> {
  // create form key, idk, validate all form ?
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? selectedBrand;
  String? selectedCpuBrand;
  String? selectedGpuBrand;
  String? selectedRam;
  String? selectedScreenSize;
  String? selectedRefreshRate;
  File? selectedImage;
  bool isPickingImage = false; // Add this to prevent multiple picker calls

  bool isSaving = false;

  Future<void> _saveDeal(context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaving = true;
      });

      try {
        final imageUrl = await uploadImage(selectedImage);
        await FirebaseFirestore.instance.collection('laptops').add({
          'id': const Uuid().v4(),
          'name': _nameController.text.trim(),
          'price': double.parse(_priceController.text),
          'description': _descriptionController.text.trim(),
          'brand': selectedBrand,
          'cpuBrand': selectedCpuBrand,
          'gpuBrand': selectedGpuBrand,
          'ram': selectedRam,
          'screenSize': selectedScreenSize,
          'refreshRate': selectedRefreshRate,
          'imagePath': imageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Clear form after successful save
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        setState(() {
          selectedBrand = null;
          selectedCpuBrand = null;
          selectedGpuBrand = null;
          selectedRam = null;
          selectedScreenSize = null;
          selectedRefreshRate = null;
          selectedImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Laptop deal saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving deal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isSaving = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brands = ref.watch(brandsProvider);
    final cpuBrands = ref.watch(cpuBrandsProvider);
    final gpuBrands = ref.watch(gpuBrandsProvider);
    final ramOptions = ref.watch(ramOptionsProvider);
    final screenSizes = ref.watch(screenSizesProvider);
    final refreshRates = ref.watch(refreshRatesProvider);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Input
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Laptop Name *',
                hintText: 'e.g., Dell XPS 15',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.laptop),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter laptop name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            //Input image from user
            SizedBox(
              height: 200,
              width: 200,
              child: InkWell(
                onTap: () async {
                  final image = await pickImageFromGallery();
                  if (image != null) {
                    setState(() {
                      selectedImage = image;
                    });
                  }
                },
                child:
                    selectedImage != null
                        ? Image.file(selectedImage!)
                        : const Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 20),
            // Price Input
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price *',
                hintText: '999.99',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: '\$ ',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter price';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Description Input
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description of the laptop deal...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
              ),
              maxLines: 3,
              validator: (value) {
                if (value != null &&
                    value.trim().isNotEmpty &&
                    value.trim().length < 10) {
                  return 'Description should be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // Specs Section Header
            const Text(
              'Laptop Specifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Brand Dropdown
            DropdownButtonFormField<String>(
              value: selectedBrand,
              decoration: const InputDecoration(
                labelText: 'Brand *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              items:
                  brands.map((brand) {
                    return DropdownMenuItem(value: brand, child: Text(brand));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBrand = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a brand';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // CPU Brand Dropdown
            DropdownButtonFormField<String>(
              value: selectedCpuBrand,
              decoration: const InputDecoration(
                labelText: 'CPU Brand *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.memory),
              ),
              items:
                  cpuBrands.map((cpu) {
                    return DropdownMenuItem(value: cpu, child: Text(cpu));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCpuBrand = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a CPU brand';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // GPU Brand Dropdown
            DropdownButtonFormField<String>(
              value: selectedGpuBrand,
              decoration: const InputDecoration(
                labelText: 'GPU Brand *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.videogame_asset),
              ),
              items:
                  gpuBrands.map((gpu) {
                    return DropdownMenuItem(value: gpu, child: Text(gpu));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGpuBrand = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a GPU brand';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // RAM Dropdown
            DropdownButtonFormField<String>(
              value: selectedRam,
              decoration: const InputDecoration(
                labelText: 'RAM *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.storage),
              ),
              items:
                  ramOptions.map((ram) {
                    return DropdownMenuItem(value: ram, child: Text(ram));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRam = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select RAM';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Screen Size Dropdown
            DropdownButtonFormField<String>(
              value: selectedScreenSize,
              decoration: const InputDecoration(
                labelText: 'Screen Size *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor),
              ),
              items:
                  screenSizes.map((size) {
                    return DropdownMenuItem(value: size, child: Text('$size"'));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedScreenSize = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select screen size';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Refresh Rate Dropdown
            DropdownButtonFormField<String>(
              value: selectedRefreshRate,
              decoration: const InputDecoration(
                labelText: 'Refresh Rate *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.refresh),
              ),
              items:
                  refreshRates.map((rate) {
                    return DropdownMenuItem(
                      value: rate,
                      child: Text('${rate}Hz'),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRefreshRate = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select refresh rate';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: isSaving ? null : () => _saveDeal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  isSaving
                      // Loading screen
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Text(
                        'Save Deal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
