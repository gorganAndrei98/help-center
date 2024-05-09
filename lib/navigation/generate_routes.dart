import 'package:flu/navigation/generate_pages.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(HcPageBuilder pageBuilder, RouteSettings settings) {
  Widget page = pageBuilder(settings);

  return MaterialPageRoute(settings: settings, maintainState: true, builder: (_) => page);
}

RouteFactory createRouteGenerator() => (settings) => generateRoute(generatePage, settings);