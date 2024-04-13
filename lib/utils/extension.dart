import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:starter_template/widget/api_builder_widget.dart';

extension Localization on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;
}

extension Refresh on GlobalKey<ApiBuilderWidgetState> {
  void refresh<T>(Future<T> value) => currentState?.refresh(value);
}
