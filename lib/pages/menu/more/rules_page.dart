import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  String title, text;

  RulesPage({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                    color: HColors.colorPrimaryDark,
                    fontSize: 20 * factor,
                    fontFamily: "Cairo"),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
