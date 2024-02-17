import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
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

  String get baseUrl => 'https://61028c7079ed68001748216c.mockapi.io/';

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<Directory> get temporaryDirectory => getTemporaryDirectory();

  @preResolve
  Future<FirebaseApp> initializeFireBase() => Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
