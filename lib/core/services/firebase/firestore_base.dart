// Auto-generated: firestore_base.dart
// This file contains shared Firestore references and constants used by the splitted services.
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRefs {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const String usersCollection = 'users';
  static const String debitItemsCollection = 'debitItems';
  static const String ownedItemsCollection = 'ownedItems';
  static const String monthlyDebitsCollection = 'monthlyDebits';
  static const String systemCollection = 'system';
  static const String uniqueNameField = 'uniqueName';
  static const String phoneNumberField = 'phoneNumber';
  static const String statusField = 'status';
  static const String createdAtField = 'createdAt';
  static const String recordMoneyValueField = 'recordMoneyValue';
  static const String totalDebitMoneyField = 'totalDebitMoney';
  static const String totalMoneyOwedField = 'totalMoneyOwed';
  static const String totalOwnedMoneyField = 'totalOwnedMoney';

  // Collection references helpers
  static CollectionReference usersRef() => firestore.collection(usersCollection);
  static CollectionReference debitItemsRef(String userId) => usersRef().doc(userId).collection(debitItemsCollection);
  static CollectionReference ownedItemsRef(String userId) => usersRef().doc(userId).collection(ownedItemsCollection);
  static CollectionReference monthlyDebitsRef() => firestore.collection(monthlyDebitsCollection);
  static CollectionReference systemRef() => firestore.collection(systemCollection);
}
