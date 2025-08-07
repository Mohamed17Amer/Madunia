import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madunia/core/utils/errors/firebase_failures.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/debit_report/data/models/debit_item_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference debitItemsCollection(String userId) =>
      usersCollection.doc(userId).collection('debitItems');

  // ============ USER FUNCTIONS ============

  /// Create a new user
  /// Checks for unique name before creating
  Future<String> createUser({
    required String uniqueName,
    required String phoneNumber,
  }) async {
    try {
      // Check if unique name already exists
      final existingUser = await usersCollection
          .where('uniqueName', isEqualTo: uniqueName)
          .get();

      if (existingUser.docs.isNotEmpty) {
        throw FirebaseFailure.fromException(
          Exception('User with this name already exists'),
        );
      }
      //  if unique name does not exists, create new user

      final user = AppUser(
        id: '',
        uniqueName: uniqueName,
        phoneNumber: phoneNumber,
        totalDebitMoney: 0.0,
        totalMoneyOwed: 0.0,
      );

      // add new user to firestore
      final docRef = await usersCollection.add(user.toMap());

      // return the user id
      return docRef.id;

      // return Failure creating user
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to create user: $e'),
      );
    }
  }

  /// Get all users as a stream
  Stream<List<AppUser>> getAllUsers() {
    return usersCollection
      //  .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  /// Get user by ID
  Future<AppUser?> getUserById(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Get user by unique name
  Future<AppUser?> getUserByName(String uniqueName) async {
    try {
      final snapshot = await usersCollection
          .where('uniqueName', isEqualTo: uniqueName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user by name: $e');
    }
  }

  /// Update user information
  Future<void> updateUser({
    required String userId,
    String? uniqueName,
    String? phoneNumber,
  }) async {
    try {
      Map<String, dynamic> updates = {};

      if (uniqueName != null) {
        // Check if new unique name already exists (excluding current user)
        final existingUser = await usersCollection
            .where('uniqueName', isEqualTo: uniqueName)
            .get();

        if (existingUser.docs.isNotEmpty &&
            existingUser.docs.first.id != userId) {
          throw Exception('User with this name already exists');
        }
        updates['uniqueName'] = uniqueName;
      }

      if (phoneNumber != null) {
        updates['phoneNumber'] = phoneNumber;
      }

      if (updates.isNotEmpty) {
        await usersCollection.doc(userId).update(updates);
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user and all their debit items
  Future<void> deleteUser(String userId) async {
    try {
      // Delete all debit items first
      final debitItems = await debitItemsCollection(userId).get();
      final batch = _firestore.batch();

      for (final doc in debitItems.docs) {
        batch.delete(doc.reference);
      }

      // Delete user
      batch.delete(usersCollection.doc(userId));

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // ============ DEBIT ITEM FUNCTIONS ============

  /// Add a new debit item to user
  Future<String> addDebitItem({
    required String userId,
    required String recordName,
    required double recordMoneyValue,
    required String status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      final debitItem = DebitItem(
        id: '',
        recordName: recordName,
        recordMoneyValue: recordMoneyValue,
        status: status,
        additionalFields: additionalFields,
      );

      final docRef = await debitItemsCollection(userId).add(debitItem.toMap());

      // Update user totals
      await _updateUserTotals(userId);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add debit item: $e');
    }
  }

  /// Get all debit items for a user as stream
  Stream<List<DebitItem>> getDebitItems(String userId) {
    return debitItemsCollection(
      userId,
    ).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DebitItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Get debit item by ID
  Future<DebitItem?> getDebitItemById(String userId, String debitItemId) async {
    try {
      final doc = await debitItemsCollection(userId).doc(debitItemId).get();
      if (doc.exists) {
        return DebitItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get debit item: $e');
    }
  }

  /// Update debit item
  Future<void> updateDebitItem({
    required String userId,
    required String debitItemId,
    String? recordName,
    double? recordMoneyValue,
    String? status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      Map<String, dynamic> updates = {};

      if (recordName != null) updates['recordName'] = recordName;
      if (recordMoneyValue != null)
        updates['recordMoneyValue'] = recordMoneyValue;
      if (status != null) updates['status'] = status;
      if (additionalFields != null)
        updates['additionalFields'] = additionalFields;

      if (updates.isNotEmpty) {
        await debitItemsCollection(userId).doc(debitItemId).update(updates);
        await _updateUserTotals(userId);
      }
    } catch (e) {
      throw Exception('Failed to update debit item: $e');
    }
  }

  /// Delete debit item
  Future<void> deleteDebitItem(String userId, String debitItemId) async {
    try {
      await debitItemsCollection(userId).doc(debitItemId).delete();
      await _updateUserTotals(userId);
    } catch (e) {
      throw Exception('Failed to delete debit item: $e');
    }
  }

  /// Get debit items by status
  Stream<List<DebitItem>> getDebitItemsByStatus(String userId, String status) {
    return debitItemsCollection(userId)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return DebitItem.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }

  // ============ HELPER FUNCTIONS ============

  /// Private method to update user totals automatically
  Future<void> _updateUserTotals(String userId) async {
    try {
      final debitItemsSnapshot = await debitItemsCollection(userId).get();

      double totalDebitMoney = 0.0;
      double totalMoneyOwed = 0.0;

      for (final doc in debitItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final money = (data['recordMoneyValue'] ?? 0.0).toDouble();
        final status = data['status'] ?? '';

        totalDebitMoney += money;

        // Count as owed if status is pending or unpaid
        if (status.toLowerCase() == 'pending' ||
            status.toLowerCase() == 'unpaid' ||
            status.toLowerCase() == 'overdue') {
          totalMoneyOwed += money;
        }
      }

      await usersCollection.doc(userId).update({
        'totalDebitMoney': totalDebitMoney,
        'totalMoneyOwed': totalMoneyOwed,
      });
    } catch (e) {
      print('Error updating user totals: $e');
    }
  }

  /// Manually recalculate totals for a user
  Future<void> recalculateUserTotals(String userId) async {
    await _updateUserTotals(userId);
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    try {
      final debitItemsSnapshot = await debitItemsCollection(userId).get();

      Map<String, int> statusCount = {};
      Map<String, double> statusTotal = {};
      double totalMoney = 0.0;
      double totalOwed = 0.0;

      for (final doc in debitItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final money = (data['recordMoneyValue'] ?? 0.0).toDouble();
        final status = data['status'] ?? 'unknown';

        totalMoney += money;

        // Count by status
        statusCount[status] = (statusCount[status] ?? 0) + 1;
        statusTotal[status] = (statusTotal[status] ?? 0.0) + money;

        // Count as owed
        if (status.toLowerCase() == 'pending' ||
            status.toLowerCase() == 'unpaid' ||
            status.toLowerCase() == 'overdue') {
          totalOwed += money;
        }
      }

      return {
        'totalItems': debitItemsSnapshot.docs.length,
        'totalMoney': totalMoney,
        'totalOwed': totalOwed,
        'statusCount': statusCount,
        'statusTotal': statusTotal,
      };
    } catch (e) {
      throw Exception('Failed to get user statistics: $e');
    }
  }

  /// Search users by name (partial match)
  Future<List<AppUser>> searchUsersByName(String query) async {
    try {
      final snapshot = await usersCollection
          .where('uniqueName', isGreaterThanOrEqualTo: query)
          .where('uniqueName', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return snapshot.docs.map((doc) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }
}

// Usage Examples:
/*

// Initialize the service
final firestoreService = FirestoreService();

// Create a user
String userId = await firestoreService.createUser(
  uniqueName: "John Doe",
  phoneNumber: "+1234567890",
);

// Add debit item
await firestoreService.addDebitItem(
  userId: userId,
  recordName: "Grocery Shopping",
  recordMoneyValue: 150.50,
  status: "pending",
  additionalFields: {
    "category": "food",
    "location": "SuperMarket",
    "notes": "Weekly grocery shopping"
  },
);

// Get user data
AppUser? user = await firestoreService.getUserById(userId);

// Get debit items stream
Stream<List<DebitItem>> debitItemsStream = firestoreService.getDebitItems(userId);

// Update debit item status
await firestoreService.updateDebitItem(
  userId: userId,
  debitItemId: "debitItemId",
  status: "paid",
);

// Get user statistics
Map<String, dynamic> stats = await firestoreService.getUserStatistics(userId);

*/
