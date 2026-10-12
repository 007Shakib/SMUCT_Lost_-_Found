import '../models/category_model.dart';
import '../models/claim_model.dart';
import '../models/item_model.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';

/// Centralized local mock data for SMUCT Lost & Found Portal
class MockData {
  // Mock Categories
  static final List<CategoryModel> categories = [
    CategoryModel(categoryId: 'cat_0', categoryName: 'All', iconName: 'apps'),
    CategoryModel(categoryId: 'cat_1', categoryName: 'Electronics', iconName: 'devices'),
    CategoryModel(categoryId: 'cat_2', categoryName: 'Documents', iconName: 'description'),
    CategoryModel(categoryId: 'cat_3', categoryName: 'Bags', iconName: 'work'),
    CategoryModel(categoryId: 'cat_4', categoryName: 'Keys', iconName: 'vpn_key'),
    CategoryModel(categoryId: 'cat_5', categoryName: 'Clothing', iconName: 'checkroom'),
    CategoryModel(categoryId: 'cat_6', categoryName: 'Accessories', iconName: 'watch'),
    CategoryModel(categoryId: 'cat_7', categoryName: 'Other', iconName: 'more_horiz'),
  ];

  // Mock Current User
  static UserModel currentUser = UserModel(
    userId: 'usr_student_01',
    name: 'Mahin Mia',
    email: 'mahin.mia@smuct.edu.bd',
    phoneNumber: '+880 1712-345678',
    role: 'Student',
    department: 'Computer Science & Engineering',
    studentId: '213014002',
    profilePhotoUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400',
  );

  // Mock All Users for Admin
  static final List<UserModel> users = [
    currentUser,
    UserModel(
      userId: 'usr_staff_01',
      name: 'Nusrat Jahan',
      email: 'nusrat.jahan@smuct.edu.bd',
      phoneNumber: '+880 1819-876543',
      role: 'Teacher & Staff',
      department: 'Faculty of Design',
      profilePhotoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    ),
    UserModel(
      userId: 'usr_student_02',
      name: 'Tanvir Hossain',
      email: 'tanvir.221@smuct.edu.bd',
      phoneNumber: '+880 1911-223344',
      role: 'Student',
      department: 'Graphic Design',
      studentId: '221015089',
      profilePhotoUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=400',
    ),
    UserModel(
      userId: 'usr_admin_01',
      name: 'SMUCT Admin',
      email: 'admin@smuct.edu.bd',
      phoneNumber: '+880 1700-000000',
      role: 'Admin',
      department: 'IT & Campus Safety',
    ),
  ];

  // Mock Items
  static final List<ItemModel> items = [
    ItemModel(
      itemId: 'itm_001',
      userId: 'usr_staff_01',
      categoryId: 'Documents',
      title: 'Student ID Card & Black Wallet',
      description: 'Found a black leather wallet containing a SMUCT Student ID card (Batch 34th) and library card near the study desk.',
      status: 'Found',
      claimStatus: 'Available',
      imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600',
      location: 'Central Library (3rd Floor)',
      datePosted: DateTime.now().subtract(const Duration(hours: 3)),
      authorName: 'Nusrat Jahan',
    ),
    ItemModel(
      itemId: 'itm_002',
      userId: 'usr_student_01',
      categoryId: 'Electronics',
      title: 'Apple AirPods Pro Charging Case',
      description: 'Lost my white AirPods Pro case with a navy blue protective sleeve during lunch around 1:30 PM.',
      status: 'Lost',
      claimStatus: 'Available',
      imageUrl: 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600',
      location: 'Main Campus Cafeteria',
      datePosted: DateTime.now().subtract(const Duration(hours: 6)),
      authorName: 'Mahin Mia',
    ),
    ItemModel(
      itemId: 'itm_003',
      userId: 'usr_student_02',
      categoryId: 'Bags',
      title: 'Navy Blue Backpack (HP Laptop inside)',
      description: 'Found a dark blue HP backpack left on a bench outside Room 402 after the Graphic Design lecture.',
      status: 'Found',
      claimStatus: 'Pending',
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
      location: 'Building 2 (4th Floor)',
      datePosted: DateTime.now().subtract(const Duration(days: 1)),
      authorName: 'Tanvir Hossain',
    ),
    ItemModel(
      itemId: 'itm_004',
      userId: 'usr_student_01',
      categoryId: 'Keys',
      title: 'Car Keys with SMUCT Keychain',
      description: 'Lost Toyota car smart key with a silver metal SMUCT emblem keychain near the basement parking.',
      status: 'Lost',
      claimStatus: 'Available',
      imageUrl: 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600',
      location: 'Basement Parking Lot',
      datePosted: DateTime.now().subtract(const Duration(days: 2)),
      authorName: 'Mahin Mia',
    ),
    ItemModel(
      itemId: 'itm_005',
      userId: 'usr_staff_01',
      categoryId: 'Accessories',
      title: 'Casio G-Shock Matte Black Watch',
      description: 'Found a black digital G-Shock wrist watch in the washroom on 2nd floor.',
      status: 'Found',
      claimStatus: 'Claimed',
      imageUrl: 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600',
      location: 'Main Building 2nd Floor',
      datePosted: DateTime.now().subtract(const Duration(days: 3)),
      authorName: 'Nusrat Jahan',
    ),
  ];

