import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_template/firebase_options.dart';
import 'package:starter_template/injectable/injectable.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configuration() async {
  await getIt.init();
}

@module
abstract class RegisterModule {
  @singleton
  Dio get dio => Dio();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<FirebaseApp> initializeFireBase() => Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
