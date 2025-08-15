import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/utils/functions/simple_bloc_observer.dart';
import 'package:madunia/core/utils/router/app_router.dart';
import 'package:madunia/features/app/presentation/view_model/cubit/app_cubit.dart';
import 'package:madunia/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}

//** */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  



  

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,

        title: 'Madunia App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
