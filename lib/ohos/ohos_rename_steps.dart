import 'dart:io';

import '../file_utils.dart';
import 'ohos_app_config.dart';

class OhosRenameSteps {
  final String newPackageName;
  String? oldPackageName;
  static const String PATH_PROJECT_FILE = 'ohos/AppScope/app.json5';

  OhosRenameSteps(this.newPackageName);

  Future<void> process() async {
    print("Running for Ohos");
    if (!File(PATH_PROJECT_FILE).existsSync()) {
      print(
          'ERROR:: app.json5 file not found, Check if you have a correct ohos directory present in your project'
          '\n\nrun " flutter create . " to regenerate missing files.');
      return;
    }
    String? json = await readFileAsString(PATH_PROJECT_FILE);
    OhosApp ohosAppConfig = ohosAppFromJson(json!);
    oldPackageName = ohosAppConfig.app.bundleName;
    print("Old Package Name: $oldPackageName");

    print('Updating app.json5 File');
    await _replace(ohosAppConfig, PATH_PROJECT_FILE);
    print('Finished updating Ohos bundle identifier');
  }

  Future<void> _replace(OhosApp app, String path) async {
    app.app.bundleName = newPackageName;
    final json = ohosAppToJson(app, pretty: true);
    await writeFileFromString(path, json);
  }
}
