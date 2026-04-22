import 'package:data_loop/Repositories/AuthRepository.dart';
import 'package:data_loop/Repositories/WalletRepository.dart';
import 'package:data_loop/SplashScreen.dart';
import 'package:data_loop/ViewsModels/AnnotationViewModel.dart';
import 'package:data_loop/ViewsModels/AuthViewModel.dart';
import 'package:data_loop/ViewsModels/WalletViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'Repositories/AnnotationRepository.dart';

Future<void> setup() async {
  await dotenv.load(fileName: ".env");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Authviewmodel(Authrepository()),
          ),
          ChangeNotifierProvider(
            create: (context) => Annotationviewmodel(Annotationrepository()),
          ),
          ChangeNotifierProvider(
            create: (context) => Walletviewmodel(Walletrepository()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Splashscreen(),
        ),
      ),
    );
  }
}
