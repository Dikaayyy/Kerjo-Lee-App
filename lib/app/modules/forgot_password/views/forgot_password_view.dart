import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          autocorrect: false,
          controller: controller.emailC,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.sendEmail();
                }
              },
              child : Text(
                controller.isLoading.isFalse ? 'SEND EMAIL' : 'LOADING . .',
                style:
                 const TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              
            )
            ),
      ]
    ),
    );
  }
}
