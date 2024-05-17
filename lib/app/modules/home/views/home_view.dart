import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

//
class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: const Icon(Icons.person),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
          // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //   stream: controller.streamRole(),
          //   builder: (context, snap) {
          //     if (snap.connectionState == ConnectionState.waiting) {
          //       return SizedBox(); // Mengembalikan widget kosong saat menunggu data
          //     }

          //     if (snap.hasData && snap.data!.data() != null) {
          //       String role = snap.data!.data()!["role"];
          //       if (role == "admin") {
          //         return IconButton(
          //           onPressed: () => Get.toNamed(Routes.ADD_KARYAWAN),
          //           icon: const Icon(Icons.admin_panel_settings),
          //           style: ButtonStyle(
          //             foregroundColor: MaterialStateProperty.all(Colors.white),
          //           ),
          //         );
          //       } else {
          //         return SizedBox(); // Mengembalikan widget kosong untuk non-admin
          //       }
          //     }

          //     // Mengembalikan widget kosong jika tidak ada data
          //     return SizedBox();
          //   },
          // ),
        ],
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      // floatingActionButton: Obx(
      //   () => FloatingActionButton(
      //     onPressed: () async {
      //       if (controller.isLoading.isFalse) {
      //         controller.isLoading.value = true;
      //         await FirebaseAuth.instance.signOut();
      //         controller.isLoading.value = false;
      //         Get.offAllNamed(Routes.LOGIN);
      //       }
      //     },
      //     child: controller.isLoading.isFalse
      //         ? Icon(Icons.logout)
      //         : CircularProgressIndicator(),
      //   ),
      // ),
    );
  }
}
