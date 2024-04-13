import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DebounceBuilder extends StatefulWidget {
  const DebounceBuilder({
    super.key,
    this.onChanged,
    this.debounceTime,
  });

  final ValueChanged<String>? onChanged;
  final Duration? debounceTime;

  @override
  State<DebounceBuilder> createState() => _DebounceBuilderState();
}

class _DebounceBuilderState extends State<DebounceBuilder> {
  final StreamController<String> _textChangeStreamController =
      StreamController();
  late StreamSubscription _textChangesSubscription;

  @override
  void initState() {
    final duration = widget.debounceTime ?? const Duration(seconds: 1);
    _textChangesSubscription = _textChangeStreamController.stream
        .debounceTime(duration)
        .distinct()
        .listen(
      (text) {
        final onChanged = widget.onChanged;
        if (onChanged != null) onChanged(text);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          labelText: 'Search',
        ),
        onChanged: _textChangeStreamController.add,
      ),
    );
  }

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }
}
