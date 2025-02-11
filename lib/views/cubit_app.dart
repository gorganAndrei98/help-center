import 'package:flu/cubits/lezione/lezione_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../locator/locator.dart';
import '../server_requests/core/http_requests_core.dart';
import 'base/base_leaf_background.dart';

class CubitApp extends StatelessWidget {
  const CubitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LezioneCubit>(
      create: (context) =>
          LezioneCubit(requests: getIt<HttpRequestsCore>().lezioneRequests)
            ..initRandomCounter(),
      child: const BaseLeafBackground(
        child: _CubitAppPage(),
      ),
    );
  }
}

class _CubitAppPage extends StatefulWidget {
  const _CubitAppPage({super.key});

  @override
  State<_CubitAppPage> createState() => _CubitAppPageState();
}

class _CubitAppPageState extends State<_CubitAppPage> {
  int innerCounter = 0;

  void _addCounter({int? extraCounter}) {
    if (!mounted) return;
    context.read<LezioneCubit>().increaseCounter(extraCounter: extraCounter);
    return;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LezioneCubit, CubitState>(builder: (context, state) {
      if (state.status == LezionePageStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state.status == LezionePageStatus.failure) {
        return Center(
          child: Text('Estia'),
        );
      }
      return SingleChildScrollView(
        child: GridView.count(
          shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: [
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
            ],
        ),
      );
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: _addCounter,
            label: Text('Counter: ${state.counter}'),
            icon: Icon(Icons.add),
          ),
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
                          Text('$innerCounter'),
                          TextButton.icon(
                            onPressed: () => setDialogState(() {
                              innerCounter++;
                              if (innerCounter < 2) {
                                print('YOOO');
                              }
                              _addCounter(extraCounter: innerCounter);
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
            ),
            child: const Text('Show Dialog'),
          ),
        ],
      );
    });
  }
}
