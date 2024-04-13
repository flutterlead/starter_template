import 'package:flutter/material.dart';

class Resume {
  dynamic data;
  String? source;
}

abstract class ResumeState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  Resume resume = Resume();
  bool _isPaused = false;

  /// Implement your code here
  void onResume() {
    // TODO: Implement your code here
  }

  /// Implement your code here
  void onReady() {
    // TODO: Implement your code here
  }

  /// Implement your code here
  void onPause() {
    // TODO: Implement your code here
  }

  /// This method is replacement of Navigator.push(), but fires onResume() after route popped
  Future<U?> push<U extends Object?>(BuildContext context, Route<U> route,
      [String? source]) {
    _isPaused = true;
    onPause();
    return Navigator.of(context).push<U>(route).then((value) {
      _isPaused = false;
      resume.data = value;
      resume.source = source;
      onResume();
      return value;
    });
  }

  /// This method is replacement of Navigator.pushNamed(), but fires onResume() after route popped
  Future<U?> pushNamed<U extends Object?>(
      BuildContext context, String routeName,
      {Object? arguments}) {
    _isPaused = true;
    onPause();
    return Navigator.of(context)
        .pushNamed<U>(routeName, arguments: arguments)
        .then((value) {
      _isPaused = false;
      resume.data = value;
      resume.source = routeName;
      onResume();
      return value;
    });
  }

  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance).addObserver(this);
    _ambiguate(WidgetsBinding.instance).addPostFrameCallback((_) => onReady());
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance).removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isPaused) return;
    switch (state) {
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.resumed:
        onResume();
        break;
      default:
        break;
    }
  }

  U _ambiguate<U>(U value) => value;
}
