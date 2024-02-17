import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:starter_template/injectable/injectable.dart';
import 'package:starter_template/model/beer_model/beer.dart';
import 'package:starter_template/model/people_model/people.dart';
import 'package:starter_template/route_confing/route_config.dart';
import 'package:starter_template/services/firebase/firebase_push_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:starter_template/services/web_service/api_service.dart';
import 'package:starter_template/services/web_service/cache_interceptor/cache_interceptor.dart';
import 'package:starter_template/utils/extension.dart';
import 'package:starter_template/utils/localization_manager/localization_manager.dart';
import 'package:starter_template/widget/api_builder_widget.dart';
import 'package:starter_template/widget/theme_selection_widget.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await configuration();
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kDebugMode ? false : true);
      FlutterError.onError = (errorDetails) => FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      getIt<Dio>().interceptors.add(PrettyDioLogger(responseBody: false));
      getIt<Dio>().interceptors.add(DioCacheInterceptor(options: cacheOption));
      getIt<Dio>().interceptors.add(RetryInterceptor(dio: getIt<Dio>()));
      final themeMode = await AdaptiveTheme.getThemeMode();
      runApp(Application(mode: themeMode));
    },
    (error, stackTrace) => FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true),
    zoneSpecification: ZoneSpecification(
      handleUncaughtError: (Zone zone, ZoneDelegate delegate, Zone parent, Object error, StackTrace stackTrace) => FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true),
    ),
  );
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
        ),
        dark: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrofit Example"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
            },
            icon: const Icon(Icons.settings),
          )
        ],
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




class PaginationExample extends StatefulWidget {
  const PaginationExample({super.key});

  @override
  State<PaginationExample> createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  final _pagingController = PagingController<int, BeerSummary>(firstPageKey: 1);
  int limit = 20;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getIt<RestClient>().getBeer(pageKey, limit);
      final isLastPage = newItems.length < limit;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination Example'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, BeerSummary>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<BeerSummary>(
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: Text('No item found'),
            ),
            itemBuilder: (context, item, index) => beerListItem(item),
            firstPageProgressIndicatorBuilder: (context) => const CupertinoActivityIndicator(),
            newPageProgressIndicatorBuilder: (context) => Container(
              margin: const EdgeInsets.all(16.0),
              child: const CupertinoActivityIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  Widget beerListItem(BeerSummary beer) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(10.0),
          color: Theme.of(context).primaryColor,
          child: Image.network(
            beer.imageUrl.toString(),
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        ),
      ),
      title: Text(beer.name.toString()),
      subtitle: Text(beer.description.toString()),
    );
  }
}