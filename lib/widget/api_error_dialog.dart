import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:starter_template/services/exception/exception.dart';

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({
    super.key,
    required this.userFriendlyError,
    required this.onConnectionRestored,
  });

  final UserFriendlyError userFriendlyError;
  final void Function() onConnectionRestored;

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  Connectivity? connectivity;

  @override
  void initState() {
    connectivity = Connectivity();
    listenForConnectivityChange();
    super.initState();
  }

  void listenForConnectivityChange() {
    connectivity?.onConnectivityChanged.listen((event) {
      if (!event.contains(ConnectivityResult.none)) widget.onConnectionRestored();
    });
  }

  @override
  void dispose() {
    connectivity = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        width: 300,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 70),
              const SizedBox(height: 20),
              Text(
                widget.userFriendlyError.title,
                style: TextStyles.errorTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                widget.userFriendlyError.description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextStyles {
  static const userId = TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontSize: 26,
  );

  static const postTitle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    letterSpacing: 0.0,
  );

  static const id = TextStyle(
    color: Colors.black38,
    fontSize: 16,
  );

  static const errorTitle = TextStyle(fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: 0.0, color: Colors.red);
}
