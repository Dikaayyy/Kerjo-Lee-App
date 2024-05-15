import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_karyawan_controller.dart';

class AddKaryawanView extends GetView<AddKaryawanController> {
  const AddKaryawanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD KARYAWAN'),
        titleTextStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.nameC,
            decoration: InputDecoration(
              labelText: 'Name',
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
          TextField(
            controller: controller.nikC,
            decoration: InputDecoration(
              labelText: 'NIK',
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
          TextField(
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
          TextField(
            controller: controller.passwordC,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              controller.addKaryawan();
            },
            child: const Text(
              'ADD KARYAWAN',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 18,
              ),
              textStyle: const TextStyle(
                fontSize: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
