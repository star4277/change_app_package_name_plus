# change_app_package_name_plus

[中文文档](./README.zh.md)

Change app package/bundle name for Flutter projects with one command.

## Features

- Update Android `applicationId` (`build.gradle` / `build.gradle.kts`).
- Update Android manifest package declarations (`main`, `debug`, `profile`).
- Migrate Android source files under old package path to new package path.
- Update Java/Kotlin package references during migration.
- Remove empty old package directories after migration.
- Update iOS bundle identifier in `project.pbxproj`.
- Update OHOS bundle name in `ohos/AppScope/app.json5`.
- Rename all platforms at once, or one platform at a time.

## Install

Add this package to `dev_dependencies`:

```yaml
dev_dependencies:
  change_app_package_name_plus: ^1.5.0
```

Or:

```bash
flutter pub add -d change_app_package_name_plus
```

Then:

```bash
flutter pub get
```

## Usage

Rename Android + iOS + OHOS:

```bash
dart run change_app_package_name_plus:main com.new.package.name
```

Rename Android only:

```bash
dart run change_app_package_name_plus:main com.new.package.name --android
```

Rename iOS only:

```bash
dart run change_app_package_name_plus:main com.new.package.name --ios
```

Rename OHOS only:

```bash
dart run change_app_package_name_plus:main com.new.package.name --ohos
```

## Notes

- If you have customized `CFBundleIdentifier` in `Info.plist`, update it manually.
- `com.new.package.name` is an example. Replace it with your own package name.

## Thanks

This project is based on and inspired by the original project:

- Original project: <https://github.com/atiqsamtia/change_app_package_name>
- Original author: Atiq Samtia (<https://twitter.com/atiqsamtia>)

Thanks for the original implementation and open-source contribution.

## License

MIT
