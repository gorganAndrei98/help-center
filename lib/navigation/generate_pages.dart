import 'package:flu/navigation/routes.dart';
import 'package:flu/views/base/base_leaf_background.dart';
import 'package:flu/views/support_app.dart';
import 'package:flu/views/vibin.dart';
import 'package:flutter/material.dart';

import '../views/dashboard.dart';

typedef HcPageBuilder = Widget Function(RouteSettings routeSettings,);

Widget generatePage(RouteSettings settings) {
  return _internalGeneratePage(settings);
}

Widget _internalGeneratePage(RouteSettings settings) {
  switch(settings.name) {
    case '/':
    case Routes.DASHBOARD:
      return const Dashboard();
    case Routes.SUPPORT_APP:
      return const SupportApp();
    case Routes.TEST:
      return Vibin();
    default:
      throw ArgumentError.value(settings.name, 'settings.name');
  }
}