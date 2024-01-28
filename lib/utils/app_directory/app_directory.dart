import 'package:injectable/injectable.dart' as i;
import 'dart:io';

abstract class DefaultPath {
  Directory getTemporaryDirectory();
}

@i.lazySingleton
@i.injectable
class AppDirectory implements DefaultPath {
  final Directory temporaryDirectory;

  AppDirectory({required this.temporaryDirectory});

  @override
  Directory getTemporaryDirectory() => temporaryDirectory;
}