  // Mock Claims
  static final List<ClaimModel> claims = [
    ClaimModel(
      claimId: 'clm_001',
      itemId: 'itm_001',
      claimantId: 'usr_student_01',
      itemTitle: 'Student ID Card & Black Wallet',
      justification: 'The ID card inside belongs to me (Mahin Mia, ID: 213014002). It also contains my Dutch-Bangla Bank ATM card.',
      status: 'Pending',
      dateSubmitted: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ClaimModel(
      claimId: 'clm_002',
      itemId: 'itm_003',
      claimantId: 'usr_student_01',
      itemTitle: 'Navy Blue Backpack (HP Laptop inside)',
      justification: 'The laptop inside is an HP Pavilion 15 with a sticker of Flutter framework on the lid.',
      status: 'Approved',
      dateSubmitted: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ClaimModel(
      claimId: 'clm_003',
      itemId: 'itm_005',
      claimantId: 'usr_student_02',
      itemTitle: 'Casio G-Shock Matte Black Watch',
      justification: 'The watch has a small scratch on the back buckle and set to 24-hour format.',
      status: 'Rejected',
      dateSubmitted: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Mock Notifications
  static final List<NotificationModel> notifications = [
    NotificationModel(
      notificationId: 'notif_1',
      userId: 'usr_student_01',
      title: 'Claim Update',
      body: 'Your claim for "Navy Blue Backpack" has been APPROVED by the administrator.',
      message: 'Your claim for "Navy Blue Backpack" has been APPROVED by the administrator.',
      type: 'claim_update',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      isRead: false,
    ),
    NotificationModel(
      notificationId: 'notif_2',
      userId: 'usr_student_01',
      title: 'New Claim Received',
      body: 'Someone submitted a claim for the "Student ID Card & Black Wallet" you reported.',
      message: 'Someone submitted a claim for the "Student ID Card & Black Wallet" you reported.',
      type: 'claim_update',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationModel(
      notificationId: 'notif_3',
      userId: 'usr_student_01',
      title: 'Post Approved',
      body: 'Your lost item report for "Apple AirPods Pro Charging Case" is now live.',
      message: 'Your lost item report for "Apple AirPods Pro Charging Case" is now live.',
      type: 'post_moderation',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: true,
    ),
    NotificationModel(
      notificationId: 'notif_4',
      userId: 'usr_student_01',
      title: 'System Notice',
      body: 'Welcome to SMUCT Lost & Found Portal! Keep campus safe and organized.',
      message: 'Welcome to SMUCT Lost & Found Portal! Keep campus safe and organized.',
      type: 'system',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
  ];

  // Mock Statistics for Admin Dashboard
  static final Map<String, dynamic> adminStats = {
    'totalUsers': 1248,
    'activeListings': 86,
    'lostItems': 52,
    'foundItems': 34,
    'pendingClaims': 12,
    'resolvedClaims': 142,
    'approvedClaims': 118,
    'rejectedClaims': 24,
  };
}
