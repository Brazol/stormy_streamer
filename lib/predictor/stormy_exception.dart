library stormy_streamer;

class StormyException implements Exception {
  final String _cause;

  StormyException(this._cause);

  @override
  String toString() => '$runtimeType - $_cause';
}
