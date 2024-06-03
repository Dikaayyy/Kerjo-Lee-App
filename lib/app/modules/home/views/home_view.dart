import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../../../controllers/page_index_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        // actions: [
        //   IconButton(
        //     onPressed: () => Get.toNamed(Routes.PROFILE),
        //     icon: const Icon(Icons.person),
        //     style: ButtonStyle(
        //       foregroundColor: MaterialStateProperty.all(Colors.white),
        //     ),
        //   ),
        // ],
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${user['name']}";

              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 75,
                          height: 75,
                          color: Colors.grey[200],
                          child: Image.network(
                            user["profile"] != null
                                ? user["profile"]
                                : defaultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Adventurer!",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${user['name']}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 200,
                            child: Text(user["address"] != null
                                ? "${user['address']}"
                                : "Address not eligible"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user['job']}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "${user['nik']}",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "${user['name']}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamTodayPresence(),
                      builder: (context, snapToday) {
                        if(snapToday.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );

                        }

                        Map<String, dynamic>?dataToday = snapToday.data?.data();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text("In"),
                                Text(dataToday?["masuk"] == null ? "-" : "${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['date']))}"),
                              ],
                            ),
                            Container(
                              width: 2,
                              height: 40,
                              color: Colors.grey,
                            ),
                            Column(
                              children: [
                                Text("Out"),
                                Text(dataToday?["keluar"] == null ? "-"  : "${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['date']))}"),
                              ],
                            )
                          ],
                        );
                      }
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Last 5 days",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.ALL_PRESENSI),
                        child: Text(
                          "See more",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamLastPresence(),
                    builder: (context, snapPresence) {
                      if (snapPresence.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      print(snapPresence.data);
                      if (snapPresence.data?.docs.length == 0 ||
                          snapPresence.data == null) {
                        return SizedBox(
                          height: 250,
                          child: Center(
                            child: Text("Anda Belum Pernah Absen"),
                          ),
                        );
                      }
                      print(snapPresence);
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapPresence.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapPresence
                              .data!.docs[index]
                              .data();
                              
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Material(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed("/detail-presensi");
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "In",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(data['masuk']?['date'] == null
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}"),
                                      SizedBox(height: 10),
                                      Text(
                                        "Out",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(data['Keluar']?['date'] == null
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(data['Keluar']!['date']))}"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("Tidak dapat memuat database user"),
              );
            }
          }),
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Add'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
