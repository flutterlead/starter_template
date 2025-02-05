// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i4;

import 'package:dio/dio.dart' as _i8;
import 'package:firebase_core/firebase_core.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;
import 'package:starter_template/injectable/injectable.dart' as _i12;
import 'package:starter_template/services/web_service/api_service.dart' as _i11;
import 'package:starter_template/utils/app_directory/app_directory.dart' as _i9;
import 'package:starter_template/utils/shared_pref/shared_pref.dart' as _i10;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<String>(() => registerModule.baseUrl);
    await gh.factoryAsync<_i3.SharedPreferences>(
      () => registerModule.prefs(),
      preResolve: true,
    );
    await gh.factoryAsync<_i4.Directory>(
      () => registerModule.temporaryDirectory(),
      preResolve: true,
    );
    await gh.factoryAsync<_i7.FirebaseApp>(
      () => registerModule.initializeFireBase(),
      preResolve: true,
    );
    gh.singleton<_i8.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i9.AppDirectory>(
        () => _i9.AppDirectory(temporaryDirectory: gh<_i4.Directory>()));
    gh.lazySingleton<_i10.SharedPrefService>(
        () => _i10.SharedPrefService(pref: gh<_i3.SharedPreferences>()));
    gh.lazySingleton<_i11.RestClient>(() => _i11.RestClient(
          gh<_i8.Dio>(),
          baseUrl: gh<String>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i12.RegisterModule {}
