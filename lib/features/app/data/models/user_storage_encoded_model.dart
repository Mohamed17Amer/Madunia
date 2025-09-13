import 'dart:developer';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:madunia/features/debit_report/data/models/debit_item_model.dart';

class UserStorage {
  static const String _userKey = 'app_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // Save whole user object
  static Future<void> saveUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toMap(includeDebitItems: true));
    await prefs.setString(_userKey, userJson);
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Get whole user object
  static Future<AppUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      try {
        Map<String, dynamic> userMap = jsonDecode(userJson);
        
        // Handle debitItems conversion
        List<DebitItem> debitItems = [];
        if (userMap['debitItems'] != null) {
          debitItems = (userMap['debitItems'] as List)
              .map((item) => DebitItem.fromMap(item,""))
              .toList();
        }
        
        return AppUser.fromMap(
          userMap,
          userMap['id'] ?? '', // Use stored ID or empty string
          debitItems: debitItems,
        );
      } catch (e) {
        log('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
   // Clear user data (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Clear only user data but keep other app settings
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_isLoggedInKey);
  }

/*
  // Get specific user data
  static Future<String?> getUserId() async {
    AppUser? user = await getUser();
    return user?.id;
  }

  static Future<String?> getUniqueName() async {
    AppUser? user = await getUser();
    return user?.uniqueName;
  }

  static Future<String?> getPhoneNumber() async {
    AppUser? user = await getUser();
    return user?.phoneNumber;
  }

  static Future<double?> getTotalDebitMoney() async {
    AppUser? user = await getUser();
    return user?.totalDebitMoney;
  }

  static Future<double?> getTotalMoneyOwed() async {
    AppUser? user = await getUser();
    return user?.totalMoneyOwed;
  }

  static Future<List<DebitItem>?> getDebitItems() async {
    AppUser? user = await getUser();
    return user?.debitItems;
  }

  // Update user data
  static Future<void> updateUser(AppUser updatedUser) async {
    await saveUser(updatedUser);
  }

  // Update specific fields
  static Future<void> updateTotalDebitMoney(double newAmount) async {
    AppUser? currentUser = await getUser();
    if (currentUser != null) {
      AppUser updatedUser = AppUser(
        id: currentUser.id,
        uniqueName: currentUser.uniqueName,
        phoneNumber: currentUser.phoneNumber,
        totalDebitMoney: newAmount,
        totalMoneyOwed: currentUser.totalMoneyOwed,
        debitItems: currentUser.debitItems,
      );
      await saveUser(updatedUser);
    }
  }

  static Future<void> updateTotalMoneyOwed(double newAmount) async {
    AppUser? currentUser = await getUser();
    if (currentUser != null) {
      AppUser updatedUser = AppUser(
        id: currentUser.id,
        uniqueName: currentUser.uniqueName,
        phoneNumber: currentUser.phoneNumber,
        totalDebitMoney: currentUser.totalDebitMoney,
        totalMoneyOwed: newAmount,
        debitItems: currentUser.debitItems,
      );
      await saveUser(updatedUser);
    }
  }

  static Future<void> updateDebitItems(List<DebitItem> newDebitItems) async {
    AppUser? currentUser = await getUser();
    if (currentUser != null) {
      AppUser updatedUser = AppUser(
        id: currentUser.id,
        uniqueName: currentUser.uniqueName,
        phoneNumber: currentUser.phoneNumber,
        totalDebitMoney: currentUser.totalDebitMoney,
        totalMoneyOwed: currentUser.totalMoneyOwed,
        debitItems: newDebitItems,
      );
      await saveUser(updatedUser);
    }
  }

  // Add a new debit item
  static Future<void> addDebitItem(DebitItem newItem) async {
    AppUser? currentUser = await getUser();
    if (currentUser != null) {
      List<DebitItem> updatedItems = List.from(currentUser.debitItems);
      updatedItems.add(newItem);
      
      AppUser updatedUser = AppUser(
        id: currentUser.id,
        uniqueName: currentUser.uniqueName,
        phoneNumber: currentUser.phoneNumber,
        totalDebitMoney: currentUser.totalDebitMoney,
        totalMoneyOwed: currentUser.totalMoneyOwed,
        debitItems: updatedItems,
      );
      await saveUser(updatedUser);
    }
  }

  // Remove a debit item
  static Future<void> removeDebitItem(String itemId) async {
    AppUser? currentUser = await getUser();
    if (currentUser != null) {
      List<DebitItem> updatedItems = currentUser.debitItems
          .where((item) => item.id != itemId) // Assuming DebitItem has an id field
          .toList();
      
      AppUser updatedUser = AppUser(
        id: currentUser.id,
        uniqueName: currentUser.uniqueName,
        phoneNumber: currentUser.phoneNumber,
        totalDebitMoney: currentUser.totalDebitMoney,
        totalMoneyOwed: currentUser.totalMoneyOwed,
        debitItems: updatedItems,
      );
      await saveUser(updatedUser);
    }
  }
*/
 
}