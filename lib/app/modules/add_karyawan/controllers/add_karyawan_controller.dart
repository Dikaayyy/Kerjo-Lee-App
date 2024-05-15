import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddKaryawanController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nikC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addKaryawan() async {
    if (nameC.text.isNotEmpty &&
        nikC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: passwordC.text);

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;

          await firestore.collection("karyawan").doc(uid).set({
            "name": nameC.text,
            "nik": nikC.text,
            "email": emailC.text,
            "password": passwordC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });

          await userCredential.user!.sendEmailVerification();
        }

        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              'Error', 'The password provided is too weak. Please try again.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Error', 'The account already exists for that email.');
        }
      } catch (e) {
        Get.snackbar('Error', 'Cant register');
      }
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }
}
