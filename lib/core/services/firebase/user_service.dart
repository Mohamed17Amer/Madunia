// Auto-generated: user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madunia/core/utils/errors/firebase_failures.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'firestore_base.dart';
import 'firestore_helpers.dart';

class UserService {
  final FirebaseFirestore _firestore = FirestoreRefs.firestore;
  final FirestoreHelpers _helpers = FirestoreHelpers();

   /// Create a new user with improved error handling and validation
  Future<String> createUser({
    required String uniqueName,
    required String phoneNumber,
  }) async {
    try {
      // Input validation
      _helpers.validateUserInput(uniqueName, phoneNumber);

      // Check uniqueness more efficiently
      if (await _helpers.isUniqueNameTaken(uniqueName)) {
        throw FirebaseFailure.fromException(
          Exception('User with this name already exists'),
        );
      }

      final user = AppUser(
        id: '',
        uniqueName: uniqueName.trim(),
        phoneNumber: phoneNumber.trim(),
        totalDebitMoney: 0.0,
        totalOwnedMoney: 0.0, // Added totalOwnedMoney
        debitItems: [],
      );

      final docRef = await _helpers.usersRef.add(user.toMap());
      return docRef.id;
    } on FirebaseFailure {
      rethrow; // Re-throw custom failures
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to create user: $e'),
      );
    }
  }

  /// Get all users with better error handling
  Future<List<AppUser>> getAllUsers() async {
    try {
      final snapshot = await _helpers.usersRef.get();
      return _helpers.mapSnapshotToUsers(snapshot);
    } catch (error) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get users: $error'),
      );
    }
  }

  /// Get user by ID with consistent error handling

  /// Get user by unique name with better performance
  Future<AppUser?> getUserByName(String uniqueName) async {
    try {
      if (uniqueName.trim().isEmpty) {
        throw ArgumentError('Unique name cannot be empty');
      }

      final snapshot = await _helpers.usersRef
          .where(FirestoreHelpers.uniqueNameField, isEqualTo: uniqueName.trim())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get user by name: $e'),
      );
    }
  }

  Future<AppUser?> getUserById(String userId) async {
    try {
      _helpers.validateUserId(userId);

      final doc = await _helpers.usersRef.doc(userId).get();
      return doc.exists
          ? AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)
          : null;
    } catch (e) {
      throw FirebaseFailure.fromException(Exception('Failed to get user: $e'));
    }
  }

  /// Update user information with improved validation
  Future<void> updateUser({
    required String userId,
    String? uniqueName,
    String? phoneNumber,
  }) async {
    try {
      _helpers.validateUserId(userId);

      final Map<String, dynamic> updates = {};

      if (uniqueName != null) {
        final trimmedName = uniqueName.trim();
        if (trimmedName.isEmpty) {
          throw ArgumentError('Unique name cannot be empty');
        }

        // Check uniqueness excluding current user
        if (await _helpers.isUniqueNameTaken(trimmedName, excludeUserId: userId)) {
          throw FirebaseFailure.fromException(
            Exception('User with this name already exists'),
          );
        }
        updates[FirestoreHelpers.uniqueNameField] = trimmedName;
      }

      if (phoneNumber != null) {
        final trimmedPhone = phoneNumber.trim();
        if (trimmedPhone.isEmpty) {
          throw ArgumentError('Phone number cannot be empty');
        }
        updates[FirestoreHelpers.phoneNumberField] = trimmedPhone;
      }

      if (updates.isNotEmpty) {
        await _helpers.usersRef.doc(userId).update(updates);
      }
    } catch (e) {
      if (e is FirebaseFailure || e is ArgumentError) rethrow;
      throw FirebaseFailure.fromException(
        Exception('Failed to update user: $e'),
      );
    }
  }

  /// Delete user and all debit items using transaction for consistency
  Future<void> deleteUser(String userId) async {
    try {
      _helpers.validateUserId(userId);

      // Use transaction for atomicity
      await _helpers.firestore.runTransaction((transaction) async {
        // Get all debit items
        final debitItems = await _helpers.debitItemsRef(userId).get();
        
        // Get all owned items
        final ownedItems = await _helpers.ownedItemsRef(userId).get();

        // Delete all debit items
        for (final doc in debitItems.docs) {
          transaction.delete(doc.reference);
        }

        // Delete all owned items
        for (final doc in ownedItems.docs) {
          transaction.delete(doc.reference);
        }

        // Delete user
        transaction.delete(_helpers.usersRef.doc(userId));
      });
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to delete user: $e'),
      );
    }
  }
}