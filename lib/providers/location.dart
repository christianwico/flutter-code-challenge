import 'package:flutter/cupertino.dart';
import 'package:flutter_code_challenge/models/coordinates.dart';
import 'package:geolocator/geolocator.dart';

class Location extends ChangeNotifier {
  bool isBusy = false;
  Coordinates? coordinates;

  Future<void> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    isBusy = true;

    notifyListeners();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      isBusy = false;

      notifyListeners();

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        isBusy = false;

        notifyListeners();

        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        isBusy = false;

        notifyListeners();

        return Future.error('Location permissions are denied');
      }
    }

    final Position position = await Geolocator.getCurrentPosition();

    coordinates = Coordinates(position.latitude, position.longitude);
    isBusy = false;

    notifyListeners();
  }
}
