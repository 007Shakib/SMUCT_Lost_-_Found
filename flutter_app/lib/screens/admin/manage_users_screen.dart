import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_search_bar.dart';

/// Admin User Management Screen (SRS Requirement 2)
/// Full Firebase Firestore Integration with Live Stream, Search, Role Badges,
/// Profile Inspection, Suspend/Reactivate, and Confirmed Deletion.
class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final AdminService _adminService = AdminService.instance;
  String _searchQuery = '';
  String _roleFilter = 'All'; // 'All', 'Student', 'Teacher & Staff', 'Admin', 'Suspended'

  @override
  void initState() {
    super.initState();
    // Enforce Admin authorization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AuthService().isAdmin) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access Denied: Administrator role required.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    });
  }

  void _showUserProfileModal(UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFE0F2FE),
                    backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                    child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                        ? Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7)),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                        const SizedBox(height: 2),
                        Text(user.email, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _buildRoleBadge(user.role),
                            const SizedBox(width: 6),
                            if (user.isSuspended)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(6)),
                                child: Text('SUSPENDED', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444))),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),

              Text('ACCOUNT DETAILS', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF64748B), letterSpacing: 0.6)),
              const SizedBox(height: 10),

              _buildDetailRow('User UID:', user.userId),
              _buildDetailRow('Department:', user.department ?? 'Not provided'),
              _buildDetailRow('Student ID / Staff Code:', user.studentId ?? 'N/A'),
              _buildDetailRow('Contact Phone:', user.phone.isNotEmpty ? user.phone : 'Not listed'),
              _buildDetailRow('Email Verified:', user.emailVerified ? 'Yes ✅' : 'Pending Verification ⚠️'),
              if (user.createdAt != null)
                _buildDetailRow('Registered On:', DateFormat('MMM d, yyyy • h:mm a').format(user.createdAt!)),

              const SizedBox(height: 24),

              // Action Buttons: Suspend/Reactivate & Delete
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: user.isSuspended ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        side: BorderSide(color: user.isSuspended ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showUserActionDialog(user, user.isSuspended ? 'Reactivate' : 'Suspend');
                      },
                      icon: Icon(user.isSuspended ? Icons.play_circle_outline_rounded : Icons.pause_circle_outline_rounded, size: 18),
                      label: Text(user.isSuspended ? 'Reactivate' : 'Suspend', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showUserActionDialog(user, 'Delete');
                      },
                      icon: const Icon(Icons.delete_forever_rounded, size: 18, color: Colors.white),
                      label: Text('Delete Account', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF0F172A), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showUserActionDialog(UserModel user, String action) {
    final isDelete = action == 'Delete';
    final isSuspend = action == 'Suspend';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isDelete ? Icons.delete_forever_rounded : (isSuspend ? Icons.pause_circle_rounded : Icons.play_circle_rounded),
              color: isDelete ? const Color(0xFFEF4444) : (isSuspend ? const Color(0xFFF59E0B) : const Color(0xFF10B981)),
            ),
            const SizedBox(width: 10),
            Text('$action User Account?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17)),
          ],
        ),
        content: Text(
          isDelete
              ? 'Are you completely sure you want to permanently delete "${user.name}" (${user.email})? This action removes all credentials from Cloud Firestore.'
              : (isSuspend
                  ? 'Suspending "${user.name}" will immediately restrict their access from posting listings or claiming items on campus.'
                  : 'Reactivating "${user.name}" will restore their full campus portal permissions.'),
          style: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDelete ? const Color(0xFFEF4444) : (isSuspend ? const Color(0xFFF59E0B) : const Color(0xFF10B981)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                if (isDelete) {
                  await _adminService.deleteUser(user.userId);
                } else {
                  await _adminService.toggleUserSuspension(user.userId, isSuspend);
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: isDelete ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                      content: Text('User "${user.name}" $action processed successfully.'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(backgroundColor: const Color(0xFFEF4444), content: Text('Error: $e')),
                  );
                }
              }
            },
            child: Text(action, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color bg;
    Color text;
    if (role == 'Admin') {
      bg = const Color(0xFFE0F2FE);
      text = const Color(0xFF0284C7);
    } else if (role == 'Teacher & Staff') {
      bg = const Color(0xFFF3E8FF);
      text = const Color(0xFF9333EA);
    } else {
      bg = const Color(0xFFF1F5F9);
      text = const Color(0xFF475569);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        role.toUpperCase(),
        style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w800, color: text, letterSpacing: 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: Text('User Management', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filter Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  CustomSearchBar(
                    hintText: 'Search by name, email, or Student ID...',
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Student', 'Teacher & Staff', 'Admin', 'Suspended'].map((filter) {
                        final isSel = _roleFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(filter, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                            selected: isSel,
                            selectedColor: const Color(0xFF0284C7),
                            backgroundColor: const Color(0xFFF8FAFC),
                            labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF475569)),
                            side: BorderSide(color: isSel ? Colors.transparent : const Color(0xFFE2E8F0)),
                            onSelected: (val) => setState(() => _roleFilter = filter),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Live Users Stream
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: _adminService.streamUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var users = snapshot.data ?? [];

                  // Apply search
                  if (_searchQuery.isNotEmpty) {
                    final q = _searchQuery.toLowerCase();
                    users = users.where((u) {
                      return u.name.toLowerCase().contains(q) ||
                          u.email.toLowerCase().contains(q) ||
                          (u.studentId != null && u.studentId!.toLowerCase().contains(q)) ||
                          u.role.toLowerCase().contains(q);
                    }).toList();
                  }

                  // Apply role filter
                  if (_roleFilter != 'All') {
                    if (_roleFilter == 'Suspended') {
                      users = users.where((u) => u.isSuspended).toList();
                    } else {
                      users = users.where((u) => u.role == _roleFilter).toList();
                    }
                  }

                  if (users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_search_rounded, size: 54, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 12),
                          Text('No users found', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Try adjusting your search query or filter chip.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: users.length,
                    itemBuilder: (ctx, idx) {
                      final user = users[idx];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: user.isSuspended ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0),
                            width: user.isSuspended ? 1.5 : 1.0,
                          ),
                          boxShadow: const [BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2))],
                        ),
                        child: InkWell(
                          onTap: () => _showUserProfileModal(user),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: const Color(0xFFE0F2FE),
                                    backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                                        ? NetworkImage(user.avatarUrl!)
                                        : null,
                                    child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                                        ? Text(
                                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF0284C7)),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                user.name,
                                                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            _buildRoleBadge(user.role),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(user.email, style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    user.department ?? (user.studentId != null ? 'ID: ${user.studentId}' : 'SMUCT Member'),
                                    style: GoogleFonts.inter(color: const Color(0xFF0284C7), fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    children: [
                                      // Suspend / Reactivate button
                                      OutlinedButton(
                                        onPressed: () => _showUserActionDialog(user, user.isSuspended ? 'Reactivate' : 'Suspend'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: user.isSuspended ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                          side: BorderSide(color: user.isSuspended ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        child: Text(user.isSuspended ? 'Reactivate' : 'Suspend', style: const TextStyle(fontSize: 11)),
                                      ),
                                      const SizedBox(width: 8),

                                      // Delete button
                                      OutlinedButton(
                                        onPressed: () => _showUserActionDialog(user, 'Delete'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFFEF4444),
                                          side: const BorderSide(color: Color(0xFFEF4444)),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        child: const Text('Delete', style: TextStyle(fontSize: 11)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
