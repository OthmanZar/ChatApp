import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onTape;

  const Button(
      {super.key,
      required this.color,
      required this.title,
      required this.onTape});

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: color,
      elevation: 11,
      borderRadius: BorderRadius.circular(15),
      color: color,
      child: MaterialButton(
        minWidth: 200,
        height: 42,
        onPressed: onTape,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
    );
  }
}
