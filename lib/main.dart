import 'package:flu/locator/locator.dart';
import 'package:flu/navigation/generate_pages.dart';
import 'package:flu/navigation/routes.dart';
import 'package:flu/server_requests/core/http_requests_core.dart';
import 'package:flu/views/phoenix.dart';
import 'package:flu/views/theme.dart';
import 'package:flutter/material.dart';

import 'navigation/generate_routes.dart';

void main() {
  setUpLocator();
  runApp(
    Phoenix(
      child: _loadApp(),
    ),
  );
}

/* I know this function is not easily readable at first glance because it contains other functions, but I wanted to encapsulate all the initial loading in a single function
*/
Widget _loadApp() {
  Future<bool> initialLoading() async {
    return Future.delayed(Duration(seconds: 3)).then((value) => true);
  }

  Widget? app;
  Widget? getApp({bool forceUpdate = false}) {
    app ??= _buildApp();
    return app;
  }

  return FutureBuilder<bool>(
      future: initialLoading(),
      builder: (context, snapshot) {
        final loaded = (snapshot.data ?? false) || snapshot.hasError;

        //wanted to do a splashscreen but could manage in time
        //if (!loaded) return const SplashScreen();

        return getApp()!;
      });
}

Widget _buildApp() {
  return Builder(builder: (context) {
    return MaterialApp(
      theme: Theme.of(context),
      home: generatePage(
        const RouteSettings(name: Routes.DASHBOARD),
      ),
      onGenerateRoute: createRouteGenerator(),
    );
  });
}
