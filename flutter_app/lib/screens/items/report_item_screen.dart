import 'package:flutter/material.dart';
import '../../models/item_model.dart';
import '../../services/firestore_service.dart';

/// Report Lost or Found Item Screen (UC-04 / FR-03, FR-04)
class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({super.key});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _status = 'Lost'; // 'Lost' or 'Found'
  String _category = 'Electronics';
  bool _isLoading = false;
  final _firestoreService = FirestoreService();

  final List<String> _categories = [
    'Electronics',
    'Documents & IDs',
    'Bags & Wallets',
    'Accessories',
    'Keys',
    'Clothing'
  ];

  void _handleSubmitReport() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final newItem = ItemModel(
      itemId: 'itm_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'usr_student_01',
      categoryId: _category,
      title: _titleController.text,
      description: _descriptionController.text,
      status: _status,
      claimStatus: 'Available',
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=500&auto=format&fit=crop&q=80',
      location: _locationController.text.isEmpty ? 'Main Campus' : _locationController.text,
      datePosted: DateTime.now(),
      authorName: 'Mahin Mia',
    );

    await _firestoreService.addItemReport(newItem);
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item report published as $_status!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Item (UC-04)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Lost', label: Text('Report Lost Item'), icon: Icon(Icons.search_off)),
                ButtonSegment(value: 'Found', label: Text('Report Found Item'), icon: Icon(Icons.check_circle)),
              ],
              selected: {_status},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() => _status = newSelection.first);
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Item Title (e.g. Black Wallet, Apple AirPods)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _category = val!),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Campus Location (e.g. 3rd Floor Library, Cafeteria)',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Detailed Description & Identifying Marks',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 40, color: Color(0xFF0284C7)),
                  const SizedBox(height: 8),
                  const Text('Attach Item Photograph (Max 5 MB - NFR-07)'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take Photo'),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmitReport,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading ? const CircularProgressIndicator() : const Text('Publish Report'),
            ),
          ],
        ),
      ),
    );
  }
}
