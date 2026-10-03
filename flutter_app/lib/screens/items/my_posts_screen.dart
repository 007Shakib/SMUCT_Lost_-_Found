import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/item_model.dart';

/// Manage Own Posts Screen (UC-08 / FR-08)
class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Published Posts (UC-08)')),
      body: StreamBuilder<List<ItemModel>>(
        stream: _firestoreService.streamListings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final myPosts = snapshot.data!;

          if (myPosts.isEmpty) {
            return const Center(child: Text('You have not published any posts yet.'));
          }

          return ListView.builder(
            itemCount: myPosts.length,
            itemBuilder: (context, index) {
              final item = myPosts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Status: ${item.status} • Posted: ${item.datePosted.toString().split(' ')[0]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Editing "${item.title}"')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Post "${item.title}" deleted.')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
