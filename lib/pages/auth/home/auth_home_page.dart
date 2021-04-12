import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/providers/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AuthHomePage extends StatefulWidget {
  @override
  _AuthHomePageState createState() => _AuthHomePageState();
}

class _AuthHomePageState extends State<AuthHomePage> {
  String? coordinates;
  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${context.read<Auth>().name}'),
            Text('GitHub URL: ${context.read<Auth>().githubPageUrl}'),
            isBusy
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _getCoordinates,
                    child: Text(
                        '${coordinates == null ? 'Get' : 'Update'} Coordinates'),
                  ),
            Text(coordinates ?? ''),
          ],
        ),
      ),
    );
  }

  Future<void> _getCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() => isBusy = true);

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() => isBusy = false);

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        setState(() => isBusy = false);

        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        setState(() => isBusy = false);

        return Future.error('Location permissions are denied');
      }
    }

    final Position position = await Geolocator.getCurrentPosition();

    setState(() {
      coordinates = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
      isBusy = false;
    });
  }
}
