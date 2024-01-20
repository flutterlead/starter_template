import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:starter_template/firebase_options.dart';
import 'package:starter_template/services/firebase/firebase_push_helper.dart';
import 'package:starter_template/utils/extension.dart';

GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

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
    notification.initPushConfiguration(
      (value) => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ScreenB(),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            final notification = FirebasePushHelper.instance;
            notification.saveToken();
          },
          child: const Text('TOKEN'),
        ),
      ),
    );
  }
}

Future<void> initializing() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class ScreenB extends StatefulWidget {
  const ScreenB({super.key});

  @override
  State<ScreenB> createState() => _ScreenBState();
}

class _ScreenBState extends State<ScreenB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen B'),
      ),
    );
  }
}
