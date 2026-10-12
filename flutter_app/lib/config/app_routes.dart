import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/main_navigation_screen.dart';
import '../screens/feed/home_feed_screen.dart';
import '../screens/feed/search_filter_screen.dart';
import '../screens/feed/item_detail_screen.dart';
import '../screens/items/report_item_screen.dart';
import '../screens/items/edit_item_screen.dart';
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
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String homeFeed = '/home-feed';
  static const String searchFilter = '/search-filter';
  static const String itemDetail = '/item-detail';
  static const String reportItem = '/report-item';
  static const String editItem = '/edit-item';
  static const String myPosts = '/my-posts';
  static const String submitClaim = '/submit-claim';
  static const String myClaims = '/my-claims';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String adminDashboard = '/admin';
  static const String manageUsers = '/admin/users';
  static const String moderatePosts = '/admin/posts';
  static const String approveClaims = '/admin/claims';
  static const String platformStats = '/admin/stats';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      home: (context) => const MainNavigationScreen(),
      homeFeed: (context) => const HomeFeedScreen(),
      searchFilter: (context) => const SearchFilterScreen(),
      itemDetail: (context) => const ItemDetailScreen(),
      reportItem: (context) => const ReportItemScreen(),
      editItem: (context) => const EditItemScreen(),
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
