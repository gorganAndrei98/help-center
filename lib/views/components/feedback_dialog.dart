import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeedbackDialog extends StatelessWidget {
  final bool isPositive;

  const FeedbackDialog({super.key, this.isPositive = true});

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: SizedBox(
              width: 174,
              height: 160,
              child: SvgPicture.asset(
                  isPositive ? 'assets/thumb_up.svg' : 'assets/thumb_down.svg'),
            ),
          ),
          isPositive
              ? const Text(
                  "La tua domanda è stata inviata con successo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              : const Text(
                  "Ops, qualcosa è andato storto",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => nav.pop(true),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  child: const Text('OK',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
