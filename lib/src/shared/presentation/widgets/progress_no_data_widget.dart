import 'package:flutter/material.dart';


class ProgressNoData extends StatelessWidget {
  const ProgressNoData({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            
          ),
        ),
      ),
    );
  }
}
