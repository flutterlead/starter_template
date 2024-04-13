import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_template/injectable/injectable.dart';
import 'package:starter_template/model/people_model/people.dart';
import 'package:starter_template/route_config/route_config.dart';
import 'package:starter_template/services/firebase/firebase_push_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:starter_template/services/web_service/api_service.dart';
import 'package:starter_template/utils/custom_theme_color/custom_theme_color.dart';
import 'package:starter_template/utils/extension.dart';
import 'package:starter_template/utils/localization_manager/localization_manager.dart';
import 'package:starter_template/utils/shimmer/shimmer.dart';
import 'package:starter_template/widget/api_builder_widget.dart';
import 'package:starter_template/widget/theme_selection_widget.dart';

Future<void> main() async {
  await configuration(runApp: () async {
    final themeMode = await AdaptiveTheme.getThemeMode();
    runApp(Application(mode: themeMode));
  });
}

class Application extends StatelessWidget {
  const Application({super.key, required this.mode});

  final AdaptiveThemeMode? mode;

  @override
  Widget build(BuildContext context) {
    return LocalizationManager(
      initialLocale: const Locale('en'),
      builder: (locale) => AdaptiveTheme(
        light: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
          extensions: <ThemeExtension<dynamic>>[
            CustomThemeColor(
              shimmerBaseColor: Colors.grey.shade300,
              shimmerHighlightColor: Colors.grey.shade100,
            ),
          ],
        ),
        dark: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
          extensions: <ThemeExtension<dynamic>>[
            CustomThemeColor(
              shimmerBaseColor: Colors.grey.shade800,
              shimmerHighlightColor: Colors.grey.shade600,
            ),
          ],
        ),
        initial: mode ?? AdaptiveThemeMode.system,
        builder: (light, dark) => MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          onGenerateTitle: (context) => context.localization.title,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    final notification = FirebasePushHelper.instance;
    notification.initPushConfiguration((value) {});
  }

  final peopleKey = GlobalKey<ApiBuilderWidgetState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrofit Example"),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push('/setting'),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () => GoRouter.of(context).push('/pagination'),
            icon: const Icon(Icons.pages_sharp),
          ),
        ],
      ),
      body: ApiBuilderWidget<List<PeopleModel>>(
        key: peopleKey,
        future: getIt<RestClient>().getPeoples(),
        loadingWidget: ListView(
            children: List.generate(20, (index) => index)
                .map<Widget>((e) => shimmerTileWidget(context))
                .toList()),
        onConnectionRestored: () =>
            peopleKey.refresh(getIt<RestClient>().getPeoples()),
        onCompleted: (snapshot) {
          return RefreshIndicator(
            onRefresh: () async =>
                peopleKey.refresh(getIt<RestClient>().getPeoples()),
            child: ListView(
                children: (snapshot as List<PeopleModel>)
                    .map<Widget>(peopleWidget)
                    .toList()),
          );
        },
      ),
    );
  }

  Widget peopleWidget(PeopleModel model) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.network(
          model.avatar.toString(),
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          height: 50,
        ),
      ),
      title: Text(model.name.toString()),
      subtitle: Text(model.createdAt.toString()),
    );
  }

  Widget shimmerTileWidget(BuildContext context) {
    final myColors = Theme.of(context).extension<CustomThemeColor>()!;
    return Shimmer.fromColors(
      baseColor: myColors.shimmerBaseColor,
      highlightColor: myColors.shimmerHighlightColor,
      enabled: true,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            width: 50,
            height: 50,
            color: Colors.white,
          ),
        ),
        title: Container(
          height: 12.0,
          margin: EdgeInsets.only(right: context.width / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(right: context.width / 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          height: 12.0,
        ),
      ),
    );
  }
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.settings),
      ),
      body: Column(
        children: [
          ListTile(title: Text(context.localization.changeLanguage)),
          const LanguageSelectionWidget(),
          ListTile(title: Text(context.localization.changeTheme)),
          const ThemeSelectionWidget(),
        ],
      ),
    );
  }
}
