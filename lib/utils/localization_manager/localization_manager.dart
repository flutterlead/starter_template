import 'package:flutter/material.dart';
import 'package:starter_template/injectable/injectable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:starter_template/utils/shared_pref/shared_pref.dart';

/// Builder function to build localized widgets
typedef LocalizationBuilder = Widget Function(Locale locale);

/// Widget that allows switching app localization dynamically.
/// Example:
///
/// LocalizationManager(
///   initialLocale: Locale('en'),
///   builder: (locale) => MaterialApp(
///     locale: locale,
///     supportedLocales: [
///       Locale('en', ''),
///       Locale('es', ''),
///       // Add more supported locales as needed
///     ],
///     localizationsDelegates: [
///       // Add your localization delegates
///       // For example, GlobalMaterialLocalizations.delegate,
///       // GlobalWidgetsLocalizations.delegate,
///       // GlobalCupertinoLocalizations.delegate,
///     ],
///     home: MyHomePage(),
///   ),
/// );
class LocalizationManager extends StatefulWidget {
  /// Indicates which locale to use initially.
  final Locale initialLocale;

  /// Provides a builder with access to the current locale. Intended to
  /// be used to return [MaterialApp].
  final LocalizationBuilder builder;

  /// Primary constructor which allows configuring the initial locale.
  const LocalizationManager({
    super.key,
    required this.initialLocale,
    required this.builder,
  });

  @override
  State<LocalizationManager> createState() => LocalizationManagerState();

  /// Returns the current [LocalizationManagerState] using the context.
  static LocalizationManagerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<LocalizationManagerState>();
    if (state == null) {
      throw Exception('LocalizationManagerState not found in the widget tree.');
    }
    return state;
  }
}

class LocalizationManagerState extends State<LocalizationManager> {
  late ValueNotifier<Locale> _currentLocale;

  @override
  void initState() {
    super.initState();
    _assignNewLocaleIfAvailable();
    _saveLocaleIfNotSaved();
  }

  void _assignNewLocaleIfAvailable() {
    final savedLocale = getIt<SharedPrefService>().getLocale('NEW_LOCALE');
    if (savedLocale != null) {
      final locale = Locale(savedLocale);
      _currentLocale = ValueNotifier<Locale>(locale);
      return;
    }
    _currentLocale = ValueNotifier<Locale>(widget.initialLocale);
  }

  void _saveNewLocaleIfNotSaved(Locale newLocale) {
    getIt<SharedPrefService>()
        .saveLocale('NEW_LOCALE', newLocale.toLanguageTag());
  }

  void _saveLocaleIfNotSaved() {
    if (getIt<SharedPrefService>().getLocale('CURRENT_LOCALE') != null) return;
    getIt<SharedPrefService>()
        .saveLocale('CURRENT_LOCALE', _currentLocale.value.toLanguageTag());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _currentLocale,
      builder: (context, value, child) => widget.builder(value),
    );
  }

  /// Method to change the current locale.
  void setLocale(Locale newLocale) {
    if (_currentLocale.value != newLocale) {
      _currentLocale.value = newLocale;
      _saveNewLocaleIfNotSaved(newLocale);
    }
  }

  void resetLocale() {
    final locale = getIt<SharedPrefService>().getLocale('CURRENT_LOCALE');
    if (locale == null) return;
    _currentLocale.value = Locale(locale);
  }

  @override
  void dispose() {
    _currentLocale.dispose();
    super.dispose();
  }

  ValueNotifier<Locale> get currentLocale => _currentLocale;
}

class LanguageSelectionWidget extends StatelessWidget {
  const LanguageSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LocalizationManager.of(context).currentLocale,
      builder: (context, value, child) => SingleChildScrollView(
        child: Column(
          children: AppLocalizations.supportedLocales
              .map((e) => RadioListTile(
                    title: Text(e.languageCode),
                    value: e.languageCode,
                    groupValue: value.languageCode,
                    onChanged: (value) => LocalizationManager.of(context)
                        .setLocale(Locale(value.toString())),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
