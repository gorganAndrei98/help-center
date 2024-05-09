import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: Center(
        child: Column(
          children: <Widget>[
            const Spacer(),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ciao'),
                // Icon(
                //   Icons.accessible_forward,
                //   size: 150,
                // ),
                SizedBox(height: 32),
                CircularProgressIndicator(),
              ],
            ),
            Flexible(
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.all(8),
                child: Text('ciao')//const Icon(Icons.accessible_forward),//Image.asset('assets/minnovi_logo.png', width: 150),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
