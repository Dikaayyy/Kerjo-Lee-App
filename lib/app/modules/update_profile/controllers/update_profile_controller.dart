import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

FirebaseFirestore firestore = FirebaseFirestore.instance;
s.FirebaseStorage storage = s.FirebaseStorage.instance;
class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nikC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

final ImagePicker picker = ImagePicker();
 XFile ? image;
void pickImage() async {
   image = await picker.pickImage(source: ImageSource.gallery);
  update();
}
  Future<void> updateProfile(String uid) async {
    isLoading.value = true;
    Map<String, dynamic> data = {
          "name": nameC.text,
          "email": emailC.text,
        };
    if (nameC.text.isNotEmpty &&
        nikC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        if (image != null) {
          File file = File(image!.path);
          String ext = (image!.name.split(".").last);
          await storage.ref ('$uid/profile.$ext').putFile(file);
          String urlImage = await storage.ref ('$uid/profile.$ext').getDownloadURL();

          data.addAll({"profile" : urlImage});
          }
        await firestore.collection("karyawan").doc(uid).update(data);
        image = null;
        Get.back();
        Get.snackbar("Succes", "Update Profile Successfully");
      } catch (e) {
        Get.snackbar("Error", "Can not Update Profile"); 
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection("karyawan").doc(uid).update({
      "profile" : FieldValue.delete(),
      });
      Get.back();
      Get.snackbar("Succes", "Delete Profile Succesfully");
    } catch (e) {
      Get.snackbar("Error", "Can not Delete Profile");
    } finally {
      update ();
    }
  }
}
