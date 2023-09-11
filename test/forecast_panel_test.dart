import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stormy_streamer/predictor/weather_api/weather_api.dart';
import 'package:stormy_streamer/presentation/forecast_controller.dart';

import 'package:stormy_streamer/stormy_streamer.dart';

class MockedWeatherApi extends Mock implements WeatherApi {}

void main() {
  late MockedWeatherApi mockedApi;
  late StormyPredictor predictor;

  List<WeatherForecast> forecast = [
    WeatherForecast(date: DateTime(1999, 1, 1), temperture: 21, condition: WeatherCondition.clear, units: Units.metric),
    WeatherForecast(
        date: DateTime(1999, 1, 2), temperture: 22, condition: WeatherCondition.cloudy, units: Units.metric),
    WeatherForecast(date: DateTime(1999, 1, 3), temperture: 23, condition: WeatherCondition.rain, units: Units.metric),
    WeatherForecast(date: DateTime(1999, 1, 4), temperture: 24, condition: WeatherCondition.snow, units: Units.metric),
    WeatherForecast(
        date: DateTime(1999, 1, 5), temperture: 25, condition: WeatherCondition.thunderstorm, units: Units.imperial),
  ];

  setUp(() {
    mockedApi = MockedWeatherApi();

    when(() => mockedApi.weatherForecastForLocation(any(), any(), any(), any()))
        .thenAnswer((_) => Future.value(forecast));

    when(() => mockedApi.configuration).thenReturn(const StormyConfiguration());

    predictor = StormyPredictor.withCustomApi(mockedApi);
  });

  testWidgets('Refresh on [ForecastController] fetches weather forecast', (WidgetTester tester) async {
    final controller = ForecastController.withPredictor(predictor);

    await tester.pumpWidget(
      MaterialApp(
        home: StormyForecastPanel(
          dateFrom: DateTime.now(),
          longitude: 1,
          latitude: 2,
          controller: controller,
        ),
      ),
    );

    verify(() => mockedApi.weatherForecastForLocation(2, 1, any(), any())).called(1);
    await controller.refresh();
    verify(() => mockedApi.weatherForecastForLocation(2, 1, any(), any())).called(1);
  });

  testWidgets('Displays all weather icons correctly', (WidgetTester tester) async {
    final controller = ForecastController.withPredictor(predictor);

    await tester.pumpWidget(
      MaterialApp(
        home: StormyForecastPanel(
          dateFrom: DateTime.now(),
          longitude: 1,
          latitude: 2,
          controller: controller,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.image(const AssetImage('assets/clear.png', package: 'stormy_streamer')), findsOneWidget);
    expect(find.image(const AssetImage('assets/cloudy.png', package: 'stormy_streamer')), findsOneWidget);
    expect(find.image(const AssetImage('assets/rain.png', package: 'stormy_streamer')), findsOneWidget);
    expect(find.image(const AssetImage('assets/snow.png', package: 'stormy_streamer')), findsOneWidget);
    expect(find.image(const AssetImage('assets/thunder.png', package: 'stormy_streamer')), findsOneWidget);
  });

  testWidgets('Displays correct metric system', (WidgetTester tester) async {
    final controller = ForecastController.withPredictor(predictor);

    await tester.pumpWidget(
      MaterialApp(
        home: StormyForecastPanel(
          dateFrom: DateTime.now(),
          longitude: 1,
          latitude: 2,
          controller: controller,
        ),
      ),
    );

    await tester.pumpAndSettle();

    find.text('21°C');
    find.text('25°F');
  });
}
