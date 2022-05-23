import 'package:elherafyeen/api/vehicle_api.dart';
import 'package:elherafyeen/models/vehicle_model.dart';
import 'package:elherafyeen/pages/auth/more_auth/add_vehicle_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/my_car_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyCarsPage extends StatefulWidget {
  MyCarsPage({Key key}) : super(key: key);

  @override
  _MyCarsPageState createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  SlidableController slidableController;
  List<VehicleModel> myCars = [];
  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  @protected
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    getMyCars();
    super.initState();
  }

  getMyCars() async {
    myCars = await VehicleApi.fetchUserVehicles();
    setState(() {});
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 1.5;
//    if (height > 2040) factor = 3.0;

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                          CupertinoPageRoute(builder: (_) => AddVehiclePage()),
                  );
                  // Navigator.pushAndRemoveUntil(context,
                  //     CupertinoPageRoute(builder: (_) => AddVehiclePage()),
                  //         (route) => false);
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * .04)),
                    side: BorderSide(color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add,
                    color: HColors.colorPrimaryDark,
                  ),
                ),
              ),
              myCars.length != 0
                  ? ListView.builder(
                      itemCount: myCars.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return MyCarWidget(
                            index: index,
                            car: myCars[index],
                            slidableController: slidableController);
                      },
                    )
                  : Container(
                      child: Center(
                          child: LoadingIndicator(
                        color: HColors.colorPrimaryDark,
                      )),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
