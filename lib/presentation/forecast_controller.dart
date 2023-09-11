import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stormy_streamer/predictor/stormy_configuration.dart';
import 'package:stormy_streamer/predictor/stormy_predictor.dart';
import 'package:stormy_streamer/presentation/forecast_state.dart';

/// Controller for the [StormyForecastPanel]
class ForecastController {
  final StormyPredictor _predictor;
  final BehaviorSubject<ForecastState> _state = BehaviorSubject<ForecastState>.seeded(const LoadingForecastState());

  late DateTime _from;
  late double _longitude;
  late double _latitude;

  Stream<ForecastState> get stateStream => _state.stream;

  ForecastController({StormyConfiguration configuration = const StormyConfiguration()})
      : _predictor = StormyPredictor(configuration: configuration);

  ForecastController.withPredictor(StormyPredictor predictor) : _predictor = predictor;

  /// Refreshes the forecast
  Future<void> refresh() async {
    _state.sink.add(const LoadingForecastState());

    try {
      final forecast = await _predictor.fiveDaysForecast(_latitude, _longitude, _from);
      _state.sink.add(SuccessForecastState(forecast));
    } catch (e) {
      debugPrint(e.toString());
      _state.sink.add(ErrorForecastState(e.toString()));
    }
  }

  setFrom(DateTime from) {
    _from = from;
  }

  setLongitude(double longitude) {
    _longitude = longitude;
  }

  setLatitude(double latitude) {
    _latitude = latitude;
  }

  void dispose() {
    _state.close();
    _predictor.dispose();
  }
}
