import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:starter_template/injectable/injectable.dart';
import 'package:starter_template/services/firebase/firebase_push_helper.dart';
import 'package:starter_template/model/people_model/people.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:starter_template/services/web_service/api_service.dart';
import 'package:starter_template/services/web_service/cache_interceptor/cache_interceptor.dart';
import 'package:starter_template/utils/extension.dart';
import 'package:starter_template/widget/api_builder_widget.dart';

GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await configuration();
      //await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kDebugMode ? false : true);
      FlutterError.onError = (errorDetails) => FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      getIt<Dio>().interceptors.add(PrettyDioLogger(responseBody: false));
      getIt<Dio>().interceptors.add(DioCacheInterceptor(options: cacheOption));
      getIt<Dio>().interceptors.add(RetryInterceptor(dio: getIt<Dio>()));
      runApp(const Application());
    },
    (error, stackTrace) => FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true),
    zoneSpecification: ZoneSpecification(
      handleUncaughtError: (Zone zone, ZoneDelegate delegate, Zone parent, Object error, StackTrace stackTrace) => FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true),
    ),
  );
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starter Template',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator,
      onGenerateTitle: (context) => context.localization.title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyHomePage(title: 'Starter Template'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrofit Example"),
      ),
      body: ApiBuilderWidget<List<PeopleModel>>(
        key: peopleKey,
        future: getIt<RestClient>().getPeoples(),
        onConnectionRestored: () => peopleKey.refresh(getIt<RestClient>().getPeoples()),
        onCompleted: (snapshot) {
          return RefreshIndicator(
            onRefresh: () async => peopleKey.refresh(getIt<RestClient>().getPeoples()),
            child: ListView(children: (snapshot as List<PeopleModel>).map<Widget>(peopleWidget).toList()),
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
        ),
      ),
      title: Text(model.name.toString()),
      subtitle: Text(model.createdAt.toString()),
    );
  }
}
