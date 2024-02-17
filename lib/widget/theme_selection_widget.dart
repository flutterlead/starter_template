import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:starter_template/utils/extension.dart';

class ThemeSelectionWidget extends StatelessWidget {
  const ThemeSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioListTile(
            title: Text(context.localization.darkMode),
            value: 'Dark',
            groupValue: value.modeName,
            onChanged: (value) => _updateTheme(value, context),
          ),
          RadioListTile(
            title: Text(context.localization.lightMode),
            value: 'Light',
            groupValue: value.modeName,
            onChanged: (value) => _updateTheme(value, context),
          ),
          RadioListTile<String>(
            title: Text(context.localization.systemMode),
            value: 'System',
            groupValue: value.modeName,
            onChanged: (value) => _updateTheme(value, context),
          ),
        ],
      ),
    );
  }

  void _updateTheme(String? value, BuildContext context) {
    if (value == 'Dark') {
      AdaptiveTheme.of(context).setDark();
    } else if (value == 'Light') {
      AdaptiveTheme.of(context).setLight();
    } else {
      AdaptiveTheme.of(context).setSystem();
    }
  }
}
