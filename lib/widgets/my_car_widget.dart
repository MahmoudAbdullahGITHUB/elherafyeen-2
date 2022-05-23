import 'package:elherafyeen/models/vehicle_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyCarWidget extends StatefulWidget {
  var slidableController;
  var index;
  VehicleModel car;

  MyCarWidget({Key key, this.index, this.slidableController, this.car})
      : super(key: key);

  @override
  _MyCarWidgetState createState() => _MyCarWidgetState();
}

class _MyCarWidgetState extends State<MyCarWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final orientation = MediaQuery
        .of(context)
        .orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 1.5;
//    if (height > 2040) factor = 3.0;

    final Axis slidableDirection = Axis.horizontal;
    return Slidable(
        key: Key(""),
        controller: widget.slidableController,
        direction: slidableDirection,
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            setState(() {});
          },
        ),
        actionPane: _getActionPane(widget.index),
        actionExtentRatio: 0.25,
        child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.94,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height * 0.03),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            FadeInImage(image: NetworkImage(widget.car.image),
                              placeholder: AssetImage('assets/7.png'),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.5,
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Text(
                                  widget.car.brand_name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HColors.colorPrimaryDark,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                                child: Text(
                                  widget.car.model_name +
                                      "-" +
                                      widget.car.shape_name +
                                      "-" +
                                      widget.car.gear_box_name,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                                child: Text(
                                  widget.car.fuel_name,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                setState(() {});
                // _showSnackBar(context, 'Deleted');
              })
        ]
    );
  }

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }
}
