import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // try {
  //   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // } catch (e) {
  //   // ignore: avoid_print
  //   print(e);
  // }
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
    ),
  );
}
