import 'dart:convert';

OhosApp ohosAppFromJson(String str) => OhosApp.fromJson(json.decode(str));

String ohosAppToJson(OhosApp data, {bool pretty = false}) {
  if (pretty) {
    return const JsonEncoder.withIndent('\t').convert(data.toJson());
  }
  return json.encode(data.toJson());
}

class OhosApp {
  App app;
  Map<String, dynamic> extra;

  OhosApp({
    required this.app,
    required this.extra,
  });

  factory OhosApp.fromJson(Map<String, dynamic> json) {
    final extra = Map<String, dynamic>.from(json);
    extra.remove("app");

    return OhosApp(
      app: App.fromJson(json["app"]),
      extra: extra,
    );
  }

  Map<String, dynamic> toJson() => {
        "app": app.toJson(),
        ...extra,
      };
}

class App {
  String bundleName;
  Map<String, dynamic> extra;

  App({
    required this.bundleName,
    required this.extra,
  });

  factory App.fromJson(Map<String, dynamic> json) {
    final extra = Map<String, dynamic>.from(json);
    extra.remove("bundleName");

    return App(
      bundleName: json['bundleName'] as String,
      extra: extra,
    );
  }

  Map<String, dynamic> toJson() => {
        "bundleName": bundleName,
        ...extra,
      };
}
