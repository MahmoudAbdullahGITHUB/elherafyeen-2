import 'package:elherafyeen/bloc/winsh/winsh_bloc.dart';
import 'package:elherafyeen/pages/cars/vendor_details.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/car_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WinchesItems extends StatefulWidget {
  String lat, lng, type;
  bool company;
  WinchesItems({Key key, this.lat, this.lng, this.company, this.type})
      : super(key: key);

  @override
  _WinchesItemsState createState() => _WinchesItemsState();
}

class _WinchesItemsState extends State<WinchesItems> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;
    var style = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: Colors.grey.shade600, fontSize: 16 * factor);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type ?? "",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: HColors.colorPrimaryDark,
      ),
      body: BlocProvider(
        create: (_) => WinshBloc()
          ..add(LoadWinches(
              lat: widget.lat.toString(),
              lng: widget.lng.toString(),
              company: widget.company,
              page: 1)),
        child: BlocBuilder<WinshBloc, WinshState>(builder: (context, state) {
          if (state is WinchesLoadded)
            return ListView.builder(
              itemCount: state.winches.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (_) =>
                                  VendorDetails(vendor: state.winches[index])));
                    },
                    child: CarWidget(
                      vendor: state.winches[index],
                      // company: widget.company,
                    ));
              },
            );
          else {
            return Container(
              child: Center(
                  child: LoadingIndicator(
                color: HColors.colorPrimaryDark,
              )),
            );
          }
        }),
      ),
    );
  }
}
