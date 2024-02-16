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