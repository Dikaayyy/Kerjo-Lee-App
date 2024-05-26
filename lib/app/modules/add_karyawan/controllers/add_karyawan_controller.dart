// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AddKaryawanController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddKaryawan = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nikC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prossesAddKaryawan() async {
    if (passwordC.text.isNotEmpty) {
      isLoadingAddKaryawan.value = true;
      try {
        String emailVerified = auth.currentUser!.email!;
        UserCredential userCredentialAdmin = await auth.signInWithEmailAndPassword(
          email: emailC.text, 
          password: passwordC.text,);

        UserCredential KaryawanCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "password");

        if (KaryawanCredential.user != null) {
          String uid = KaryawanCredential.user!.uid;

          await firestore.collection("karyawan").doc(uid).set({
            "name": nameC.text,
            "nik": nikC.text,
            "email": emailC.text,
            "password": passwordC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });

          await KaryawanCredential.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential userCredentialAdmin = await auth.signInWithEmailAndPassword(
            email: emailVerified, 
            password: passwordC.text,
            );

          Get.back();
          Get.back();
          Get.snackbar("Succes", "Berhasil Menambahkan Karyawan");
        }
          isLoadingAddKaryawan.value = false;
          //await auth.signInWithEmailAndPassword(email: email, password: password);

      } on FirebaseAuthException catch (e) {
        isLoadingAddKaryawan.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar(
              'Error', 'The password provided is too weak. Please try again.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Error', 'The account already exists for that email.');
        } else if (e.code == "wrong-password"){
          Get.snackbar('Error', 'Can not Login, Wrong Password');
        } else {
          Get.snackbar('Error', '${e.code}');
        }
      } catch (e) {
        isLoadingAddKaryawan.value = false;
        Get.snackbar('PERINGATAN', 'Password Salah');
      }
     } else{
        Get.snackbar("PERINGATAN", "Password Wajib Diisi");
      }
  }
  Future <void> addKaryawan() async {
    if (nameC.text.isNotEmpty &&
        nikC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        passwordC.text.isNotEmpty) {
          isLoading.value = true;
          Get.defaultDialog(
            title: "Verfikasi Admin",
            content: Column(
              children: [
                Text("Masukkan Password Anda untuk Verifikasi Admin"),
                SizedBox(height: 15),
                TextField(
                  controller: passwordC,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  isLoading.value = false;
                  Get.back();
                },
                child: Text("BATALKAN"),
                ),
                Obx(
                  ()=> ElevatedButton (onPressed: () async {
                    if(isLoadingAddKaryawan.isFalse){
                      await prossesAddKaryawan();
                    }
                    isLoading.value = false;
                    }, 
                  child: Text(isLoadingAddKaryawan.isFalse ? "TAMBAHKAN KARYAWAN" : "LOADING . ."),
                ),
               ),
            ],
          );
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }
}
