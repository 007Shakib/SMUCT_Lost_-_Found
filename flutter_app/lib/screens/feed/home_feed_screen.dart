import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/item_model.dart';

/// Combined Lost & Found Home Feed Screen (Main Feed Navigation)
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _firestoreService = FirestoreService();
  String _selectedTab = 'All'; // 'All', 'Lost', 'Found'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMUCT Lost & Found'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-filter'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Mahin Mia'),
              accountEmail: Text('mahin.241071018@shanto-mariam.edu.bd'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF0F2B5C)),
              ),
              decoration: BoxDecoration(color: Color(0xFF0F172A)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home Feed'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Report Item (UC-04)'),
              onTap: () => Navigator.pushNamed(context, '/report-item'),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('My Published Posts (UC-08)'),
              onTap: () => Navigator.pushNamed(context, '/my-posts'),
            ),
            ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: const Text('My Claim Requests (UC-07)'),
              onTap: () => Navigator.pushNamed(context, '/my-claims'),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('My Profile (UC-03 / FR-14)'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'All', label: Text('All Items')),
                ButtonSegment(value: 'Lost', label: Text('Lost Items')),
                ButtonSegment(value: 'Found', label: Text('Found Items')),
              ],
              selected: {_selectedTab},
              onSelectionChanged: (val) => setState(() => _selectedTab = val.first),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ItemModel>>(
              stream: _firestoreService.streamListings(status: _selectedTab),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data!;

                if (items.isEmpty) {
                  return const Center(child: Text('No items to display.'));
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isLost = item.status == 'Lost';
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isLost ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isLost ? Icons.search_off : Icons.check_circle_outline,
                            color: isLost ? Colors.red : Colors.green,
                          ),
                        ),
                        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${item.category} • ${item.location}'),
                        trailing: Text(
                          item.status,
                          style: TextStyle(
                            color: isLost ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/item-detail', arguments: item),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/report-item'),
        backgroundColor: const Color(0xFF0284C7),
        icon: const Icon(Icons.add),
        label: const Text('Report Item'),
      ),
    );
  }
}
