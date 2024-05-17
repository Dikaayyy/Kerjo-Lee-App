import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text('Tidak dapat memuat data user.'),
            );
          }
          if (!snap.hasData || !snap.data!.exists) {
            return Center(
              child: Text('Tidak ada data user yang ditemukan.'),
            );
          }
          Map<String, dynamic> user = snap.data!.data()!;

          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        "https://ui-avatars.com/api/?name=${user['name']}",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "${user['name'].toString().toUpperCase()}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "${user['email']}",
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () =>
                    Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                leading: Icon(Icons.person),
                title: Text("Update Profile"),
              ),
              ListTile(
                onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                leading: Icon(Icons.vpn_key),
                title: Text("Change Password"),
              ),
              if (user['role'] == 'admin')
                ListTile(
                  onTap: () => Get.toNamed(Routes.ADD_KARYAWAN),
                  leading: Icon(Icons.person_add_alt_1),
                  title: Text("Add Karyawan"),
                ),
              ListTile(
                onTap: () => controller.logout(),
                leading: Icon(Icons.logout),
                title: Text("Logout"),
              ),
            ],
          );
        },
      ),
    );
  }
}
