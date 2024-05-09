import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BfButton extends StatelessWidget {
  final SvgPicture picture;
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  const BfButton({
    super.key,
    required this.picture,
    required this.text,
    this.onPressed,
    this.height = 150,
    this.width = 150,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: picture,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
