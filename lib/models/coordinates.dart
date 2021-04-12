class Coordinates {
  double latitude;
  double longitude;

  Coordinates(
    this.latitude,
    this.longitude,
  );

  String toString() {
    return 'Lat: $latitude, Lng: $longitude';
  }
}
