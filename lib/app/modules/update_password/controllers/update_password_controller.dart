import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    if (currC.text.isNotEmpty && newC.text.isNotEmpty && confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          // Re-authenticate with the current password
          await auth.signInWithEmailAndPassword(email: emailUser, password: currC.text);
          // Update the password
          await auth.currentUser!.updatePassword(newC.text);

          Get.back();
          Get.snackbar("Berhasil", "Password Berhasil Diubah");
        } on FirebaseAuthException catch (e) {
          // Check for specific error codes
          if (e.code == "wrong-password") {
            Get.snackbar("Terjadi Kesalahan", "Password Yang Dimasukkan Salah");
          } else {
            Get.snackbar("Terjadi Kesalahan", "${e.code}");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Password Tidak Dapat Diubah");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Terjadi Kesalahan", "Konfirmasi Password Tidak Cocok");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Wajib diisi semuanya");
    }
  }
}
