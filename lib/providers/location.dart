import 'package:flutter/cupertino.dart';
import 'package:flutter_code_challenge/models/coordinates.dart';
import 'package:geolocator/geolocator.dart';

class Location extends ChangeNotifier {
  bool isBusy = false;
  Coordinates? coordinates;

  // Specify notifyListeners flag to allow callers to decide whether or not
  // they are notifying actions and to prevent unnecessary rebuilds.
  Future<void> getPosition({bool notifyListeners = true}) async {
    bool serviceEnabled;
    LocationPermission permission;

    isBusy = true;

    _callNotifyListeners(notifyListeners);

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      isBusy = false;

      _callNotifyListeners(notifyListeners);

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        isBusy = false;

        _callNotifyListeners(notifyListeners);

        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        isBusy = false;

        _callNotifyListeners(notifyListeners);

        return Future.error('Location permissions are denied');
      }
    }

    final Position position = await Geolocator.getCurrentPosition();

    coordinates = Coordinates(position.latitude, position.longitude);
    isBusy = false;

    _callNotifyListeners(notifyListeners);
  }

  // Some getPosition callers don't need to notify others of the change.
  // Callers can specify that they don't need to notify the other listeners
  // and prevent unnecessary rebuilds.
  void _callNotifyListeners(bool shouldNotifyListeners) async {
    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }
}
