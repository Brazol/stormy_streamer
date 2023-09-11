# stormy_streamer

## Description

![logo](https://github.com/Brazol/stormy_streamer/assets/5622717/7d1ade60-709c-4d0b-aa12-e57eacb2cc58)

`stormy_streamer` Is a simple SDK package that gives the ability to search weather information for any location. It also contains simple weather forecast widget.

## Usage

Simple forecast widget using default Open Meteo API

```dart
StormyForecastPanel(
                dateFrom: DateTime.now(),
                longitude: longitude,
                latitude: latitude,
              ),
```

If you want to use Tomorrow API

```dart
ForecastController tomorrowForecastController = ForecastController(
    configuration: const StormyConfiguration(
      //TODO replace with valid API key
      apiKey: 'API_KEY',
      units: Units.metric,
      weatheApiService: WeatheApiService.tomorrow,
    ),
  );

StormyForecastPanel(
                dateFrom: DateTime.now(),
                longitude: longitude,
                latitude: latitude,
                controller: tomorrowForecastController,
              ),
```

If you want to just use access to API to get weather data

```dart
StormyPredictor predictor = StormyPredictor();
final forecast = await predictor.fiveDaysForecast(latitude, longitude, DateTime.now());
```
