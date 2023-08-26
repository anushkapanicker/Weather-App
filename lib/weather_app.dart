import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/open_weather.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';

      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured!';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: RefreshProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final pressure = data['list'][0]['main']['pressure'];
          final humidity = data['list'][0]['main']['humidity'];
          final speed = data['list'][0]['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '$currentTemp',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Icon(
                            currentSky == 'Clouds' || currentSky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 64,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            currentSky,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // const SizedBox(height: 8.0),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 1; i <= 5; i++)
                //         HourlyForcastCard(
                //           time: data['list'][i]['dt_txt'].toString(),
                //           icon: data['list'][i]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   data['list'][i]['weather'][0]['main'] ==
                //                       'Rain'
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           temp: data['list'][i]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index]['weather'][0]['main'];
                      final hourlyTemp =
                          hourlyForecast['main']['temp'].toString();
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForcastCard(
                        time: DateFormat.Hm().format(time),
                        temp: hourlyTemp,
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: humidity.toString(),
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: speed.toString(),
                    ),
                    AdditionalInfo(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: pressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
