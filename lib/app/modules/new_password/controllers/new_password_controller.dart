import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC= TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void newPassword() async{
    if (newPassC.text.isNotEmpty){
      if (newPassC.text != "password"){
        await auth.currentUser!.updatePassword(newPassC.text);
        try {
          String email = auth.currentUser!.email!;

        await auth.signOut();
        
        await auth.signInWithEmailAndPassword(email: email, password: newPassC.text);

        Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
        Get.snackbar('Error', 'Password is too weak, at least 6 charachters');
      } 
        } catch (e) {
          Get.snackbar('Error', 'Can not make new password.');
        }
        
      } else{
        Get.snackbar("Something Went Wrong", "Password Baru Wajib Diubah");
      }
      
    } else {
      Get.snackbar("Something Went Wrong", "Password Baru Wajib Diisi");
    }
  }
}
