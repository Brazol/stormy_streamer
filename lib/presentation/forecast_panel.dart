import 'package:flutter/material.dart';
import 'package:stormy_streamer/extensions.dart';
import 'package:stormy_streamer/presentation/forecast_controller.dart';
import 'package:stormy_streamer/presentation/forecast_state.dart';
import 'package:stormy_streamer/presentation/weather_tile.dart';

/// Widget that displays a forecast 5 days starting from [dateFrom] for the given location ([longitude], [latitude]).
class StormyForecastPanel extends StatefulWidget {
  /// Controller for the [StormyForecastPanel]
  /// Holds configuration for the weather api and exposes a [refresh] method to refresh the forecast.
  final ForecastController? controller;

  final DateTime dateFrom;
  final double longitude;
  final double latitude;

  const StormyForecastPanel({
    required this.dateFrom,
    required this.longitude,
    required this.latitude,
    this.controller,
    super.key,
  });

  @override
  State<StormyForecastPanel> createState() => _StormyForecastPanelState();
}

class _StormyForecastPanelState extends State<StormyForecastPanel> {
  late ForecastController controller;

  @override
  void initState() {
    controller = widget.controller ?? ForecastController();
    _initController();

    controller.refresh();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StormyForecastPanel oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.dispose();
      controller = widget.controller ?? ForecastController();
    }

    if (widget.controller != oldWidget.controller ||
        widget.dateFrom.startOfDay != oldWidget.dateFrom.startOfDay ||
        widget.longitude != oldWidget.longitude ||
        widget.latitude != oldWidget.latitude) {
      _initController();
      controller.refresh();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _initController() {
    controller.setFrom(widget.dateFrom);
    controller.setLongitude(widget.longitude);
    controller.setLatitude(widget.latitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: StreamBuilder(
        stream: controller.stateStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator();
          }

          return switch (snapshot.data!) {
            LoadingForecastState() => const CircularProgressIndicator(),
            ErrorForecastState() => _ForecastErrorPanel(
                onRefresh: () => controller.refresh(),
              ),
            SuccessForecastState(forecast: final forecast) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...forecast.map(
                      (forecast) => StormyWeatherTile(
                        forecast: forecast,
                      ),
                    ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _ForecastErrorPanel extends StatelessWidget {
  final VoidCallback onRefresh;

  const _ForecastErrorPanel({
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.red[100],
      ),
      child: Column(
        children: [
          const Text(
            'Oops, our weather data got lost in the clouds. Please try again!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          )
        ],
      ),
    );
  }
}
