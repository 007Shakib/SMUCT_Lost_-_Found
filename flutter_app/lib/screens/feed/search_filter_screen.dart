import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/item_model.dart';

/// Search and Filter Listings Screen (UC-05 Search / UC-06 Filter / FR-05, FR-06)
class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _firestoreService = FirestoreService();
  String _keyword = '';
  String _selectedCategory = 'All Categories';
  String _selectedStatus = 'All'; // 'All', 'Lost', 'Found'

  final List<String> _categories = [
    'All Categories',
    'Electronics',
    'Documents & IDs',
    'Bags & Wallets',
    'Accessories',
    'Keys'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter (UC-05 / UC-06)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _keyword = val),
                  decoration: InputDecoration(
                    hintText: 'Search by title, description, or keyword...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories
                            .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedCategory = val!),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        items: ['All', 'Lost', 'Found']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedStatus = val!),
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ItemModel>>(
              stream: _firestoreService.streamListings(
                category: _selectedCategory,
                status: _selectedStatus,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final results = snapshot.data!.where((item) {
                  return item.title.toLowerCase().contains(_keyword.toLowerCase()) ||
                      item.description.toLowerCase().contains(_keyword.toLowerCase());
                }).toList();

                if (results.isEmpty) {
                  return const Center(
                    child: Text('No matching lost or found items found.'),
                  );
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.status == 'Lost' ? Colors.red : Colors.green,
                        child: Icon(
                          item.status == 'Lost' ? Icons.search_off : Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${item.category} • ${item.location}'),
                      trailing: Text(
                        item.status,
                        style: TextStyle(
                          color: item.status == 'Lost' ? Colors.redAccent : Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(context, '/item-detail', arguments: item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
