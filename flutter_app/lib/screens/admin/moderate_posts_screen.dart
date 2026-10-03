import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/item_model.dart';

/// Moderate Posts Screen (UC-11 / FR-11)
class ModeratePostsScreen extends StatelessWidget {
  const ModeratePostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Moderate Posts (UC-11 / FR-11)')),
      body: StreamBuilder<List<ItemModel>>(
        stream: firestoreService.streamListings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final item = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Author: ${item.authorName} • Location: ${item.location}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Post "${item.title}" removed from public feed (UC-11).')),
                      );
                    },
                    child: const Text('Remove Post'),
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
