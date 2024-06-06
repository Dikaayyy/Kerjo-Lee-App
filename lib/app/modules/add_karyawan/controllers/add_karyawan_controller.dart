import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddKaryawanController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddKaryawan = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nikC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController passC = TextEditingController(); // New password controller for karyawan
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prossesAddKaryawan() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddKaryawan.value = true;
      try {
        User? currentUser = auth.currentUser;
        String emailVerified = currentUser?.email ?? '';

        // Verifikasi admin credentials
        UserCredential userCredentialAdmin = await auth.signInWithEmailAndPassword(
          email: emailVerified, 
          password: passAdminC.text,
        );

        if (userCredentialAdmin.user != null) {
          UserCredential karyawanCredential = await auth.createUserWithEmailAndPassword(
            email: emailC.text, 
            password: passC.text,  // Use the new password field
          );

          if (karyawanCredential.user != null) {
            String uid = karyawanCredential.user!.uid;

            await firestore.collection("karyawan").doc(uid).set({
              "name": nameC.text,
              "nik": nikC.text,
              "email": emailC.text,
              "job": jobC.text,
              "uid": uid,
              "role": "karyawan",
              "createdAt": DateTime.now().toIso8601String(),
            });

            await karyawanCredential.user!.sendEmailVerification();

            // Sign in kembali dengan admin credentials setelah pembuatan akun karyawan
            await auth.signOut();
            await auth.signInWithEmailAndPassword(
              email: emailVerified,
              password: passAdminC.text,
            );

            Get.back();
            Get.back();
            Get.snackbar("Succes", "Berhasil Menambahkan Karyawan");
          }
        }
      } on FirebaseAuthException catch (e) {
        isLoadingAddKaryawan.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar('Error', 'The password provided is too weak. Please try again.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Error', 'The account already exists for that email.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Error', 'Cannot login, wrong password.');
        } else {
          Get.snackbar('Error', '${e.code}');
        }
      } catch (e) {
        isLoadingAddKaryawan.value = false;
        Get.snackbar('Error', 'An error occurred: $e');
      } finally {
        isLoadingAddKaryawan.value = false;
      }
    } else {
      Get.snackbar("Error", "Password Wajib Diisi");
    }
  }

  Future<void> addKaryawan() async {
    if (nameC.text.isNotEmpty &&
        nikC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        passC.text.isNotEmpty) {  // Add password check
      isLoading.value = true;
      Get.defaultDialog(
        title: "Verifikasi Admin",
        content: Column(
          children: [
            Text("Masukkan Password Anda untuk Verifikasi Admin"),
            SizedBox(height: 15),
            TextField(
              controller: passAdminC,
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
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingAddKaryawan.isFalse) {
                  await prossesAddKaryawan();
                }
                isLoading.value = false;
              },
              child: Text(isLoadingAddKaryawan.isFalse ? "TAMBAHKAN KARYAWAN" : "LOADING..."),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }
}
