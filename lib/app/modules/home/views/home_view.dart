import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

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
            onPressed: () => Get.toNamed(Routes.ADD_KARYAWAN),
            icon: const Icon(Icons.admin_panel_settings),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton:Obx(
        ()=> FloatingActionButton(
        onPressed: () async {
          if(controller.isLoading.isFalse){
            controller.isLoading.value = true;
            await FirebaseAuth.instance.signOut();
            controller.isLoading.value = false;
            Get.offAllNamed(Routes.LOGIN);
          } 
        },
        child: controller.isLoading.isFalse ? Icon(Icons.logout) : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
//kontolbabi
