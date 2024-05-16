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
  
  runApp(
    StreamBuilder<User?> (
      stream : FirebaseAuth.instance.authStateChanges(),
      builder: (context, Snapshot){
        if (Snapshot.connectionState == ConnectionState.waiting){
          return MaterialApp(
            home:Scaffold(
              body:Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        print (Snapshot.data);
        return GetMaterialApp(
          title: "Application",
          initialRoute: Snapshot.data != null ? Routes.HOME : Routes.LOGIN,
          getPages: AppPages.routes,
        );
      }
    ),
  );
}

