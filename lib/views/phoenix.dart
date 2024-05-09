import 'package:flutter/widgets.dart';

class Phoenix extends StatefulWidget {
  final Widget child;

  const Phoenix({Key? key, required this.child})
      : assert(child != null),
        super(key: key);

  @override
  _PhoenixState createState() => _PhoenixState();

  static void rebirth(BuildContext context) {
    context.findAncestorStateOfType<_PhoenixState>()!.restartApp();
  }
}

class _PhoenixState extends State<Phoenix> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
