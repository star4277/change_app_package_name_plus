# change_app_package_name_plus

[English README](./README.md)

一条命令修改 Flutter 项目的包名/Bundle 标识。

## 功能

- 更新 Android `applicationId`（`build.gradle` / `build.gradle.kts`）。
- 更新 Android manifest 包声明（`main`、`debug`、`profile`）。
- 将 Android 旧包路径下的源码文件迁移到新包路径。
- 迁移过程中同步更新 Java/Kotlin 包名引用。
- 迁移后清理旧包路径下的空目录。
- 更新 iOS `project.pbxproj` 中的 bundle identifier。
- 更新 OHOS `ohos/AppScope/app.json5` 中的 bundleName。
- 支持一次性重命名全部平台，或按平台单独执行。

## 安装

在 `dev_dependencies` 中添加：

```yaml
dev_dependencies:
  change_app_package_name_plus: ^1.5.0
```

或执行：

```bash
flutter pub add -d change_app_package_name_plus
```

然后执行：

```bash
flutter pub get
```

## 用法

同时重命名 Android + iOS + OHOS：

```bash
dart run change_app_package_name_plus:main com.new.package.name
```

仅重命名 Android：

```bash
dart run change_app_package_name_plus:main com.new.package.name --android
```

仅重命名 iOS：

```bash
dart run change_app_package_name_plus:main com.new.package.name --ios
```

仅重命名 OHOS：

```bash
dart run change_app_package_name_plus:main com.new.package.name --ohos
```

## 说明

- 如果你在 `Info.plist` 中自定义了 `CFBundleIdentifier`，请手动更新。
- `com.new.package.name` 只是示例，请替换为你的实际包名。

## 致谢

本项目基于并致敬以下原项目：

- 原项目：<https://github.com/atiqsamtia/change_app_package_name>
- 原作者：Atiq Samtia（<https://twitter.com/atiqsamtia>）

感谢原作者的实现与开源贡献。

## 许可证

MIT
