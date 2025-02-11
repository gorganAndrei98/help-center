import 'package:flu/data_models/tech_support_question.dart';
import 'package:flu/locator/locator.dart';
import 'package:flu/navigation/routes.dart';
import 'package:flu/server_requests/core/http_requests_core.dart';
import 'package:flu/views/base/base_leaf_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'components/buttons/bf_button.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  void _handleOnTap(BuildContext context, String targetRoute) {
    final nav = Navigator.of(context);
    nav.pushNamed(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLeafBackground(
      hasBackButton: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BfButton(
            height: 132,
            width: 320,
            onPressed: () => _handleOnTap(context, Routes.SUPPORT_APP),
            picture: SvgPicture.asset(
              'assets/operator.svg',
            ),
            text: 'Supporto tecnico',
          ),
          BfButton(
            height: 132,
            width: 320,
            onPressed: () => _handleOnTap(context, Routes.TEST),
            picture: SvgPicture.asset(
              'assets/chat_cloud.svg',
            ),
            text: 'Go to the viber',
          ),
          BfButton(
            height: 132,
            width: 320,
            onPressed: () => {},
            picture: SvgPicture.asset(
              'assets/hand_stop_sign.svg',
            ),
            text: 'Segnala un errore',
          ),
          BfButton(
            height: 132,
            width: 320,
            onPressed: () => _handleOnTap(context, Routes.LEZIONE),
            picture: SvgPicture.asset(
              'assets/operator.svg',
            ),
            text: 'Lezione',
          ),
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: e,
                ))
            .toList(),
      ),
    );
  }
}
