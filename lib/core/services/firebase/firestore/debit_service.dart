// Auto-generated: debit_helpers.service.dart
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madunia/core/utils/errors/firebase_failures.dart';
import 'package:madunia/features/debit_report/data/models/debit_item_model.dart';
import '../firestore_helpers.dart';

class DebitService {
  final FirestoreHelpers _helpers = FirestoreHelpers();

    // ============ DEBIT ITEM FUNCTIONS ============
  
    

  Future<String> addDebitItem({
    required String userId,
    required String recordName,
    required double recordMoneyValue,
    required String status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _helpers.validateUserId(userId);
      _helpers.validateDebitItemInput(recordName, recordMoneyValue, status);

      // Create debit item with server timestamp for proper sorting
      final debitItemData = {
        'recordName': recordName.trim(),
        'recordMoneyValue': recordMoneyValue,
        'status': status.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        if (additionalFields != null) 'additionalFields': additionalFields,
      };

      // Use transaction to ensure consistency
      late String docId;
      await _helpers.firestore.runTransaction((transaction) async {
        // Read debit items first (outside transaction since it's a collection)
        final debitItemsSnapshot = await _helpers.debitItemsRef(userId).get();
        final ownedItemsSnapshot = await _helpers.ownedItemsRef(userId).get();
        
        // Add new item
        final docRef = _helpers.debitItemsRef(userId).doc();
        transaction.set(docRef, debitItemData);
        docId = docRef.id;

        // Update user totals (synchronously)
        _helpers.updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, newDebitItem: {
          'recordMoneyValue': recordMoneyValue,
          'status': status.trim().toLowerCase(),
        });
      });

      log('Added debit item with ID: $docId for user: $userId');
      return docId;
    } catch (e) {
      log('Error adding debit item: $e');
      throw FirebaseFailure.fromException(
        Exception('Failed to add debit item: $e'),
      );
    }
  }

  /// Get debit items with time-based sorting (newest first by default)
  Future<List<DebitItem>> getDebitItems(
    String userId, {
    bool sortByTimeDescending = true,
  }) async {
    try {
      _helpers.validateUserId(userId);

      Query query = _helpers.debitItemsRef(userId);

      // Try to order by createdAt, fall back to no ordering if field doesn't exist
      try {
        query = query.orderBy(
          FirestoreHelpers.createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log(
          'Warning: Could not sort by createdAt field, returning unsorted results',
        );
        query = _helpers.debitItemsRef(userId);
      }

      final snapshot = await query.get();
      final items = _helpers.mapSnapshotToDebitItems(snapshot);

      // If Firestore ordering failed and we need to sort in memory
      // Note: This requires your DebitItem model to have a createdAt field
      // If your model doesn't have createdAt, this section will be skipped
      if (sortByTimeDescending && items.isNotEmpty) {
        try {
          // Only attempt to sort if DebitItem has createdAt field
          // Remove this block if your DebitItem doesn't have createdAt
          log(
            'Note: In-memory sorting skipped - DebitItem model may not have createdAt field',
          );

        } catch (e) {
          log('Warning: Could not sort items by time in memory: $e');
        }
      }

      log('Retrieved ${items.length} debit items for user: $userId');
      return items;
    } catch (e) {
      log('Error getting debit items: $e');
      throw FirebaseFailure.fromException(
        Exception('Failed to get debit items: $e'),
      );
    }
  }

  /// FIXED: Delete debit item with automatic total recalculation
  Future<void> deleteDebitItem(String userId, String debitItemId) async {
    try {
      _helpers.validateUserId(userId);
      _helpers.validateDebitItemId(debitItemId);

      await _helpers.firestore.runTransaction((transaction) async {
        // Read debit items first (outside transaction since it's a collection)
        final debitItemsSnapshot = await _helpers.debitItemsRef(userId).get();
        final ownedItemsSnapshot = await _helpers.ownedItemsRef(userId).get();
        
        // Delete the specific item
        transaction.delete(_helpers.debitItemsRef(userId).doc(debitItemId));
        
        // Update user totals (synchronously, excluding the deleted item)
        _helpers.updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, 
          excludeDebitItemId: debitItemId);
      });

      log('Deleted debit item: $debitItemId for user: $userId');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to delete debit item: $e'),
      );
    }
  }

  /// Get debit items stream with time-based sorting
  Stream<List<DebitItem>> getDebitItemsStream(
    String userId, {
    bool sortByTimeDescending = true,
  }) {
    try {
      _helpers.validateUserId(userId);

      Query query = _helpers.debitItemsRef(userId);

      try {
        query = query.orderBy(
          FirestoreHelpers.createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log('Warning: Could not sort stream by createdAt field');
        query = _helpers.debitItemsRef(userId);
      }

      return query
          .snapshots()
          .map((snapshot) => _helpers.mapSnapshotToDebitItems(snapshot))
          .handleError((error) {
            log('Stream error: $error');
            throw FirebaseFailure.fromException(
              Exception('Failed to get debit items stream: $error'),
            );
          });
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to initialize debit items stream: $e'),
      );
    }
  }

  /// Get debit item by ID
  Future<DebitItem?> getDebitItemById(String userId, String debitItemId) async {
    try {
      _helpers.validateUserId(userId);
      _helpers.validateDebitItemId(debitItemId);

      final doc = await _helpers.debitItemsRef(userId).doc(debitItemId).get();
      return doc.exists
          ? DebitItem.fromMap(doc.data() as Map<String, dynamic>, doc.id)
          : null;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get debit item: $e'),
      );
    }
  }

  /// FIXED: Update debit item with automatic total recalculation
  Future<void> updateDebitItem({
    required String userId,
    required String debitItemId,
    String? recordName,
    double? recordMoneyValue,
    String? status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _helpers.validateUserId(userId);
      _helpers.validateDebitItemId(debitItemId);

      final Map<String, dynamic> updates = {};

      if (recordName != null) {
        final trimmed = recordName.trim();
        if (trimmed.isEmpty) throw ArgumentError('Record name cannot be empty');
        updates['recordName'] = trimmed;
      }

      if (recordMoneyValue != null) {
        if (recordMoneyValue < 0) {
          throw ArgumentError('Money value cannot be negative');
        }
        updates[FirestoreHelpers.recordMoneyValueField] = recordMoneyValue;
      }

      if (status != null) {
        final trimmed = status.trim();
        if (trimmed.isEmpty) throw ArgumentError('Status cannot be empty');
        updates[FirestoreHelpers.statusField] = trimmed.toLowerCase();
      }

      if (additionalFields != null) {
        updates['additionalFields'] = additionalFields;
      }

      if (updates.isNotEmpty) {
        await _helpers.firestore.runTransaction((transaction) async {
          // Read debit items first (outside transaction since it's a collection)
          final debitItemsSnapshot = await _helpers.debitItemsRef(userId).get();
          final ownedItemsSnapshot = await _helpers.ownedItemsRef(userId).get();
          
          // Update the item
          transaction.update(_helpers.debitItemsRef(userId).doc(debitItemId), updates);
          
          // Update user totals (synchronously, with updated values)
          _helpers.updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, 
            updateDebitItemId: debitItemId, 
            updatedDebitValues: updates);
        });

        log('Updated debit item: $debitItemId for user: $userId');
      }
    } catch (e) {
      if (e is ArgumentError) rethrow;
      throw FirebaseFailure.fromException(
        Exception('Failed to update debit item: $e'),
      );
    }
  }

  /// Get debit items by status with time-based sorting
  Stream<List<DebitItem>> getDebitItemsByStatus(
    String userId,
    String status, {
    bool sortByTimeDescending = true,
  }) {
    try {
      _helpers.validateUserId(userId);
      if (status.trim().isEmpty) {
        throw ArgumentError('Status cannot be empty');
      }

      Query query = _helpers.debitItemsRef(
        userId,
      ).where(FirestoreHelpers.statusField, isEqualTo: status.trim().toLowerCase());

      try {
        query = query.orderBy(
          FirestoreHelpers.createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log('Warning: Could not sort by status stream by createdAt field');
      }

      return query
          .snapshots()
          .map((snapshot) => _helpers.mapSnapshotToDebitItems(snapshot))
          .handleError((error) {
            throw FirebaseFailure.fromException(
              Exception('Failed to get debit items by status: $error'),
            );
          });
    } catch (e) {
      if (e is ArgumentError) rethrow;
      throw FirebaseFailure.fromException(
        Exception('Failed to initialize debit items by status stream: $e'),
      );
    }
  }


  /// Get total debit money for a specific user (sum of all recordMoneyValue)
  Future<double> getTotalDebitMoney(String userId) async {
    try {
      _helpers.validateUserId(userId);

      final debitItemsSnapshot = await _helpers.debitItemsRef(userId).get();
      double totalDebitMoney = 0.0;

      for (final doc in debitItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final money = (data[FirestoreHelpers.recordMoneyValueField] ?? 0.0).toDouble();
        totalDebitMoney += money;
      }

      log('Calculated total debit money for user $userId: $totalDebitMoney');
      return totalDebitMoney;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get total debit money: $e'),
      );
    }
  }


  /// Get total debit money for all users
  Future<Map<String, double>> getAllUsersTotalDebitMoney() async {
    try {
      final usersSnapshot = await _helpers.usersRef.get();
      final Map<String, double> userTotals = {};

      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final totalMoney = await getTotalDebitMoney(userId);
        userTotals[userId] = totalMoney;
      }

      log('Calculated debit totals for ${userTotals.length} users');
      return userTotals;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get all users total debit money: $e'),
      );
    }
  }


}