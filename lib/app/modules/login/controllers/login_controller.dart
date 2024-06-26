// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
  if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
    isLoading.value = true;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailC.text,
        password: passwordC.text,
      );

      print(userCredential.user);

      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified ==true) {
          isLoading.value = false;
          if (passwordC.text =="password"){
            Get.offAllNamed(Routes.NEW_PASSWORD);
          } else {
            Get.offAllNamed(Routes.HOME);
          } 
        } else {
          Get.defaultDialog(
            title: 'Email not verified',
            middleText: 'Please verify your email',
            actions: [
              OutlinedButton(
                onPressed: () {
                  isLoading.value = false;
                  Get.back();
                },
                child: Text("BATALKAN"),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await userCredential.user!.sendEmailVerification();
                    Get.back();
                    Get.snackbar("Success", "Verification email sent");
                    isLoading.value = false;
                  } catch (e) {
                    isLoading.value = false;
                    Get.snackbar("Error", "Cannot send verification email");
                    print("Error sending verification email: $e");
                  }
                },
                child: Text("KIRIM ULANG"),
              ),
            ],
          );
        }
      }
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');
      } else {
        Get.snackbar('Error', 'Authentication error: ${e.message}');
        print("Authentication error: ${e.code}, ${e.message}");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Cannot login');
      print("General error during login: $e");
    }
  } else {
    Get.snackbar('Error', 'Please fill all fields');
  }
}
}
