import 'package:flu/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseLeafBackground extends StatelessWidget {
  final Widget child;
  final bool hasBackButton;

  const BaseLeafBackground({super.key, required this.child, this.hasBackButton = true});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 121, 15, 177),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Opacity(
                      opacity: 0.04,
                      child: Container(
                        width: 256,
                        height: 339,
                        child: SvgPicture.asset(
                          'assets/leaf_left.svg',
                          width: 256,
                          height: 339,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Opacity(
                      opacity: 0.04,
                      child: Container(
                        width: 172,
                        height: 228,
                        child: SvgPicture.asset(
                          'assets/leaf_right.svg',
                          width: 172,
                          height: 228,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Top background green wave
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 109,
                child: SvgPicture.asset(
                  'assets/top_background.svg',
                  fit: BoxFit.fill, 
                ),
              ),
            ),
            Center(child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: child,
            )),
            if (hasBackButton)
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
              )
          ],
        ),
      ),
    );
  }
}
