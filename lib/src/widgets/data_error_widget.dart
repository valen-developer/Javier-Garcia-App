import 'package:flutter/material.dart';

class DataError extends StatelessWidget {
  const DataError({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.do_not_disturb_on,
            color: Colors.red,
            semanticLabel: "Internet or API key failed",
          ),
          Text(
            "Internet or API error",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
