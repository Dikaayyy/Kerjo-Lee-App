// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passwordC.text);

        print(userCredential.user);

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            Get.offAllNamed(
              Routes.HOME,
            );
          } else {
            Get.defaultDialog(
              title: 'Email not verified',
              middleText: 'Please verify your email',
              onConfirm: () async {
                await userCredential.user!.sendEmailVerification();
                Get.back();
              },
            );
            try {
              await userCredential.user!.sendEmailVerification();
            } catch (e) {}
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar(
            'Error',
            'No user found for that email.',
          );
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
            'Error',
            'Wrong password provided for that user.',
          );
        }
      } catch (e) {
        Get.snackbar('Error', 'Cant login');
      }
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }
}
