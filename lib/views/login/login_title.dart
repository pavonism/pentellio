import 'package:flutter/material.dart';

class PentellioTitle extends StatelessWidget {
  const PentellioTitle({Key? key, this.twoLines = false}) : super(key: key);

  final bool twoLines;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          twoLines ? 'Welcome to \n Pentellio!' : 'Welcome to Pentellio!',
          maxLines: 2,
          style: TextStyle(
              fontSize: 100,
              fontFamily: 'FugglesPro-Regular',
              color: Theme.of(context).primaryColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
