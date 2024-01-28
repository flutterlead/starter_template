import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:starter_template/services/exception/exception.dart';
import 'package:starter_template/widget/api_error_dialog.dart';
import 'package:starter_template/widget/generic_builder.dart';

class ApiBuilderWidget<T> extends StatefulWidget {
  const ApiBuilderWidget({
    super.key,
    required this.future,
    required this.onCompleted, required this.onConnectionRestored,
  });

  final Future<T> future;
  final Widget Function(dynamic snapshot) onCompleted;
  final void Function() onConnectionRestored;

  @override
  State<ApiBuilderWidget> createState() => ApiBuilderWidgetState();
}

class ApiBuilderWidgetState<T> extends State<ApiBuilderWidget> {
  Future<T>? future;

  @override
  void initState() {
    super.initState();
    future = widget.future as Future<T>;
  }

  void refresh(Future<T> value) {
    future = value;
    setState(() {});
  }

  @override
  void dispose() {
    future = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericBuilder<T>(
      future: future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          if (error is DioException) {
            return Center(
              child: ErrorDialog(
                onConnectionRestored: widget.onConnectionRestored,
                userFriendlyError: error.type.toUserFriendlyError(),
              ),
            );
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const SizedBox.shrink();
          } else {
            final data = snapshot.data as dynamic;
            return Builder(builder: (context) => widget.onCompleted(data));
          }
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
