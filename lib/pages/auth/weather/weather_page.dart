import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/models/coordinates.dart';
import 'package:flutter_code_challenge/providers/location.dart';
import 'package:flutter_code_challenge/repositories/weather.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          // Check if coordinates are already available...
          child: context.read<Location>().coordinates != null
              // Proceed to build the Weather widget...
              ? _buildWeatherWidget(context.read<Location>().coordinates!)
              // Otherwise, use FutureBuilder to get coordinates first before
              // building the Weather widget.
              : FutureBuilder<void>(
                  future: context.read<Location>().getPosition(
                        notifyListeners: false,
                      ),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<void> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        !snapshot.hasError) {
                      return _buildWeatherWidget(
                          context.read<Location>().coordinates!);
                    }

                    if (snapshot.hasError) {
                      return Text(
                          'An error has occurred: ${snapshot.error.toString()}');
                    }

                    return CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildWeatherWidget(Coordinates coordinates) {
    return FutureBuilder<Weather>(
      future: WeatherRepository.getWeather(coordinates),
      builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
        if (snapshot.hasData) {
          final Size size = MediaQuery.of(context).size;

          // Check for screen size:
          return size.width < 768
              // Use specified small screen display...
              ? _buildSmallScreenWeather(snapshot.data!)
              // Otherwise, use specified big screen display.
              : _buildLargeScreenWeather(snapshot.data!);
        }

        if (snapshot.hasError) {
          Text('An error has occurred: ${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildSmallScreenWeather(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(weather.areaName!),
        Table(
          border: TableBorder.all(),
          columnWidths: {
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Text('Date'),
                ),
                TableCell(
                  child: Text('Temperature (F)'),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Text(_formatDate(weather.date!)),
                ),
                TableCell(
                  child:
                      Text(weather.temperature!.fahrenheit!.toStringAsFixed(1)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLargeScreenWeather(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(weather.areaName!),
        Table(
          border: TableBorder.all(),
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Text('Date'),
                ),
                TableCell(
                  child: Text('Temperature (F)'),
                ),
                TableCell(
                  child: Text('Description'),
                ),
                TableCell(
                  child: Text('Main'),
                ),
                TableCell(
                  child: Text('Pressure'),
                ),
                TableCell(
                  child: Text('Humidity'),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Text(_formatDate(weather.date!)),
                ),
                TableCell(
                  child:
                      Text(weather.temperature!.fahrenheit!.toStringAsFixed(1)),
                ),
                TableCell(
                  child: Text(weather.weatherDescription!),
                ),
                TableCell(
                  child: Text(weather.weatherMain!),
                ),
                // Plugin broken? Get `pressure` and `humidity` from raw
                // response instead.
                TableCell(
                  child: Text('${weather.toJson()!['main']['pressure']}'),
                ),
                TableCell(
                  child: Text('${weather.toJson()!['main']['humidity']}'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Use package:intl for date formatting.
  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }
}
