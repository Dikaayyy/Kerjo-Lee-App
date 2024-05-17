import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpdatePasswordView'),
        centerTitle: true,
      ),
      body :ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.currC,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password Saat ini',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: controller.newC,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password Baru',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: controller.ConfirmC,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Konfirmasi Password Baru',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 15),
          Obx(
            () => ElevatedButton(onPressed: (){
              if (controller.isLoading.isFalse){
                controller.updatePassword();
              }
            },
            child: Text ((controller.isLoading.isFalse) ? "GANTI PASSWORD" : "LOADING . ."),
            ),
          ),
        ],
      ),
    );
  }
}
