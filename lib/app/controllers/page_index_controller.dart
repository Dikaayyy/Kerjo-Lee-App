import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void changePage(int i) async {
    pageIndex.value = i;
    switch (i) {
      case 1:
        print('Absensi');
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];
          await updatePosition(position);
          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          print (placemarks[0].name);
          // Get.snackbar("${dataResponse["message"]}", "${} , ${}");
        } else {
          Get.snackbar("Error", dataResponse["message"]);
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
    await firestore.collection("karyawan").doc(uid).update({
      "position " : {
        "latitude " : position.latitude,
        "longitude" : position.longitude,
      }
    });
    // Update position logic here
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      // accessing the position and request users of the
      // app to enable the location services.
      return {
        "message": "Location services are disabled.",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your app should show an explanatory UI now.
        return {
          "message": "Location permissions are denied",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message": "Change your location settings on your phone",
        "error": true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Posisi device berhasil didapatkan",
      "error": false,
    };
  }
}
