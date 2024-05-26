// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:presence/app/routes/app_pages.dart';
// import '../controllers/home_controller.dart';
// import '../../../controllers/page_index_controller.dart';

// //
// class HomeView extends GetView<HomeController> {
//   final pageC = Get.find<PageIndexController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('HOME'),
//         titleTextStyle: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(
//             onPressed: () => Get.toNamed(Routes.PROFILE),
//             icon: const Icon(Icons.person),
//             style: ButtonStyle(
//               foregroundColor: MaterialStateProperty.all(Colors.white),
//             ),
//           ),
//         ],
//         centerTitle: true,
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(20),
//         children: [
//           Row(
//             children: [
//               ClipOval(
//                 child: Container(
//                   width: 75,
//                   height: 75,
//                   color: Colors.grey[200],
//                   child: Center(child: Text ("X"),),
//                   // child: Image.network(src),
//                 ),
//               ),
//               SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Selamat Datang!", 
//                   style: 
//                   TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text("Jl. Sugeng Sukocok"),
//                 ],
//               )
//             ],
//           ),
//           SizedBox(height: 20,),
//           Container(
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//             color: Colors.grey[200],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Developer", style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold
//                 ),
//                 ),
//                 SizedBox(height: 20,),
//                 Text("12039133131", style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold
//                 ),
//                 ),
//                  SizedBox(height: 15,),
//                 Text("Adika Akbar Karyawan", style: TextStyle(
//                   fontSize: 18,
//                 ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20,),
//           Container(
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//             color: Colors.grey[200],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Column(
//                   children: [
//                     Text("Masuk"),
//                     Text("-"),
//                   ],
//                 ),
//                 Container(
//                   width: 2,
//                   height: 40,
//                   color: Colors.grey,
//                 ),
//                 Column(
//                   children: [
//                     Text("Keluar"),
//                     Text("-"),
//                   ],
//                 )
//               ],),
//           ),
//           SizedBox(height: 20,),
//           Divider(
//             color: Colors.grey[300],
//             thickness: 2,
//           ),
//           SizedBox(height: 10,),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Last 5 days", style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                  ),
//               ),
//               TextButton(onPressed: (){}, child: Text("See more")),
//             ],
//           ),
//           SizedBox(height: 10),
//       ListView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: 5,
//         itemBuilder: (context, Index) {
//           return Container(
//             margin: EdgeInsets.only(bottom: 10),
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//             color: Colors.grey[200],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Masuk", style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                      ),
//                     ),
//                     Text("${DateFormat.yMMMEd().format(DateTime.now())}", style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                      ),
//                     ),
//                   ],
//                 ),
//                 Text("${DateFormat.jms().format(DateTime.now())}"),
//                 SizedBox(height: 10,),
//                 Text("Keluar", style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                  ),),
//                 Text("${DateFormat.jms().format(DateTime.now())}"),
//                 ],
//             ),
//           );
//         }

//       )
//         ],
//       ),
//       bottomNavigationBar: ConvexAppBar(
//         items: [
//           TabItem(icon: Icons.home, title: 'Home'),
//           TabItem(icon: Icons.fingerprint, title: 'Add'),
//           TabItem(icon: Icons.person, title: 'Profile'),
//         ],
//         initialActiveIndex: pageC.pageIndex.value,
//         onTap: (int i) => pageC.changePage(i),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: const Icon(Icons.person),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator()
            );
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
                          user["profile"] != null ? user["profile"] : defaultImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selamat Datang!",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(user["address"] ?? "Alamat tidak tersedia"),
                      ],
                    )
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "${user['nik']}",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Masuk"),
                          Text("-"),
                        ],
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.grey,
                      ),
                      Column(
                        children: [
                          Text("Keluar"),
                          Text("-"),
                        ],
                      )
                    ],
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
                    TextButton(onPressed: () {}, child: Text("See more")),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Masuk",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${DateFormat.yMMMEd().format(DateTime.now())}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text("${DateFormat.jms().format(DateTime.now())}"),
                          SizedBox(height: 10),
                          Text(
                            "Keluar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("${DateFormat.jms().format(DateTime.now())}"),
                        ],
                      ),
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
        }
      ),
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


