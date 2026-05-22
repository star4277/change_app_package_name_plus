library change_app_package_name;

import './android_rename_steps.dart';
import './ios_rename_steps.dart';
import 'ohos/ohos_rename_steps.dart';

class ChangeAppPackageName {
  static Future<void> start(List<String> arguments) async {
    if (arguments.isEmpty) {
      print('New package name is missing. Please provide a package name.');
      return;
    }

    if (arguments.length == 1) {
      // No platform-specific flag, rename both Android and iOS
      print('Renaming package for both Android,iOS and Ohos.');
      await _renameBoth(arguments[0]);
    } else if (arguments.length == 2) {
      // Check for platform-specific flags
      var platform = arguments[1].toLowerCase();
      if (platform == '--android') {
        print('Renaming package for Android only.');
        await AndroidRenameSteps(arguments[0]).process();
      } else if (platform == '--ios') {
        print('Renaming package for iOS only.');
        await IosRenameSteps(arguments[0]).process();
      } else if (platform == '--ohos') {
        print('Renaming package for ohos only.');
        await OhosRenameSteps(arguments[0]).process();
      } else {
        print('Invalid argument. Use "--android", "--ios" or "--ohos".');
      }
    } else {
      print(
          'Too many arguments. This package accepts only the new package name and an optional platform flag.');
    }
  }

  static Future<void> _renameBoth(String newPackageName) async {
    await AndroidRenameSteps(newPackageName).process();
    await IosRenameSteps(newPackageName).process();
    await OhosRenameSteps(newPackageName).process();
  }
}
