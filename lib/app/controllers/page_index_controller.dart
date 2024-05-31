import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
            print('Position: latitude=${position.latitude}, longitude=${position.longitude}'); // Log position
            await updatePosition(position);
            
            List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
            print('Placemarks: $placemarks'); // Log placemarks
            if (placemarks != null && placemarks.isNotEmpty) {
              print('Placemark name: ${placemarks[0].name}');
            } else {
              print('No placemarks found.');
            }
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

  Future<void> updatePosition(Position position) async {
    String uid = auth.currentUser!.uid;
    try {
      await firestore.collection("karyawan").doc(uid).update({
        "position": {
          "latitude": position.latitude,
          "longitude": position.longitude,
        }
      });
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
