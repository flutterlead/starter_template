
class StreamService<T> {
  bool _isClosed = false;

  Stream<T> getStream(
      Future<T> Function() future, {
        Duration duration = const Duration(seconds: 3),
      }) async* {
    if (!_isClosed) yield* _createStream(future, duration);
  }

  void cancel() => _isClosed = false;

  Stream<T> _createStream(Future<T> Function() future, Duration duration) async* {
    _isClosed = true;
    while (_isClosed) {
      try {
        yield await future();
      } catch (error) {
        rethrow;
      }
      await Future.delayed(duration);
    }
  }
}