import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/bloc/home/home_bloc.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/cars/vendor_details.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DisableJobsPage extends StatefulWidget {
  double lat;
  double lng;

  DisableJobsPage({Key key, this.lng, this.lat}) : super(key: key);

  @override
  _DisableJobsPageState createState() => _DisableJobsPageState();
}

class _DisableJobsPageState extends State<DisableJobsPage> {
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

    circleIcon({Widget child}) {
      return ClipOval(
          child: Container(
              width: 35 * factor,
              height: 35 * factor,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 1.5 * factor, color: HColors.colorPrimaryDark),
              ),
              child: Center(
                child: child,
              )));
    }

    ListTile makeListTile(VendorModel employee) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.black))),
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: employee.logo,
                  height: 78.0 * factor,
                  width: 78.0 * factor,
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/profile_image.png"),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      circleIcon(
                        child: IconButton(
                            icon: Icon(
                              Icons.call,
                              color: HColors.colorPrimaryDark,
                            ),
                            onPressed: () {
                              _launchUrl(employee.phone);
                            }),
                      ),
                      Text("phoneCall".tr(), style: textStyle)
                    ],
                  ),
                )
              ],
            ),
          ),
          title: Text(
            employee.name,
            style: TextStyle(
                color: HColors.colorPrimaryDark, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    AutoSizeText(
                      employee.city,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      minFontSize: 10,
                      textDirection: material.TextDirection.rtl,
                      textAlign: TextAlign.start,
                      // maxFontSize: 15,
                    ),
                    AutoSizeText(
                      employee.description,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                      minFontSize: 10,
                      textDirection: material.TextDirection.rtl,
                      textAlign: TextAlign.start,
                      // maxFontSize: 15,
                    ),
                    Text(
                      employee.service_desc ?? "",
                    ),
                    Text(
                      employee.job_field_name ?? "",
                    ),
                  ],
                ),
              ),
            ],
          ),
          isThreeLine: true,
        );

    Card makeCard(VendorModel employee) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Directionality(
            textDirection: material.TextDirection.ltr,
            child: Container(
              height: 180,
              decoration: BoxDecoration(color: Colors.white),
              child: makeListTile(employee),
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
            if (d.isNotEmpty && _filter.text.length > 3) {
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
          ..add(FetchDisableJobs(
              lat: widget.lat.toString(), lng: widget.lng.toString())),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is VendorLoaded) {
            if (_filter.text.isEmpty || _filter.text.length < 3) {
              applicants = state.vendors;
            }
            return ListView.builder(
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
                    child: makeCard(applicants[index]));
              },
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
    try {
      applicants = await HomeApi.FetchDisableJobs(
          lat: widget.lat.toString(),
          lng: widget.lng.toString(),
          city_name: text);

      setState(() {});
    } catch (e) {
      print("sss" + e.toString());
    }
  }
}
