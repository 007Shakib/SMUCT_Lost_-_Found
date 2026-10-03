import 'dart:io';

/// Cloud Storage Service (UC-04 Image Upload, NFR-07 Max 5MB Compression)
class StorageService {
  /// Upload item photograph to Cloud Storage and return public image URL
  Future<String> uploadItemImage(File imageFile) async {
    // Simulate image compression check (NFR-07) and Cloud Storage upload
    await Future.delayed(const Duration(milliseconds: 1000));
    return 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=500&auto=format&fit=crop&q=80';
  }

  /// Delete image from Cloud Storage when post is removed
  Future<void> deleteItemImage(String imageUrl) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
