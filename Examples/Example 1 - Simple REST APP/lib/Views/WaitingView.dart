import 'package:flutter/material.dart';
import 'package:testiut/main.dart';

class WaitingView extends StatelessWidget {
  final Function(currentState cs) callbackFunction;

  const WaitingView({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children;
    children = const <Widget>[
      SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Waiting...', style: const TextStyle(fontSize: 15)),
      )
    ];
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    ));
  }
}
