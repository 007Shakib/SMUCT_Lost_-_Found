import 'package:flutter/material.dart';
import '../../models/item_model.dart';

/// Item Detail Screen (View photograph, details, and trigger Claim Action)
class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as ItemModel?;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Item Detail')),
        body: const Center(child: Text('Item not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              item.imageUrl,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey[800],
                child: const Icon(Icons.image_not_supported, size: 64),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: item.status == 'Lost'
                              ? Colors.red.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.status.toUpperCase(),
                          style: TextStyle(
                            color: item.status == 'Lost' ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'Category: ${item.category}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: Colors.blueAccent),
                      const SizedBox(width: 4),
                      Text(item.location, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Item Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Posted by ${item.authorName}'),
                    subtitle: Text('Posted on ${item.datePosted.toString().split(' ')[0]}'),
                  ),
                  const SizedBox(height: 24),
                  if (item.status == 'Found')
                    ElevatedButton.icon(
                      icon: const Icon(Icons.verified_user),
                      label: const Text('Submit Claim Request (UC-07)'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF0284C7),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/submit-claim', arguments: item);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
