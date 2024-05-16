import 'dart:ffi';

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

  Future<void> prossesAddKaryawan() async{
    if (passwordC.text.isNotEmpty){
      try {
        String emailVerified = auth.currentUser!.email!;

        UserCredential userCredentialAdmin = await auth.signInWithEmailAndPassword(
          email: emailVerified, 
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
          //await auth.signInWithEmailAndPassword(email: email, password: password);
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              'Error', 'The password provided is too weak. Please try again.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Error', 'The account already exists for that email.');
        } else if (e.code == "wrong-password"){
          Get.snackbar('Error', 'Can not Login, Wronng Password');
        } else {
          Get.snackbar('Error', '${e.code}');
        }
      } catch (e) {
        Get.snackbar('Error', 'Cant register');
      }
     } else{
        Get.snackbar("PERINGATAN", "Password Wajib Diisi");
      }
  }
  void addKaryawan() async {
    if (nameC.text.isNotEmpty &&
        nikC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        passwordC.text.isNotEmpty) {
          Get.defaultDialog(
            title: "Verfikasi Admin",
            content: Column(
              children: [
                Text("Masukkan Password Anda untuk Verifikasi Admin"),
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
                onPressed: () => Get.back(), 
                child: Text("BATALKAN"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await prossesAddKaryawan();
                    }, 
                  child: Text("TAMBAHKAN KARYAWAN"),
                ),
            ],
          );
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }
}
