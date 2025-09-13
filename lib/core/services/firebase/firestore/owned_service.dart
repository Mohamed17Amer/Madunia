// Auto-generated: owned_helpers.service.dart
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madunia/core/utils/errors/firebase_failures.dart';
import 'package:madunia/features/owned_report/data/models/owned_item_model.dart';
import '../firestore_helpers.dart';

class OwnedService {
  final FirestoreHelpers _helpers = FirestoreHelpers();

  Future<String> addOwnedItem({
    required String userId,
    required String recordName,
    required double recordMoneyValue,
    required String status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _helpers.validateUserId(userId);
      _helpers.validateOwnedItemInput(recordName, recordMoneyValue, status);

      // Create owned item with server timestamp for proper sorting
      final ownedItemData = {
        'recordName': recordName.trim(),
        'recordMoneyValue': recordMoneyValue,
        'status': status.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        if (additionalFields != null) 'additionalFields': additionalFields,
      };

      // Use transaction to ensure consistency
      late String docId;
      await _helpers.firestore.runTransaction((transaction) async {
        // Read items first (outside transaction since it's a collection)
        final debitItemsSnapshot = await _helpers.debitItemsRef(userId).get();
        final ownedItemsSnapshot = await _helpers.ownedItemsRef(userId).get();
        
        // Add new item
        final docRef = _helpers.ownedItemsRef(userId).doc();
        transaction.set(docRef, ownedItemData);
        docId = docRef.id;

        // Update user totals (synchronously)
        _helpers.updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, newOwnedItem: {
          'recordMoneyValue': recordMoneyValue,
          'status': status.trim().toLowerCase(),
        });
      });

      log('Added owned item with ID: $docId for user: $userId');
      return docId;
    } catch (e) {
      log('Error adding owned item: $e');
      throw FirebaseFailure.fromException(
        Exception('Failed to add owned item: $e'),
      );
    }
  }

  /// Get owned items with time-based sorting (newest first by default)
  Future<List<OwnedItem>> getOwnedItems(
    String userId, {
    bool sortByTimeDescending = true,
  }) async {
    try {
      _helpers.validateUserId(userId);

      Query query = _helpers.ownedItemsRef(userId);

      // Try to order by createdAt, fall back to no ordering if field doesn't exist
      try {
        query = query.orderBy(
          FirestoreHelpers.createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log(
          'Warning: Could not sort owned items by createdAt field, returning unsorted results',
        );
        query = _helpers.ownedItemsRef(userId);
      }

      final snapshot = await query.get();
      final items = _helpers.mapSnapshotToOwnedItems(snapshot);

      log('Retrieved ${items.length} owned items for user: $userId');
      return items;
    } catch (e) {
      log('Error getting owned items: $e');
      throw FirebaseFailure.fromException(
        Exception('Failed to get owned items: $e'),
      );
    }
  }

  /// Delete owned item with automatic total recalculation
  Future<void> deleteOwnedItem(String userId, String ownedItemId) async {
    try {
      _helpers.validateUserId(userId);
      _helpers.validateOwnedItemId(ownedItemId);

      await _helpers.firestore.runTransaction((transaction) async {
        // Read items first (outside transaction since it's a collection)
        final debitItemsSnapshot = await _helpers.debitItemsRef(userId).get();
        final ownedItemsSnapshot = await _helpers.ownedItemsRef(userId).get();
        
        // Delete the specific item
        transaction.delete(_helpers.ownedItemsRef(userId).doc(ownedItemId));
        
        // Update user totals (synchronously, excluding the deleted item)
        _helpers.updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, 
          excludeOwnedItemId: ownedItemId);
      });

      log('Deleted owned item: $ownedItemId for user: $userId');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to delete owned item: $e'),
      );
    }
  }

  /// Get owned items stream with time-based sorting
  Stream<List<OwnedItem>> getOwnedItemsStream(
    String userId, {
    bool sortByTimeDescending = true,
  }) {
    try {
      _helpers.validateUserId(userId);

      Query query = _helpers.ownedItemsRef(userId);

      try {
        query = query.orderBy(
          FirestoreHelpers.createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log('Warning: Could not sort owned items stream by createdAt field');
        query = _helpers.ownedItemsRef(userId);
      }

      return query
          .snapshots()
          .map((snapshot) => _helpers.mapSnapshotToOwnedItems(snapshot))
          .handleError((error) {
            log('Owned items stream error: $error');
            throw FirebaseFailure.fromException(
              Exception('Failed to get owned items stream: $error'),
            );
          });
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to initialize owned items stream: $e'),
      );
    }
  }

  /// Get owned item by ID
  Future<OwnedItem?> getOwnedItemById(String userId, String ownedItemId) async {
    try {
      _helpers.validateUserId(userId);
      _helpers.validateOwnedItemId(ownedItemId);

      final doc = await _helpers.ownedItemsRef(userId).doc(ownedItemId).get();
      return doc.exists
          ? OwnedItem.fromMap(doc.data() as Map<String, dynamic>, doc.id)
          : null;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get owned item: $e'),
      );
    }
  }

  /// Update owned item with automatic total recalculation
  Future<void> updateOwnedItem({
    required String userId,
    required String ownedItemId,
    String? recordName,
    double? recordMoneyValue,
    String? status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _helpers.validateUserId(userId);
      _helpers.validateOwnedItemId(ownedItemId);

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
          // Read items first (outside transaction since it's a collection)
          final debitItemsSnapshot = await _helpers.debitItemsRef(userId).get();
          final ownedItemsSnapshot = await _helpers.ownedItemsRef(userId).get();
          
          // Update the item
          transaction.update(_helpers.ownedItemsRef(userId).doc(ownedItemId), updates);
          
          // Update user totals (synchronously, with updated values)
          _helpers.updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, 
            updateOwnedItemId: ownedItemId, 
            updatedOwnedValues: updates);
        });

        log('Updated owned item: $ownedItemId for user: $userId');
      }
    } catch (e) {
      if (e is ArgumentError) rethrow;
      throw FirebaseFailure.fromException(
        Exception('Failed to update owned item: $e'),
      );
    }
  }

  /// Get total owned money for a specific user (sum of all recordMoneyValue in owned items)
  Future<double> getTotalOwnedMoney(String userId) async {
    try {
      _helpers.validateUserId(userId);

      final ownedItemsSnapshot = await _helpers.ownedItemsRef(userId).get();
      double totalOwnedMoney = 0.0;

      for (final doc in ownedItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final money = (data[FirestoreHelpers.recordMoneyValueField] ?? 0.0).toDouble();
        totalOwnedMoney += money;
      }

      log('Calculated total owned money for user $userId: $totalOwnedMoney');
      return totalOwnedMoney;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get total owned money: $e'),
      );
    }
  }


  /// Get total owned money for all users
  Future<Map<String, double>> getAllUsersTotalOwnedMoney() async {
    try {
      final usersSnapshot = await _helpers.usersRef.get();
      final Map<String, double> userTotals = {};

      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final totalMoney = await getTotalOwnedMoney(userId);
        userTotals[userId] = totalMoney;
      }

      log('Calculated owned totals for ${userTotals.length} users');
      return userTotals;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get all users total owned money: $e'),
      );
    }
  }

}