import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madunia/core/services/firebase/firestore_helpers.dart';
import 'package:madunia/core/services/firebase/user_service.dart';
import 'package:madunia/core/services/firebase_services.dart';
import 'package:madunia/core/utils/errors/firebase_failures.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';

class FirestoreDebitMonthlyService {

final FirestoreHelpers _helpers = FirestoreHelpers();
      final UserService _userService = UserService(); // Assuming you have a UserService to fetch users


  ///  ******************************************************************************************

  // ============ AUTOMATIC MONTHLY DEBIT FUNCTIONS ============

/// Add a monthly debit template for specific user groups or all users
/// 
/*
  Future<String> addMonthlyDebitTemplate({
    required String recordName,
    required double recordMoneyValue,
    required String status,
    List<String>? userGroups, 
    List<String>? specificUserIds, 
    bool applyToAllUsers = true, 
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _helpers.validateDebitItemInput(recordName, recordMoneyValue, status);

      // Validate group assignment logic
      if (!applyToAllUsers && (userGroups?.isEmpty ?? true) && (specificUserIds?.isEmpty ?? true)) {
        throw ArgumentError('Must specify userGroups, specificUserIds, or set applyToAllUsers to true');
      }

      final templateData = {
        'recordName': recordName.trim(),
        'recordMoneyValue': recordMoneyValue,
        'status': status.trim().toLowerCase(),
        'isActive': true,
        'applyToAllUsers': applyToAllUsers,
        'userGroups': userGroups ?? [], // Groups this template applies to
        'specificUserIds': specificUserIds ?? [], // Specific users this applies to
        'createdAt': FieldValue.serverTimestamp(),
        if (additionalFields != null) 'additionalFields': additionalFields,
      };

      final docRef = await _helpers.monthlyDebitsRef.add(templateData);
      log('Added monthly debit template with ID: ${docRef.id} for ${applyToAllUsers ? "all users" : "specific groups/users"}');
      return docRef.id;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to add monthly debit template: $e'),
      );
    }
  }

  /// Get all active monthly debit templates
  Future<List<MonthlyDebitTemplate>> getMonthlyDebitTemplates() async {
    try {
      final snapshot = await _helpers.monthlyDebitsRef
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MonthlyDebitTemplate.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get monthly debit templates: $e'),
      );
    }
  }

  /// Disable a monthly debit template
  Future<void> disableMonthlyDebitTemplate(String templateId) async {
    try {
      await _helpers.monthlyDebitsRef.doc(templateId).update({'isActive': false});
      log('Disabled monthly debit template: $templateId');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to disable monthly debit template: $e'),
      );
    }
  }

  /// Execute monthly debits for all users (call this on the 1st of every month)
  /// Now supports user groups and specific user targeting
  Future<void> executeMonthlyDebits() async {
    try {
      final now = DateTime.now();
      
      // Check if we already executed this month
      final systemDoc = await _helpers.systemRef.doc('monthly_execution').get();
      if (systemDoc.exists) {
        final lastExecution = (systemDoc.data() as Map<String, dynamic>)['lastExecution'] as Timestamp?;
        if (lastExecution != null) {
          final lastExecutionDate = lastExecution.toDate();
          // If already executed this month, skip
          if (lastExecutionDate.year == now.year && lastExecutionDate.month == now.month) {
            log('Monthly debits already executed for ${now.year}-${now.month}');
            return;
          }
        }
      }

      // Get all active templates
      final templates = await getMonthlyDebitTemplates();
      if (templates.isEmpty) {
        log('No active monthly debit templates found');
        return;
      }

      // Get all users
      final allUsers = await _userService.getAllUsers();
      if (allUsers.isEmpty) {
        log('No users found for monthly debit execution');
        return;
      }

      int totalItemsAdded = 0;
      int totalUsersProcessed = 0;
      Map<String, int> templateStats = {}; // Track items per template
      
      // Process each template
      for (final template in templates) {
        try {
          // Determine which users this template applies to
          final targetUsers = _getTargetUsersForTemplate(template, allUsers);
          
          if (targetUsers.isEmpty) {
            log('No target users found for template: ${template.id}');
            continue;
          }

          // Add debit items for target users
          for (final user in targetUsers) {
            try {
              DebitService debitService = DebitService();
              await debitService.addDebitItem(
                userId: user.id,
                recordName: '${template.recordName} - ${_helpers.getMonthYearString(now)}',
                recordMoneyValue: template.recordMoneyValue,
                status: template.status,
                additionalFields: {
                  'isMonthlyDebit': true,
                  'monthYear': '${now.year}-${now.month.toString().padLeft(2, '0')}',
                  'templateId': template.id,
                  'userGroups': template.userGroups,
                  ...?template.additionalFields,
                },
              );
              totalItemsAdded++;
              templateStats[template.id] = (templateStats[template.id] ?? 0) + 1;
            } catch (e) {
              log('Error adding monthly debit for user ${user.id}, template ${template.id}: $e');
            }
          }
          
          totalUsersProcessed += targetUsers.length;
          log('Applied template "${template.recordName}" to ${targetUsers.length} users');
          
        } catch (e) {
          log('Error processing template ${template.id}: $e');
        }
      }

      // Update execution tracking
      await _helpers.systemRef.doc('monthly_execution').set({
        'lastExecution': FieldValue.serverTimestamp(),
        'lastExecutionDetails': {
          'year': now.year,
          'month': now.month,
          'totalUsersInSystem': allUsers.length,
          'totalUsersProcessed': totalUsersProcessed,
          'totalTemplatesProcessed': templates.length,
          'totalItemsAdded': totalItemsAdded,
          'templateStats': templateStats, // How many items per template
        },
      });

      log('Monthly debits executed successfully: $totalItemsAdded items added for $totalUsersProcessed user-template combinations');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to execute monthly debits: $e'),
      );
    }
  }

  /// Helper method to determine which users a template applies to
  List<AppUser> _getTargetUsersForTemplate(MonthlyDebitTemplate template, List<AppUser> allUsers) {
    // If applies to all users, return all users
    if (template.applyToAllUsers) {
      return allUsers;
    }

    List<AppUser> targetUsers = [];

    // Add users by specific IDs
    if (template.specificUserIds.isNotEmpty) {
      for (final userId in template.specificUserIds) {
        try {
          final user = allUsers.firstWhere((u) => u.id == userId);
          if (!targetUsers.contains(user)) {
            targetUsers.add(user);
          }
        } catch (e) {
          log('Warning: User ID $userId not found in system');
        }
      }
    }

    // Add users by groups
    if (template.userGroups.isNotEmpty) {
      for (final user in allUsers) {
        // Check if user belongs to any of the required groups
        final userGroups = _getUserGroups(user);
        for (final requiredGroup in template.userGroups) {
          if (userGroups.contains(requiredGroup) && !targetUsers.contains(user)) {
            targetUsers.add(user);
            break; // User is already added, no need to check other groups
          }
        }
      }
    }

    return targetUsers;
  }

  /// Get user groups for a specific user
  /// You can implement this based on your business logic
  List<String> _getUserGroups(AppUser user) {
    // EXAMPLE IMPLEMENTATIONS - Choose one or create your own:
    
    // Option 1: Based on user ID hash (distributes users evenly)
    final userIdHash = user.id.hashCode.abs();
    final groupNumber = (userIdHash % 5) + 1; // Creates groups 1-5
    return ['group_$groupNumber'];

    // Option 2: Based on phone number last digit
    // final lastDigit = int.tryParse(user.phoneNumber.substring(user.phoneNumber.length - 1)) ?? 0;
    // final groupNumber = (lastDigit % 5) + 1;
    // return ['group_$groupNumber'];

    // Option 3: Based on user name first letter
    // final firstLetter = user.uniqueName.toLowerCase().substring(0, 1);
    // if (['a', 'b', 'c', 'd', 'e'].contains(firstLetter)) return ['group_1'];
    // if (['f', 'g', 'h', 'i', 'j'].contains(firstLetter)) return ['group_2'];
    // if (['k', 'l', 'm', 'n', 'o'].contains(firstLetter)) return ['group_3'];
    // if (['p', 'q', 'r', 's', 't'].contains(firstLetter)) return ['group_4'];
    // return ['group_5'];

    // Option 4: Store groups in user metadata (requires updating AppUser model)
    // return user.groups ?? ['default_group'];
  }

  /// Get users by group
  Future<List<AppUser>> getUsersByGroup(String groupName) async {
    try {
      final allUsers = await _userService.getAllUsers();
      return allUsers.where((user) => _getUserGroups(user).contains(groupName)).toList();
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get users by group: $e'),
      );
    }
  }

  /// Get all user groups and their user counts
  Future<Map<String, int>> getAllUserGroupStats() async {
    try {
      final allUsers = await _userService.getAllUsers();
      final Map<String, int> groupStats = {};

      for (final user in allUsers) {
        final userGroups = _getUserGroups(user);
        for (final group in userGroups) {
          groupStats[group] = (groupStats[group] ?? 0) + 1;
        }
      }

      return groupStats;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get user group stats: $e'),
      );
    }
  }

  /// Check if monthly debits should be executed (helper method for scheduling)
  Future<bool> shouldExecuteMonthlyDebits() async {
    try {
      final now = DateTime.now();
      
      // Only execute on the 1st of the month
      if (now.day != 1) return false;

      // Check if already executed this month
      final systemDoc = await _helpers.systemRef.doc('monthly_execution').get();
      if (!systemDoc.exists) return true;

      final lastExecution = (systemDoc.data() as Map<String, dynamic>)['lastExecution'] as Timestamp?;
      if (lastExecution == null) return true;

      final lastExecutionDate = lastExecution.toDate();
      // Return true if we haven't executed this month yet
      return !(lastExecutionDate.year == now.year && lastExecutionDate.month == now.month);
    } catch (e) {
      log('Error checking if monthly debits should be executed: $e');
      return false;
    }
  }

  /// Get monthly execution history
  Future<Map<String, dynamic>?> getMonthlyExecutionHistory() async {
    try {
      final doc = await _helpers.systemRef.doc('monthly_execution').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get monthly execution history: $e'),
      );
    }
  }


*/
}

