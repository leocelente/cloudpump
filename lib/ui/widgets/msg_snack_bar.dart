import 'package:flutter/material.dart';

class MessageSnackBar extends StatelessWidget {
  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
        duration: const Duration(seconds: 4),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.done),
            Text("\t Data sent to the Cloud"),
          ],
        ),
      );
  }
}