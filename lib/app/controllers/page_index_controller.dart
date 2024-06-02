import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    pageIndex.value = i;
    switch (i) {
      case 1:
        print('Absensi');
        try {
          Map<String, dynamic> dataResponse = await determinePosition();
          print('dataResponse: $dataResponse'); // Log dataResponse
          if (dataResponse["error"] != true) {
            Position position = dataResponse["position"];
            List<Placemark> placemarks = await placemarkFromCoordinates(
                position.latitude, position.longitude);
            String address =
                "${dataResponse['message']}, ${placemarks[0].name},${placemarks[0].subLocality},${placemarks[0].locality}";

            await updatePosition(position, address);

            await presensi(position, address);

            Get.snackbar("Success", "You presence");
          } else {
            Get.snackbar("Error", dataResponse["message"]);
          }
        } catch (e) {
          print('Error in changePage: $e'); // Log the error
          Get.snackbar("Error", "An unexpected error occurred.");
        }
        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(Position position, String address) async {
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colPresnce =
        await firestore.collection("karyawan").doc(uid).collection("Presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresnce.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");
    if (snapPresence.docs.length == 0) {
      await colPresnce.doc(todayDocID).set({
        "date": now.toIso8601String(),
        "masuk": {
          "date": now.toIso8601String(),
          "lat": position.latitude,
          "long": position.longitude,
          "address": address,
          "status": "In the Area",
        }
      });
    } else {
      Map<String, dynamic> dataPresence = snapPresence.docs.first.data();
      DateTime datePresence = DateTime.parse(dataPresence["date"]);
      if (DateFormat.yMd().format(now) ==
          DateFormat.yMd().format(datePresence)) {
        if (dataPresence["keluar"] == null) {
          await colPresnce.doc(todayDocID).update({
            "keluar": {
              "date": now.toIso8601String(),
              "lat": position.latitude,
              "long": position.longitude,
              "address": address,
              "status": "In the Area",
            }
          });
        } else {
          Get.snackbar("Error", "You presence in 5 minutes");
        }
      } else {
        Get.snackbar("Error", "You presence in 5 minutes");
      }
    }
    Future<void> updatePosition(Position position, String address) async {
      String uid = auth.currentUser!.uid;
      try {
        await firestore.collection("karyawan").doc(uid).update(
          {
            "position": {
              "latitude": position.latitude,
              "longitude": position.longitude,
            },
            "address": address,
          },
        );
        print('Position updated in Firestore'); // Log success
      } catch (e) {
        print('Error in updatePosition: $e'); // Log the error
        throw e; // Rethrow if needed to handle it outside
      }
    }

    Future<Map<String, dynamic>> determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return {
            "message": "Location services are disabled.",
            "error": true,
          };
        }

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return {
              "message": "Location permissions are denied",
              "error": true,
            };
          }
        }

        if (permission == LocationPermission.deniedForever) {
          return {
            "message": "Change your location settings on your phone",
            "error": true,
          };
        }

        Position position = await Geolocator.getCurrentPosition();
        print('Current position: $position'); // Log the position
        return {
          "position": position,
          "message": "Posisi device berhasil didapatkan",
          "error": false,
        };
      } catch (e) {
        print('Error in determinePosition: $e'); // Log the error
        return {
          "message": "Failed to get device position.",
          "error": true,
        };
      }
    }
  }

  determinePosition() {}

  updatePosition(Position position, String address) {}
}
