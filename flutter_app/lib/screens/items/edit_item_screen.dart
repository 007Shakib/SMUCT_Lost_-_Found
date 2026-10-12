import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../models/item_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Edit Item Screen with pre-filled fields
class EditItemScreen extends StatefulWidget {
  const EditItemScreen({super.key});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  late String _status;
  late String _selectedCategory;
  late String _imageUrl;
  ItemModel? _item;
  bool _isInit = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _item = ModalRoute.of(context)?.settings.arguments as ItemModel?;
      if (_item != null) {
        _titleController = TextEditingController(text: _item!.title);
        _descriptionController = TextEditingController(text: _item!.description);
        _locationController = TextEditingController(text: _item!.location);
        _status = _item!.status;
        _selectedCategory = _item!.category;
        _imageUrl = _item!.imageUrl;
      } else {
        _titleController = TextEditingController();
        _descriptionController = TextEditingController();
        _locationController = TextEditingController();
        _status = 'Lost';
        _selectedCategory = 'Electronics';
        _imageUrl = 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=600';
      }
      _isInit = true;
    }
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate() && _item != null) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 500));

      final index = MockData.items.indexWhere((i) => i.itemId == _item!.itemId);
      if (index != -1) {
        MockData.items[index] = ItemModel(
          itemId: _item!.itemId,
          userId: _item!.userId,
          categoryId: _selectedCategory,
          title: _titleController.text,
          description: _descriptionController.text,
          status: _status,
          claimStatus: _item!.claimStatus,
          imageUrl: _imageUrl,
          location: _locationController.text,
          datePosted: _item!.datePosted,
          authorName: _item!.authorName,
        );
      }

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Item')),
        body: const Center(child: Text('Item not found', style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Edit Item Report'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  label: 'Item Title',
                  controller: _titleController,
                  prefixIcon: Icons.title_rounded,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter item title';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: MockData.categories.any((c) => c.name == _selectedCategory) ? _selectedCategory : 'Electronics',
                      dropdownColor: AppTheme.cardSurface,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.cardSurface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: MockData.categories
                          .where((c) => c.name != 'All')
                          .map((c) => DropdownMenuItem(value: c.name, child: Text(c.name)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Campus Location',
                  controller: _locationController,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter location';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Detailed Description',
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter description';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: 'Save Changes',
                  isLoading: _isLoading,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
