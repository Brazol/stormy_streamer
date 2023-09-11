import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:stormy_streamer/extensions.dart';
import 'package:stormy_streamer/predictor/weather_api/open_meteo_api.dart';
import 'package:stormy_streamer/predictor/weather_api/tomorrow_api.dart';
import 'package:stormy_streamer/stormy_streamer.dart';

void main() {
  late Dio dio;

  const openMeteoResponse = '''
                {
                  "daily": {
                    "time": [
                      "2023-09-10",
                      "2023-09-11",
                      "2023-09-12",
                      "2023-09-13"
                    ],
                    "weathercode": [
                      3,
                      3,
                      3,
                      80
                    ],
                    "temperature_2m_max": [
                      30.6,
                      30.2,
                      29.5,
                      20.4
                    ]
                  }
                }
                ''';

  const tomorrowResponse = '''
                {
                  "data": {
                    "timelines": [
                      {
                        "timestep": "1d",
                        "endTime": "2023-09-15T04:00:00Z",
                        "startTime": "2023-09-11T04:00:00Z",
                        "intervals": [
                          {
                            "startTime": "2023-09-11T04:00:00Z",
                            "values": {
                              "temperature": 24.13,
                              "weatherCode": 1001
                            }
                          },
                          {
                            "startTime": "2023-09-12T04:00:00Z",
                            "values": {
                              "temperature": 22.83,
                              "weatherCode": 1001
                            }
                          },
                          {
                            "startTime": "2023-09-13T04:00:00Z",
                            "values": {
                              "temperature": 19.2,
                              "weatherCode": 1100
                            }
                          },
                          {
                            "startTime": "2023-09-14T04:00:00Z",
                            "values": {
                              "temperature": 20.72,
                              "weatherCode": 1100
                            }
                          }
                        ]
                      }
                    ]
                  }
                }
                ''';

  setUp(() {
    dio = Dio();

    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onGet(
      RegExp('.*?api.open-meteo.*'),
      (server) => server.reply(
        200,
        jsonDecode(
          openMeteoResponse,
        ),
      ),
    );

    dioAdapter.onGet(
      RegExp('.*?api.tomorrow.*'),
      (server) => server.reply(
        200,
        jsonDecode(
          tomorrowResponse,
        ),
      ),
    );
  });

  test('Correctly maps Open Meteo data to [WeatherForecast]', () async {
    final openMeteoApi = OpenMeteoApi(const StormyConfiguration(), dio: dio);
    final result = await openMeteoApi.weatherForecastForLocation(1, 2, DateTime.now(), DateTime.now());

    expect(result.length, 4);
    expect(result.firstOrNull?.date, DateTime(2023, 9, 10));
    expect(result.firstOrNull?.temperture, 30.6);
    expect(result.firstOrNull?.condition, WeatherCondition.clear);
  });

  test('Correctly maps Tomorrow data to [WeatherForecast]', () async {
    final tomorrowApi = TomorrowWeatherApi(const StormyConfiguration(apiKey: 'api_key'), dio: dio);
    final result = await tomorrowApi.weatherForecastForLocation(1, 2, DateTime.now(), DateTime.now());

    expect(result.length, 4);
    expect(result.firstOrNull?.date.startOfDay, DateTime(2023, 9, 11));
    expect(result.firstOrNull?.temperture, 24.13);
    expect(result.firstOrNull?.condition, WeatherCondition.cloudy);
  });
}
