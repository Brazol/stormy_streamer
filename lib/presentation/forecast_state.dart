import 'package:stormy_streamer/predictor/stormy_domain.dart';

sealed class ForecastState {
  const ForecastState();
}

class LoadingForecastState extends ForecastState {
  const LoadingForecastState();
}

class ErrorForecastState extends ForecastState {
  final String message;
  const ErrorForecastState(this.message);
}

class SuccessForecastState extends ForecastState {
  final List<WeatherForecast> forecast;
  const SuccessForecastState(this.forecast);
}
