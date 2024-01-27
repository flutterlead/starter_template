import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:starter_template/firebase_options.dart';
import 'package:starter_template/model/people_model/people.dart';
import 'package:starter_template/services/firebase/firebase_push_helper.dart';
import 'package:starter_template/services/web_service/api_service.dart';
import 'package:starter_template/services/web_service/http_interceptor/http_interceptor.dart';
import 'package:starter_template/utils/extension.dart';
import 'package:get_it/get_it.dart';

GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

Future<void> initializing() async {
  final dio = Dio();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) dio.interceptors.add(LoggingInterceptor());
  GetIt.instance.registerSingleton<RestClient>(RestClient(dio));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializing();
  runApp(const Application());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrofit Example"),
      ),
      body: FutureBuilder<List<PeopleModel>>(
        future: GetIt.instance.get<RestClient>().getUsers(),
        builder: (context, AsyncSnapshot<List<PeopleModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final people = snapshot.data!;
            return ListView(children: people.map(peopleWidget).toList());
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget peopleWidget(PeopleModel model) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.network(
          'https://pub.dev/packages/retrofit',
          height: 30,
          width: 30,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ),
      title: Text(model.name.toString()),
      subtitle: Text(model.createdAt.toString()),
    );
  }
}
