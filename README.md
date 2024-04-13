--------------------------------------------------------
# Do this before you start

Editor -> Code style -> Dart set line length to 200

--------------------------------------------------------
# Features

  Supports AppLocalization / Internationalization (i18n) out of the box.
  Supports FirebaseMessaging Notifications out of the box.
  Supports dio Interceptors.
  Supports FireBase Crashlytics.
  Supports Lifecycles with (onResume , onPause , onReady).
  Supports reCase word.
  Supports Sqflite database(check out here lib/utils/data_base).
  Supports SharedPref (check out here lib/utils/shared_pref).
  Supports Debounce timer widget.
  Support for Shimmer Effect.
  Support to convert future to stream. 
  Supports Github actions.

--------------------------------------------------------
# To Generate With Build Runner use this command you can use any of the following commands
# For more info and see https://pub.dev/packages/retrofit and https://pub.dev/packages/build_runner

  flutter pub run build_runner build --delete-conflicting-outputs
  flutter pub run build_runner watch --delete-conflicting-outputs
  
  dart run build_runner build --delete-conflicting-outputs
  dart run build_runner watch --delete-conflicting-outputs

--------------------------------------------------------
# Remote Notification (Firebase only)

  final notification = FirebasePushHelper.instance;
  notification.initPushConfiguration((value) {});

 in the initPushConfiguration you will get the notification data when you
 tap on notification and app open.

--------------------------------------------------------
# Interceptors for dio usage

  getIt<Dio>().interceptors.add(PrettyDioLogger(responseBody: false));
  getIt<Dio>().interceptors.add(DioCacheInterceptor(options: cacheOption));
  getIt<Dio>().interceptors.add(RetryInterceptor(dio: getIt<Dio>()));

--------------------------------------------------------
# Custom Widget

**ApiBuilderWidget() Same as FutureBuilder But With Enhanced Version.**

(E.G)


final peopleKey = GlobalKey<ApiBuilderWidgetState>();

ApiBuilderWidget<List<PeopleModel>>(
  key: peopleKey,
  future: getIt<RestClient>().getPeoples(),
  onConnectionRestored: () => peopleKey.refresh(getIt<RestClient>().getPeoples()),
  onCompleted: (snapshot) {
    return RefreshIndicator(
      onRefresh: () async => peopleKey.refresh(getIt<RestClient>().getPeoples()),
      child: ListView(children: (snapshot as List<PeopleModel>).map<Widget>(peopleWidget).toList()),
    );
  },
)

--------------------------------------------------------
# Supports App Localization

  To use your own localized language please make an .arb file
  as shown here (lib/l10n/app_en.arb) with your own language like (hi.arb)
  
  To access the localized version use this
  (context.localization.title) //title is the key

  Add this lines to material app

  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,

--------------------------------------------------------
# Supports Lifecycles with (onResume , onPause , onReady)

  To use lifecycle you have to extend your stateful widget with 
  ResumeState<YourWidget Name>

class MyHomePage extends StatefulWidget {
   const MyHomePage({super.key});

   @override
   State<MyHomePage> createState() => _MyHomePageState();
   }

class _MyHomePageState extends ResumeState<MyHomePage> {
   @override
   void onReady() {
      // TODO: implement onReady
      super.onReady();
   }
   
   @override
   void onPause() {
      // TODO: implement onPause
      super.onPause();
   }
   
   @override
   void onResume() {
      // TODO: implement onResume
      super.onResume();
   }

   @override
   Widget build(BuildContext context) => const SizedBox();
}

--------------------------------------------------------
# Supports reCase word

  String get camelCase => ReCase(this).camelCase;

  String get constantCase => ReCase(this).constantCase;

  String get sentenceCase => ReCase(this).sentenceCase;

  String get snakeCase => ReCase(this).snakeCase;

  String get dotCase => ReCase(this).dotCase;

  String get paramCase => ReCase(this).paramCase;

  String get pathCase => ReCase(this).pathCase;

  String get pascalCase => ReCase(this).pascalCase;

  String get headerCase => ReCase(this).headerCase;

  String get titleCase => ReCase(this).titleCase;

--------------------------------------------------------
# Supports Debounce timer widget.
 
  You can find it here (lib/widget/debounce_builder.dart)
  also you can change it's ui based on your requirement.
--------------------------------------------------------
# Supports Pagination Out of the box

  import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
  
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

--------------------------------------------------------
# Supports Theme Out of the box
  
  you can just use ThemeSelectionWidget() to change the theme of the app
  Which is located here (lib/widget/theme_selection_widget.dart)
  
--------------------------------------------------------
# Supports AppLocalization / Internationalization (i18n) out of the box.

  To use your own localized language please make an .arb file
  Predefined Widget is located here (lib/widget/language_selection_widget.dart)
  LanguageSelectionWidget() to change the language of the app
  
--------------------------------------------------------
# Supports future to stream

  You can find it here (lib/utils/stream_service/stream_service.dart)
  To use it you can use this code.
  
  final streamService = StreamService();
  final stream = streamService.futureToStream({--FUTURE-METHOD-HERE});
  streamService.cancel();

--------------------------------------------------------
# Supports Github actions

  You can find it here (.github/workflows/flutter_build.yml)

--------------------------------------------------------