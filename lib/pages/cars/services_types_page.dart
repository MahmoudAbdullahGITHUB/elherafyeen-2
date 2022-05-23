import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/bloc/home/home_bloc.dart';
import 'package:elherafyeen/pages/home/services_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/rounded_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceTypesPage extends StatefulWidget {
  double lat;
  double lng;

  ServiceTypesPage({Key key, this.lat, this.lng}) : super(key: key);

  @override
  _CarsPageState createState() => _CarsPageState();
}

class _CarsPageState extends State<ServiceTypesPage> {
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

    var space = SizedBox(
      height: height * .03,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HColors.colorPrimaryDark,
        title: Text(
          "my_services".tr(),
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
      ),
      body: BlocProvider(
        create: (_) => HomeBloc()..add(FetchServices()),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is ServicesLoaded) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 16 * factor),
                child: ListView.builder(
                  itemCount: state.searches.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        RoundedWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => ServicesPagePage(
                                            id: state.searches[index].id,
                                            lat: widget.lat,
                                            lng: widget.lng,
                                          )));
                            },
                            child: ListTile(
                              leading: Image.network(state.searches[index].logo,
                                  width: width * .08, height: height * .08),
                              title: Text(state.searches[index].name,
                                  style: style),
                              trailing: Icon(Icons.keyboard_arrow_down_rounded),
                            )),
                        space,
                      ],
                    );
                  },
                ));
          } else {
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
