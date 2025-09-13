// Auto-generated: firestore helpers.dart
// Helper functions (moved from the original large FirestoreService file).
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madunia/core/utils/errors/firebase_failures.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/debit_report/data/models/debit_item_model.dart';
import 'package:madunia/features/owned_report/data/models/owned_item_model.dart';




class FirestoreHelpers {
  // ============ PRIVATE HELPER METHODS ============
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Constants for better maintainability
  static const String  usersCollection = 'users';
  static const String  debitItemsCollection = 'debitItems';
  static const String  ownedItemsCollection = 'ownedItems';
  static const String  monthlyDebitsCollection = 'monthlyDebits';
  static const String  systemCollection = 'system';
  static const String  uniqueNameField = 'uniqueName';
  static const String  phoneNumberField = 'phoneNumber';
  static const String  statusField = 'status';
  static const String  createdAtField = 'createdAt';
  static const String  recordMoneyValueField = 'recordMoneyValue';
  static const String  totalDebitMoneyField = 'totalDebitMoney';
  static const String  totalMoneyOwedField = 'totalMoneyOwed';
  static const String  totalOwnedMoneyField = 'totalOwnedMoney';

  // Owed status constants
  static const Set<String>  owedStatuses = {'pending', 'unpaid', 'overdue'};

  // Collection references with better naming

  // users collection
  CollectionReference get  usersRef =>  firestore.collection( usersCollection);

  // debits collection
  CollectionReference  debitItemsRef(String userId) =>
       usersRef.doc(userId).collection( debitItemsCollection);

  // owned collections
  CollectionReference  ownedItemsRef(String userId) =>
       usersRef.doc(userId).collection( ownedItemsCollection);

  // monthly debits template collection
  CollectionReference get  monthlyDebitsRef => 
       firestore.collection( monthlyDebitsCollection);

  // system collection for tracking last execution
  CollectionReference get  systemRef => 
       firestore.collection( systemCollection);










      // ============ VALIDATION METHODS ============

  void validateUserId(String userId) {
    if (userId.trim().isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
  }

  void validateDebitItemId(String debitItemId) {
    if (debitItemId.trim().isEmpty) {
      throw ArgumentError('Debit item ID cannot be empty');
    }
  }

  void  validateOwnedItemId(String ownedItemId) {
    if (ownedItemId.trim().isEmpty) {
      throw ArgumentError('Owned item ID cannot be empty');
    }
  }

  void validateUserInput(String uniqueName, String phoneNumber) {
    if (uniqueName.trim().isEmpty) {
      throw ArgumentError('Unique name cannot be empty');
    }
    if (phoneNumber.trim().isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }
  }

  void  validateDebitItemInput(
    String recordName,
    double recordMoneyValue,
    String status,
  ) {
    if (recordName.trim().isEmpty) {
      throw ArgumentError('Record name cannot be empty');
    }
    if (recordMoneyValue < 0) {
      throw ArgumentError('Record money value cannot be negative');
    }
    if (status.trim().isEmpty) {
      throw ArgumentError('Status cannot be empty');
    }
  }

  void  validateOwnedItemInput(
    String recordName,
    double recordMoneyValue,
    String status,
  ) {
    if (recordName.trim().isEmpty) {
      throw ArgumentError('Record name cannot be empty');
    }
    if (recordMoneyValue < 0) {
      throw ArgumentError('Record money value cannot be negative');
    }
    if (status.trim().isEmpty) {
      throw ArgumentError('Status cannot be empty');
    }
  }


// ============ PRIVATE HELPER METHODS ============

  /// Check if unique name is taken
  Future<bool> isUniqueNameTaken(
    String uniqueName, {
    String? excludeUserId,
  }) async {
    final query = await usersRef
        .where(uniqueNameField, isEqualTo: uniqueName)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return false;

    // If excluding a user ID, check if the found user is different
    if (excludeUserId != null) {
      return query.docs.first.id != excludeUserId;
    }

    return true;
  }

  /// Calculate totals from documents - Core logic for FEATURE 1
  ({double totalMoney, double totalOwed}) calculateTotals(
    List<QueryDocumentSnapshot> docs,
  ) {
    double totalMoney = 0.0; // Sum of ALL recordMoneyValue (totalDebitMoney)
    double totalOwed = 0.0; // Sum of recordMoneyValue where status is owed

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final money = (data[recordMoneyValueField] ?? 0.0).toDouble();
      final status = (data[statusField] ?? '').toString().toLowerCase();

      // FEATURE 1: Add ALL money values to totalMoney (becomes totalDebitMoney)
      totalMoney += money;

      // Only add to owed if status indicates money is still owed
      if (owedStatuses.contains(status)) {
        totalOwed += money;
      }
    }

    return (totalMoney: totalMoney, totalOwed: totalOwed);
  }

  /// Calculate owned totals from documents
  ({double totalMoney}) calculateOwnedTotals(
    List<QueryDocumentSnapshot> docs,
  ) {
    double totalMoney = 0.0; // Sum of ALL recordMoneyValue (totalOwnedMoney)

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final money = (data[recordMoneyValueField] ?? 0.0).toDouble();
      totalMoney += money;
    }

    return (totalMoney: totalMoney);
  }

  /// Map snapshot to users list
  List<AppUser> mapSnapshotToUsers(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } catch (e) {
        log('Error mapping user document ${doc.id}: $e');
        rethrow;
      }
    }).toList();
  }

  /// Map snapshot to debit items list
  List<DebitItem> mapSnapshotToDebitItems(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return DebitItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } catch (e) {
        log('Error mapping debit item document ${doc.id}: $e');
        rethrow;
      }
    }).toList();
  }

  /// Map snapshot to owned items list
  List<OwnedItem> mapSnapshotToOwnedItems(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return OwnedItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } catch (e) {
        log('Error mapping owned item document ${doc.id}: $e');
        rethrow;
      }
    }).toList();
  }

  /// Helper method to get month-year string for monthly debits
  String getMonthYearString(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }




