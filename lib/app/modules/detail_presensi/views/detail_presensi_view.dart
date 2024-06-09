import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
          color: Colors.white,),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date']))}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Time : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}',
                ),
                Text(
                    'Position : ${data['masuk']!['lat']}, ${data['masuk']?['long']}'),
                Text('Status : ${data['masuk']!['status']}'),
                Text(
                    'Distance : ${data['masuk']!['distance'].toString().split(".").first} meters'),
                Text("Address : ${data['masuk']!['address']}"),
                SizedBox(height: 20),
                Text(
                  'Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data['Keluar']?['date'] == null
                      ? "Time : -"
                      : 'Time : ${DateFormat.jms().format(DateTime.parse(data['Keluar']!['date']))}',
                ),
                Text(data['Keluar']?['lat'] == null &&
                        data['Keluar']?['long'] == null
                    ? "Position : -"
                    : 'Position : ${data['Keluar']!['lat']}, ${data['Keluar']?['long']}'),
                Text(data['Keluar']?['status'] == null
                    ? "Status : -"
                    : 'Status : ${data['Keluar']!['status']}'),
                Text(data['Keluar']?['distance'] == null
                    ? "Status : -"
                    : 'Distance : ${data['Keluar']!['distance'].toString().split(".").first} meters'),
                Text(data['Keluar']?['address'] == null
                    ? "Status : -"
                    : "Address : ${data['Keluar']!['address']}"),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
