import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/feed/home_feed_screen.dart';
import '../screens/feed/search_filter_screen.dart';
import '../screens/feed/item_detail_screen.dart';
import '../screens/items/report_item_screen.dart';
import '../screens/items/my_posts_screen.dart';
import '../screens/claims/submit_claim_screen.dart';
import '../screens/claims/my_claims_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/manage_users_screen.dart';
import '../screens/admin/moderate_posts_screen.dart';
import '../screens/admin/approve_claims_screen.dart';
import '../screens/admin/platform_stats_screen.dart';

/// Centralized Named Routes for SMUCT Lost & Found Portal
/// Maps all Use Cases (UC-01 through UC-13) to their respective views.
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';                  // UC-02
  static const String register = '/register';            // UC-01
  static const String homeFeed = '/home-feed';           // Main Feed
  static const String searchFilter = '/search-filter';   // UC-05, UC-06
  static const String itemDetail = '/item-detail';       // Item View
  static const String reportItem = '/report-item';       // UC-04
  static const String myPosts = '/my-posts';             // UC-08
  static const String submitClaim = '/submit-claim';     // UC-07
  static const String myClaims = '/my-claims';           // UC-07 Track
  static const String profile = '/profile';              // UC-03 / FR-14
  static const String notifications = '/notifications';  // UC-09 / FR-09
  static const String adminDashboard = '/admin';         // Admin Hub
  static const String manageUsers = '/admin/users';      // UC-10 / FR-10
  static const String moderatePosts = '/admin/posts';    // UC-11 / FR-11
  static const String approveClaims = '/admin/claims';   // UC-12 / FR-12
  static const String platformStats = '/admin/stats';    // UC-13 / FR-13

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      homeFeed: (context) => const HomeFeedScreen(),
      searchFilter: (context) => const SearchFilterScreen(),
      itemDetail: (context) => const ItemDetailScreen(),
      reportItem: (context) => const ReportItemScreen(),
      myPosts: (context) => const MyPostsScreen(),
      submitClaim: (context) => const SubmitClaimScreen(),
      myClaims: (context) => const MyClaimsScreen(),
      profile: (context) => const ProfileScreen(),
      notifications: (context) => const NotificationScreen(),
      adminDashboard: (context) => const AdminDashboardScreen(),
      manageUsers: (context) => const ManageUsersScreen(),
      moderatePosts: (context) => const ModeratePostsScreen(),
      approveClaims: (context) => const ApproveClaimsScreen(),
      platformStats: (context) => const PlatformStatsScreen(),
    };
  }
}
