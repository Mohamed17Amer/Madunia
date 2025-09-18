// Auto-generated: firebase_services.dart (barrel file)
export 'firebase/firestore_base.dart';
export 'firebase/firestore_helpers.dart';
export 'firebase/user_service.dart';
export 'firebase/firestore/debit_service.dart';
export 'firebase/firestore/owned_service.dart';
export 'firebase/firestore/firestore_debit_monthly_service.dart';
export 'firebase/firestore/firestore_chat.dart';


/*


DebitService debitService = DebitService();
OwnedService ownedService = OwnedService();
UserService userService = UserService();
FirestoreDebitMonthlyService firestoreDebitMonthlyService = FirestoreDebitMonthlyService(); 



*/

/////////////////////////////////////////////////////////////////////

/*


final shouldRun = await debitMonthlyService.shouldExecuteMonthlyDebits();
if (shouldRun) {
  await debitMonthlyService.executeMonthlyDebits();
}

*/

/////////////////////////////////////////////////////////////////////


/**
 * 
 * 
 * 
 
 Option 3 – Truly Automatic (Backend)

⚠️ Flutter alone cannot guarantee monthly automation, because your app code only runs when someone opens it.

If you need guaranteed execution every month (even if no one opens the app):

Use Firebase Cloud Functions + Pub/Sub schedule to call the Firestore logic.

That way, it runs on the server on the 1st of every month automatically.
 
 */