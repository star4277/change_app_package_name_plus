import 'dart:async';
import 'dart:io';

import './file_utils.dart';

class AndroidRenameSteps {
  final String newPackageName;
  String? oldPackageName;

  static const String PATH_BUILD_GRADLE = 'android/app/build.gradle';
  static const String PATH_MANIFEST = 'android/app/src/main/AndroidManifest.xml';
  static const String PATH_MANIFEST_DEBUG = 'android/app/src/debug/AndroidManifest.xml';
  static const String PATH_MANIFEST_PROFILE = 'android/app/src/profile/AndroidManifest.xml';

  static const String PATH_ACTIVITY = 'android/app/src/main/';

  AndroidRenameSteps(this.newPackageName);

  Future<void> process() async {
    print("Running for android");
    var gradleFile = PATH_BUILD_GRADLE;
    if(!await File(gradleFile).exists()) {
      gradleFile = "$gradleFile.kts";
    }
    if (!await File(gradleFile).exists()) {
      print('ERROR:: build.gradle file not found, Check if you have a correct android directory present in your project'
          '\n\nrun " flutter create . " to regenerate missing files.');
      return;
    }
    String? contents = await readFileAsString(gradleFile);

    var reg = RegExp(r'applicationId\s*=?\s*"(.*)"', caseSensitive: true, multiLine: false);
    var match = reg.firstMatch(contents!);
    if(match == null) {
      print('ERROR:: applicationId not found in build.gradle file, Please file an issue on github with $gradleFile file attached.');
      return;
    }
    var name = match.group(1);
    oldPackageName = name;

    print("Old Package Name: $oldPackageName");

    print('Updating build.gradle File');
    await _replace(gradleFile);

    var mText = 'package="$newPackageName">';
    var mRegex = '(package=.*)';

    print('Updating Main Manifest file');
    await replaceInFileRegex(PATH_MANIFEST, mRegex, mText);

    print('Updating Debug Manifest file');
    await replaceInFileRegex(PATH_MANIFEST_DEBUG, mRegex, mText);

    print('Updating Profile Manifest file');
    await replaceInFileRegex(PATH_MANIFEST_PROFILE, mRegex, mText);

    await updateMainActivity();
    print('Finished updating android package name');
  }

  Future<void> updateMainActivity() async {
    await _migrateSourceFiles(type: 'java');
    await _migrateSourceFiles(type: 'kotlin');
  }

  Future<void> _migrateSourceFiles({required String type}) async {
    final rootPath = '$PATH_ACTIVITY$type';
    final rootDir = Directory(rootPath);
    if (!await rootDir.exists()) {
      print('No $type source directory found, skipping.');
      return;
    }

    final files = await dirContents(rootDir);
    final extension = type == 'java' ? '.java' : '.kt';
    final oldPackagePath = oldPackageName!.replaceAll('.', '/');
    final newPackagePath = newPackageName.replaceAll('.', '/');
    final oldPackageMarker = '/$oldPackagePath/';

    final sourceFiles = files
        .whereType<File>()
        .where((item) => _normalizePath(item.path).endsWith(extension))
        .toList();

    final filesToMove = sourceFiles
        .where((item) => _normalizePath(item.path).contains(oldPackageMarker))
        .toList();

    if (filesToMove.isEmpty) {
      print('No $type files found under old package path, skipping.');
      return;
    }

    print('Project is using $type');
    print('Migrating ${filesToMove.length} $extension files');

    for (final file in filesToMove) {
      await replaceInFile(file.path, oldPackageName, newPackageName);

      final sourcePath = _normalizePath(file.path);
      final markerIndex = sourcePath.indexOf(oldPackageMarker);
      if (markerIndex == -1) {
        continue;
      }

      final relativePath = sourcePath.substring(markerIndex + oldPackageMarker.length);
      final newFilePath = '${PATH_ACTIVITY}${type}/$newPackagePath/$relativePath';
      final newParentPath = newFilePath.substring(0, newFilePath.lastIndexOf('/'));

      await Directory(newParentPath).create(recursive: true);

      final targetFile = File(newFilePath);
      if (await targetFile.exists()) {
        await targetFile.delete();
      }

      await file.rename(newFilePath);
    }

    print('Deleting old directories');
    await deleteEmptyDirs(type);
  }

  Future<void> _replace(String path) async {
    await replaceInFile(path, oldPackageName, newPackageName);
  }

  Future<void> deleteEmptyDirs(String type) async {
    var dirs = await dirContents(Directory(PATH_ACTIVITY + type));
    dirs = dirs.reversed.toList();
    for (var dir in dirs) {
      if (dir is Directory) {
        if (dir.listSync().toList().isEmpty) {
          dir.deleteSync();
        }
      }
    }
  }

  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    if(!dir.existsSync()) return Future.value([]);
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: true);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }

  String _normalizePath(String path) {
    return path.replaceAll('\\', '/');
  }
}
