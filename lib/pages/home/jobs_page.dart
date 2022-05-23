import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/bloc/home/home_bloc.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/cars/vendor_details.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class JobsPage extends StatefulWidget {
  double lat;
  double lng;

  JobsPage({Key key, this.lng, this.lat}) : super(key: key);

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final TextEditingController _filter = new TextEditingController();

  // final dio = new Dio();
  String _searchText = "";
  List<VendorModel> names = [];
  List<VendorModel> filteredNames = [];
  Icon _searchIcon = new Icon(Icons.search);

  List<VendorModel> applicants = [];

  _JobsPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    // this._getNames("مع");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    var textStyle =
        TextStyle(color: HColors.colorPrimaryDark, fontSize: 10 * factor);
    var style = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: Colors.grey.shade600, fontSize: 16 * factor);

    // circleIcon({Widget child}) {
    //   return Container(
    //       width: 35 * factor,
    //       height: 35 * factor,
    //       decoration: BoxDecoration(
    //         color: material.Colors.white,
    //         shape: BoxShape.rectangle,
    //         borderRadius: BorderRadius.circular(10),
    //         border: Border.all(
    //             width: 1.5 * factor, color: HColors.colorPrimaryDark),
    //       ),
    //       child: Padding(
    //         padding: const EdgeInsets.all(2.0),
    //         child: Center(child: child),
    //       ));
    // }

    // ListTile makeListTile2(VendorModel employee) => ListTile(
    //       contentPadding:
    //           EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    //       leading: Container(
    //         padding: EdgeInsets.only(right: 12.0),
    //         decoration: new BoxDecoration(
    //             border: new Border(
    //                 right: new BorderSide(width: 1.0, color: Colors.black))),
    //         child: Container(
    //           child: Expanded(
    //             child: Column(
    //               children: [
    //                 Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     height: 50,
    //                     child: CachedNetworkImage(
    //                       imageUrl: employee.logo,
    //                       height: 78.0 * factor,
    //                       width: 78.0 * factor,
    //                       fit: BoxFit.fill,
    //                       errorWidget: (context, url, error) =>
    //                           Image.asset("assets/profile_image.png"),
    //                     ),
    //                   ),
    //                 ),
    //                 Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     // color: material.Colors.yellowAccent,
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.end,
    //                       children: [
    //                         circleIcon(
    //                           child: IconButton(
    //                               icon: Icon(
    //                                 Icons.call,
    //                                 color: HColors.colorPrimaryDark,
    //                               ),
    //                               onPressed: () {
    //                                 _launchUrl(employee.phone);
    //                               }),
    //                         ),
    //                         Text("phoneCall".tr(), style: textStyle)
    //                       ],
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       title: Container(
    //         color: material.Colors.red,
    //         child: Text(
    //           employee.name,
    //           textAlign: TextAlign.right,
    //           style: TextStyle(
    //             color: HColors.colorPrimaryDark,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //       // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
    //
    //       // subtitle: Container(
    //       //   color: material.Colors.yellowAccent,
    //       //   // child: Row(
    //       //   //   children: <Widget>[
    //       //   //     Expanded(
    //       //   //       child: Column(
    //       //   //         children: [
    //       //   //           AutoSizeText(
    //       //   //             employee.city,
    //       //   //             maxLines: 2,
    //       //   //             style: TextStyle(
    //       //   //               fontSize: 12,
    //       //   //             ),
    //       //   //             minFontSize: 10,
    //       //   //             textDirection: material.TextDirection.rtl,
    //       //   //             textAlign: TextAlign.start,
    //       //   //             // maxFontSize: 15,
    //       //   //           ),
    //       //   //           AutoSizeText(
    //       //   //             employee.description,
    //       //   //             maxLines: 2,
    //       //   //             style: TextStyle(
    //       //   //               fontSize: 10,
    //       //   //             ),
    //       //   //             minFontSize: 10,
    //       //   //             textDirection: material.TextDirection.rtl,
    //       //   //             textAlign: TextAlign.start,
    //       //   //             // maxFontSize: 15,
    //       //   //           ),
    //       //   //           Text(
    //       //   //             employee.service_desc ?? "",
    //       //   //           ),
    //       //   //           Text(
    //       //   //             employee.job_field_name ?? "",
    //       //   //           ),
    //       //   //         ],
    //       //   //       ),
    //       //   //     ),
    //       //   //   ],
    //       //   // ),
    //       //   child: Row(
    //       //     children: <Widget>[
    //       //       Expanded(
    //       //         child: Column(
    //       //           children: [
    //       //             AutoSizeText(
    //       //               employee.city,
    //       //               maxLines: 2,
    //       //               style: TextStyle(
    //       //                 fontSize: 12,
    //       //               ),
    //       //               minFontSize: 10,
    //       //               textDirection: material.TextDirection.rtl,
    //       //               textAlign: TextAlign.start,
    //       //               // maxFontSize: 15,
    //       //             ),
    //       //             AutoSizeText(
    //       //               employee.description,
    //       //               maxLines: 2,
    //       //               style: TextStyle(
    //       //                 fontSize: 10,
    //       //               ),
    //       //               minFontSize: 10,
    //       //               textDirection: material.TextDirection.rtl,
    //       //               textAlign: TextAlign.start,
    //       //               // maxFontSize: 15,
    //       //             ),
    //       //             Text(
    //       //               employee.service_desc ?? "",
    //       //             ),
    //       //             Text(
    //       //               employee.job_field_name ?? "",
    //       //             ),
    //       //           ],
    //       //         ),
    //       //       ),
    //       //     ],
    //       //   ),
    //       // ),
    //       // isThreeLine: true,
    //     );

    Widget makeListTile(VendorModel employee) => Container(
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.black))),
              child: Container(
                // color: material.Colors.green,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: employee.logo,
                        height: 78.0 * factor,
                        width: 78.0 * factor,
                        fit: BoxFit.scaleDown,
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/profile_image.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: Container(
              color: material.Colors.white,
              child: Text(
                employee.name,
                // textAlign: TextAlign.right,
                style: TextStyle(
                  color: HColors.colorPrimaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Container(
              // color: material.Colors.yellowAccent,
              // child: Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: Column(
              //         children: [
              //           AutoSizeText(
              //             employee.city,
              //             maxLines: 2,
              //             style: TextStyle(
              //               fontSize: 12,
              //             ),
              //             minFontSize: 10,
              //             textDirection: material.TextDirection.rtl,
              //             textAlign: TextAlign.start,
              //             // maxFontSize: 15,
              //           ),
              //           AutoSizeText(
              //             employee.description,
              //             maxLines: 2,
              //             style: TextStyle(
              //               fontSize: 10,
              //             ),
              //             minFontSize: 10,
              //             textDirection: material.TextDirection.rtl,
              //             textAlign: TextAlign.start,
              //             // maxFontSize: 15,
              //           ),
              //           Text(
              //             employee.service_desc ?? "",
              //           ),
              //           Text(
              //             employee.job_field_name ?? "",
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              child: Container(
                // color: material.Colors.green,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: AutoSizeText(
                        employee.city,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        minFontSize: 10,
                        textDirection: material.TextDirection.rtl,
                      ),
                    ),
                    Container(
                      child: AutoSizeText(
                        employee.service_desc ?? "",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: style,
                      ),
                    ),
                    // AutoSizeText(employee.job_field_name ?? "",
                    //     textAlign: TextAlign.start),
                  ],
                ),
              ),
            ),
            trailing: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: CircleAvatar(
                      child: IconButton(
                        icon: Icon(Icons.call, color: material.Colors.white),
                        color: material.Colors.blue,
                        onPressed: () {
                          _launchUrl(employee.phone);
                        },
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  Container(child: Text("phoneCall".tr(), style: textStyle))
                ],
              ),
            ),
          ),
        );

    Card makeCard(VendorModel employee) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Directionality(
            textDirection: material.TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Colors.white,),
                child: makeListTile(employee),
              ),
            ),
          ),
        );

    Widget _buildBar() {
      return new AppBar(
        centerTitle: true,
        title: new TextField(
          cursorColor: Colors.white,
          controller: _filter,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
            // prefixIcon: new Icon(Icons.search),
            hintText: 'city'.tr(),
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (d) {
            /// beso
            // if (d.isNotEmpty && _filter.text.length > 3) {
            if (d.isNotEmpty) {
              _getNames(d);
            }
          },
        ),
        leading: new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      );
    }

    return Scaffold(
      appBar: _buildBar(),
      body: BlocProvider(
        create: (_) => HomeBloc()
          ..add(FetchJobs(
              lat: widget.lat.toString(), lng: widget.lng.toString())),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is VendorLoaded) {
            if (_filter.text.isEmpty || _filter.text.length < 3) {
              applicants = state.vendors;
            }
            return Container(
              child: ListView.builder(
                itemCount: applicants.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => VendorDetails(
                                      vendor: applicants[index],
                                      fetchDetails: 1,
                                    )));
                      },
                      child: Container(child: makeCard(applicants[index])));
                },
              ),
            );
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

  void _launchUrl(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        // this._appBarTitle = new TextField(
        //   controller: _filter,
        //   decoration: new InputDecoration(
        //       // prefixIcon: new Icon(Icons.search),
        //       hintText: 'Search...'
        //   ),
        // );
      } else {
        this._searchIcon = new Icon(Icons.search);
        // this._appBarTitle = new Text('Search Example');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames(String text) async {
    print('_getNames $text');
    try {
      applicants = await HomeApi.fetchJobs(
          lat: widget.lat.toString(),
          lng: widget.lng.toString(),
          city_name: text);

      setState(() {});
    } catch (e) {
      print("sss" + e.toString());
    }
  }
}
