import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nikC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProfile(String uid) async {
    isLoading.value = true;
    if (nameC.text.isNotEmpty &&
        nikC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        await firestore.collection("karyawan").doc(uid).update({
          "name": nameC.text,
          "email": emailC.text,
        });
        Get.back();
        Get.snackbar("Succes", "Update Profile Successfully");
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
      isLoading.value = false;
    }
  }
}
