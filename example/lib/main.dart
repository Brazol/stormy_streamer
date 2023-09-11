import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stormy_streamer/presentation/forecast_controller.dart';
import 'package:stormy_streamer/stormy_streamer.dart';

void main() {
  runApp(const MyApp());
}

/// Example app for Stormy Streamer package
/// Demonstrates usage of [StormyForecastPanel] and [StormyPredictor] widgets
///
/// First usage of [StormyForecastPanel] uses [WeatheApiService.openMeteo] (default) to fetch weather forecast
///
/// Second usage of [StormyForecastPanel] uses [WeatheApiService.tomorrow] to fetch weather forecast,
/// in order to do so [ForecastController] with configuration is used. It also alows to refresh forecast tapping FAB.
///
/// At the bottom of the screen there is [StormyWeatherTile] that displays weather forecast for today predicted by [StormyPredictor]
/// it will also refresh when FAB is tapped.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Stormy Streamer Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double longitude = 4.884052;
  double latitude = 52.363231;
  WeatherForecast? todayForecast;

  late TextEditingController longitudeController;
  late TextEditingController latitudeController;

  /// Controller used to fetch forecast using Tomorrow API
  ForecastController tomorrowForecastController = ForecastController(
    configuration: const StormyConfiguration(
      //TODO replace with valid API key
      apiKey: 'API_KEY',
      units: Units.imperial,
      weatheApiService: WeatheApiService.tomorrow,
    ),
  );

  /// Predictor used to predict weather for today
  StormyPredictor predictor = StormyPredictor();

  @override
  void initState() {
    longitudeController = TextEditingController(text: longitude.toString());
    latitudeController = TextEditingController(text: latitude.toString());

    _refreshTodayForecast();

    super.initState();
  }

  Future<void> _refreshTodayForecast() async {
    final forecast = await predictor.singleDayForecast(latitude, longitude, DateTime.now());

    setState(() {
      todayForecast = forecast;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Stormy Streamer', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Input coordinates for weather forecast',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: longitudeController,
                onSubmitted: (value) {
                  setState(() {
                    longitude = double.parse(value);
                  });

                  _refreshTodayForecast();
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Longitude',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,6}'))],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: latitudeController,
                onSubmitted: (value) {
                  setState(() {
                    latitude = double.parse(value);
                  });

                  _refreshTodayForecast();
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Latitude',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,6}'))],
              ),
              const SizedBox(height: 16),
              Text(
                'Open meteo API',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              StormyForecastPanel(
                dateFrom: DateTime.now(),
                longitude: longitude,
                latitude: latitude,
              ),
              const SizedBox(height: 16),
              Text(
                'Tomorrow API',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              StormyForecastPanel(
                controller: tomorrowForecastController,
                dateFrom: DateTime.now(),
                longitude: longitude,
                latitude: latitude,
              ),
              if (todayForecast != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Predictor usage',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                StormyWeatherTile(forecast: todayForecast!),
              ]
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tomorrowForecastController.refresh();
          _refreshTodayForecast();
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    tomorrowForecastController.dispose();
    predictor.dispose();

    super.dispose();
  }
}
