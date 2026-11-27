import 'package:flutter_test/flutter_test.dart';
import 'package:smuct_lost_and_found/models/user_model.dart';
import 'package:smuct_lost_and_found/models/item_model.dart';
import 'package:smuct_lost_and_found/models/claim_model.dart';
import 'package:smuct_lost_and_found/models/notification_model.dart';

void main() {
  group('Admin Models & Functional Security Tests', () {
    test('UserModel: Role integrity and suspension serialization', () {
      final user = UserModel(
        userId: 'usr_student_01',
        name: 'Tanvir Ahmed',
        email: 'tanvir@smuct.edu.bd',
        role: 'Student',
        studentId: 'CS-22-09',
        department: 'Computer Science',
        isSuspended: false,
      );

      expect(user.role, 'Student');
      expect(user.isSuspended, isFalse);

      final map = user.toMap();
      expect(map['role'], 'Student');
      expect(map['isSuspended'], isFalse);

      final suspendedUser = user.copyWith(isSuspended: true);
      expect(suspendedUser.isSuspended, isTrue);
      expect(suspendedUser.toMap()['isSuspended'], isTrue);
    });

    test('UserModel: Factory handles map and preserves Admin role', () {
      final map = {
        'name': 'Campus Admin',
        'email': 'admin@smuct.edu.bd',
        'role': 'Admin',
        'isSuspended': false,
        'emailVerified': true,
      };

      final admin = UserModel.fromMap(map, 'usr_admin_01');
      expect(admin.role, 'Admin');
      expect(admin.userId, 'usr_admin_01');
      expect(admin.emailVerified, isTrue);
    });

    test('ItemModel: Moderation status and flagging flags', () {
      final item = ItemModel(
        itemId: 'itm_001',
        userId: 'usr_student_01',
        categoryId: 'Electronics',
        title: 'Sony Headphones',
        description: 'Black WH-1000XM4 left on 4th floor table',
        status: 'Found',
        claimStatus: 'Available',
        imageUrl: 'https://example.com/headphones.jpg',
        location: 'Study Area 4F',
        datePosted: DateTime(2026, 11, 20),
        authorName: 'Campus Security',
      );

      expect(item.moderationStatus, 'Approved');
      expect(item.isFlagged, isFalse);
      expect(item.claimStatus, 'Available');

      final flagged = item.copyWith(
        isFlagged: true,
        flagReason: 'Suspected duplicate entry',
      );
      expect(flagged.isFlagged, isTrue);
      expect(flagged.flagReason, 'Suspected duplicate entry');

      final claimed = item.copyWith(claimStatus: 'Claimed');
      expect(claimed.claimStatus, 'Claimed');
    });

    test('ClaimModel: Adjudication, Additional Info and Rejection handling', () {
      final claim = ClaimModel(
        claimId: 'clm_001',
        itemId: 'itm_001',
        claimantId: 'usr_student_02',
        itemTitle: 'Sony Headphones',
        justification: 'Serial number ends with 4901 and blue sticker inside left cup',
        status: 'Pending',
        dateSubmitted: DateTime(2026, 11, 21),
      );

      expect(claim.status, 'Pending');
      expect(claim.additionalInfoRequested, isFalse);

      // Request additional information keeping claim Pending
      final requestedInfo = claim.copyWith(
        additionalInfoRequested: true,
        adminNotes: 'Please provide purchase receipt or registration box photo',
      );
      expect(requestedInfo.status, 'Pending');
      expect(requestedInfo.additionalInfoRequested, isTrue);
      expect(requestedInfo.adminNotes, contains('receipt'));

      // Approve claim
      final approved = claim.copyWith(
        status: 'Approved',
        reviewedByAdminId: 'usr_admin_01',
      );
      expect(approved.status, 'Approved');
      expect(approved.reviewedByAdminId, 'usr_admin_01');

      // Reject claim
      final rejected = claim.copyWith(
        status: 'Rejected',
        adminNotes: 'Serial does not match recovered item',
      );
      expect(rejected.status, 'Rejected');
      expect(rejected.rejectionReason, contains('Serial does not match'));
    });

    test('NotificationModel: Serialization and Type checking', () {
      final notif = NotificationModel(
        notificationId: 'notif_001',
        userId: 'usr_student_02',
        message: 'Claim Approved: Your claim for "Sony Headphones" was approved.',
        type: 'claim_approved',
        timestamp: DateTime(2026, 11, 22),
        claimId: 'clm_001',
        itemId: 'itm_001',
      );

      expect(notif.type, 'claim_approved');
      expect(notif.isRead, isFalse);
      expect(notif.title, contains('Claim'));

      final map = notif.toMap();
      expect(map['claimId'], 'clm_001');
      expect(map['itemId'], 'itm_001');
      expect(map['type'], 'claim_approved');
    });
  });
}