/// ENHANCED: Update user totals within a transaction for both debit and owned items
  void updateUserTotalsInTransaction(
    Transaction transaction,
    String userId,
    QuerySnapshot debitItemsSnapshot,
    QuerySnapshot ownedItemsSnapshot, {
    String? excludeDebitItemId,
    String? excludeOwnedItemId,
    String? updateDebitItemId,
    String? updateOwnedItemId,
    Map<String, dynamic>? updatedDebitValues,
    Map<String, dynamic>? updatedOwnedValues,
    Map<String, dynamic>? newDebitItem,
    Map<String, dynamic>? newOwnedItem,
  }) {
    try {
      // Process debit items
      List<Map<String, dynamic>> processedDebitDocs = [];
      
      for (final doc in debitItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Skip if this is the item being deleted
        if (excludeDebitItemId != null && doc.id == excludeDebitItemId) {
          continue;
        }
        
        // Update values if this is the item being updated
        if (updateDebitItemId != null && doc.id == updateDebitItemId && updatedDebitValues != null) {
          final updatedData = Map<String, dynamic>.from(data);
          updatedData.addAll(updatedDebitValues);
          processedDebitDocs.add(updatedData);
        } else {
          processedDebitDocs.add(data);
        }
      }
      
      // Add new debit item if provided
      if (newDebitItem != null) {
        processedDebitDocs.add(newDebitItem);
      }

      // Process owned items
      List<Map<String, dynamic>> processedOwnedDocs = [];
      
      for (final doc in ownedItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Skip if this is the item being deleted
        if (excludeOwnedItemId != null && doc.id == excludeOwnedItemId) {
          continue;
        }
        
        // Update values if this is the item being updated
        if (updateOwnedItemId != null && doc.id == updateOwnedItemId && updatedOwnedValues != null) {
          final updatedData = Map<String, dynamic>.from(data);
          updatedData.addAll(updatedOwnedValues);
          processedOwnedDocs.add(updatedData);
        } else {
          processedOwnedDocs.add(data);
        }
      }
      
      // Add new owned item if provided
      if (newOwnedItem != null) {
        processedOwnedDocs.add(newOwnedItem);
      }
      
      // Calculate totals from processed documents
      final debitTotals = calculateTotalsFromMaps(processedDebitDocs);
      final ownedTotals = calculateOwnedTotalsFromMaps(processedOwnedDocs);

      transaction.update(usersRef.doc(userId), {
        totalDebitMoneyField: debitTotals.totalMoney,
        totalMoneyOwedField: debitTotals.totalOwed,
        totalOwnedMoneyField: ownedTotals.totalMoney,
      });

      log(
        'Updated user totals for $userId: debit=${debitTotals.totalMoney}, owed=${debitTotals.totalOwed}, owned=${ownedTotals.totalMoney}',
      );
    } catch (e) {
      log('Error updating user totals in transaction: $e');
      rethrow;
    }
  }

  /// ADDED: Helper method to calculate totals from processed maps
  ({double totalMoney, double totalOwed}) calculateTotalsFromMaps(
    List<Map<String, dynamic>> docs,
  ) {
    double totalMoney = 0.0;
    double totalOwed = 0.0;

    for (final data in docs) {
      final money = (data[recordMoneyValueField] ?? 0.0).toDouble();
      final status = (data[statusField] ?? '').toString().toLowerCase();

      totalMoney += money;

      if (owedStatuses.contains(status)) {
        totalOwed += money;
      }
    }

    return (totalMoney: totalMoney, totalOwed: totalOwed);
  }

/// ADDED: Helper method to calculate owned totals from processed maps
  ({double totalMoney}) calculateOwnedTotalsFromMaps(
    List<Map<String, dynamic>> docs,
  ) {
    double totalMoney = 0.0;

    for (final data in docs) {
      final money = (data[recordMoneyValueField] ?? 0.0).toDouble();
      totalMoney += money;
    }

    return (totalMoney: totalMoney);
  }

  /// Manually recalculate totals for a specific user
  Future<void> recalculateUserTotals(String userId) async {
    try {
      validateUserId(userId);
      await updateUserTotals(userId);
      log('Manually recalculated totals for user: $userId');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to recalculate user totals: $e'),
      );
    }
  }

   /// FIXED: Update user totals with better error handling
  Future<void> updateUserTotals(String userId) async {
    await firestore.runTransaction((transaction) async {
      final debitItemsSnapshot = await debitItemsRef(userId).get();
      final ownedItemsSnapshot = await ownedItemsRef(userId).get();
      updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot);
    });
  }



  /// Update all users' total debit and owned money (useful for data migration)
  Future<void> recalculateAllUsersTotals() async {
    try {
      final usersSnapshot = await usersRef.get();

      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        await recalculateUserTotals(userId);
      }

      log('Recalculated totals for ${usersSnapshot.docs.length} users');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to recalculate all users totals: $e'),
      );
    }
  }

  /*


Future<List<AppUser>> searchUsersByName(String query) async {
    try {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) return [];

      final snapshot = await _usersRef
          .where(_uniqueNameField, isGreaterThanOrEqualTo: trimmedQuery)
          .where(_uniqueNameField, isLessThanOrEqualTo: '$trimmedQuery\uf8ff')
          .limit(50) // Add limit for performance
          .get();

      return _mapSnapshotToUsers(snapshot);
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to search users: $e'),
      );
    }
  }


  */
}