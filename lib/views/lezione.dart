import 'package:flu/navigation/routes.dart';
import 'package:flu/views/base/base_leaf_background.dart';
import 'package:flutter/material.dart';

class LezioneApp extends StatefulWidget {
  const LezioneApp({super.key});

  @override
  State<LezioneApp> createState() => _LezioneAppState();
}

class _LezioneAppState extends State<LezioneApp> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return BaseLeafBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () => setState(() => {}),
              child: Text('Aggiorna counter')),
          Text('$counter'),
          TextButton(
            onPressed: () => showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('AlertDialog Title'),
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    StatefulBuilder(builder: (dialogContext, setDialogState) {
                      return Row(
                        children: [
                          Text('$counter'),
                          TextButton.icon(
                            onPressed: () => setDialogState(() {
                              counter++;
                            }),
                            label: Text('Aumentami'),
                            icon: Icon(Icons.add),
                          ),
                        ],
                      );
                      //return Text('$counter');
                    })
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ).then((retrunDialogValue) {
              if (retrunDialogValue != null) {
                if (retrunDialogValue == true) {
                  setState(() {});
                } else {
                  setState(() {
                    counter = 0;
                  });
                }
              }
            }),
            child: const Text('Show Dialog'),
          ),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(Routes.CUBIT_APP),
            label: Text('Alla pagina del cubit'),
            icon: Icon(Icons.add_box_rounded),
          ),
        ],
      ),
    );
  }
}
