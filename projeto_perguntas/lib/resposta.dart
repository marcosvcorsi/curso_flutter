import 'package:flutter/material.dart';

class Resposta extends StatelessWidget {
  final String text;
  final void Function() onClick;

  Resposta(this.text, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      child: RaisedButton(
        child: Text(text),
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: onClick,
      ),
    );
  }
}
