class ItemModel {
  final String itemId;
  final String userId;
  final String categoryId;
  final String title;
  final String description;
  final String status; // 'Lost' or 'Found'
  final String claimStatus; // 'Available', 'Pending', 'Claimed'
  final String imageUrl;
  final String location;
  final DateTime datePosted;
  final String authorName;

  ItemModel({
    required this.itemId,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.status,
    required this.claimStatus,
    required this.imageUrl,
    required this.location,
    required this.datePosted,
    required this.authorName,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map, String id) {
    return ItemModel(
      itemId: id,
      userId: map['userId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'Lost',
      claimStatus: map['claimStatus'] ?? 'Available',
      imageUrl: map['imageUrl'] ?? '',
      location: map['location'] ?? '',
      datePosted: (map['datePosted'] != null)
          ? DateTime.parse(map['datePosted'])
          : DateTime.now(),
      authorName: map['authorName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'status': status,
      'claimStatus': claimStatus,
      'imageUrl': imageUrl,
      'location': location,
      'datePosted': datePosted.toIso8601String(),
      'authorName': authorName,
    };
  }
}
