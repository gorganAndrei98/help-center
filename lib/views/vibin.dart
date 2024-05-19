import 'package:flu/blocs/vibin_bloc.dart';
import 'package:flu/events/vibin_events.dart';
import 'package:flu/vibin_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QueueVisualizer extends StatelessWidget {
  const QueueVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberBloc, NumberState>(builder: (context, state) {
      return ListView.builder(
        reverse: true,
        itemCount: state.queue.length,
        itemBuilder: (context, index) => ListTile(
          title: Text('${state.queue[index]}'),
        ),
      );
    });
  }
}

class LastEmittedNumber extends StatelessWidget {
  const LastEmittedNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberBloc, NumberState>(builder: (context, state) {
      return Center(
        child: Text(
          state.lastEmitted?.toString() ?? 'Waiting for first number',
        ),
      );
    });
  }
}

class Vibin extends StatelessWidget {
  const Vibin({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NumberBloc>(
            create: (context) => NumberBloc()..add(StartEmitting())),
      ],
      child: const _TheViber(),
    );
  }
}

class _TheViber extends StatefulWidget {
  const _TheViber({super.key});

  @override
  State<_TheViber> createState() => _TheViberState();
}

class _TheViberState extends State<_TheViber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spain without s'),
      ),
      body: BlocBuilder<NumberBloc, NumberState>(
        builder: (BuildContext context, NumberState state) {
          return Column(
            children: [
              Text('Queue'),
              Expanded(child: QueueVisualizer()),
              Text('Last emitted value'),
              Expanded(child: LastEmittedNumber()),
            ],
          );
        },
      ),
    );
  }
}
