import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: controller.newPassC, // Tambahkan koma di sini
            decoration: InputDecoration(
              labelText: "New Password", // Tambahkan koma di sini
              border: OutlineInputBorder(), // Tambahkan koma di sini
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.newPassword();// Tambahkan logika yang sesuai di sini
            }, 
            child: Text("Continue"),
          ),
        ],
      ),
    );
  }
}

