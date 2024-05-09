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
          //alignment: AlignmentDirectional.center,
          children: [
            //background leafs
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
                        padding: EdgeInsets.fromLTRB(0.5, 0.6, 0.1, 0.5),
                        child: SizedBox(
                          width: 255.4,
                          height: 337.9,
                          child: SvgPicture.asset('assets/leaf_left.svg'),
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
                        padding: EdgeInsets.fromLTRB(0.5, 0.7, 0.1, 0.5),
                        child: SizedBox(
                          width: 171.4,
                          height: 226.8,
                          child: SvgPicture.asset('assets/leaf_right.svg'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //top background green wave
            Container(
              //margin: EdgeInsets.fromLTRB(34, 0, 34, 64),
              child: Align(
                alignment: Alignment.topLeft,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 109,
                        child: SvgPicture.asset(
                          'assets/top_background.svg',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(child: child),
            if (hasBackButton)
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                ),
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios_new)),
              )
          ],
        ),
      ),
    );
  }
}
