import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/cars/vendor_details.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/widgets/car_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _ExamplePageState createState() => new _ExamplePageState();
}

class _ExamplePageState extends State<SearchPage> {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();

  // final dio = new Dio();
  String _searchText = "";
  List<VendorModel> names = [];
  List<VendorModel> filteredNames = [];
  Icon _searchIcon = new Icon(Icons.search);

  _ExamplePageState() {
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      // resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: new TextField(
        cursorColor: Colors.white,
        controller: _filter,
        style: TextStyle(color: Colors.white),
        decoration: new InputDecoration(
          // prefixIcon: new Icon(Icons.search),
          hintText: 'search'.tr(),
          hintStyle: TextStyle(color: Colors.white),
        ),
        onChanged: (d) {
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

  Widget _buildList() {
    // if (!(_searchText.isEmpty)) {
    //   List<VendorModel> tempList = [];
    //   for (int i = 0; i < filteredNames.length; i++) {
    //     if (filteredNames[i]
    //         .name
    //         .toLowerCase()
    //         .contains(_searchText.toLowerCase())) {
    //       tempList.add(filteredNames[i]);
    //     }
    //   }
    //   filteredNames = tempList;
    //
    // }

    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => VendorDetails(
                        vendor: filteredNames[index], fetchDetails: 1)));
          },
          child: CarWidget(
            vendor: filteredNames[index],
          ),
        );
      },
    );
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
    var withName =
        "search_for_users_by_name?name=$text&lang=${RegisterModel.shared.lang}";
    var withPhone =
        "search_for_users_by_phone?phone=$text&lang=${RegisterModel.shared.lang}";
    String url = "";
    if (_phoneNumberValidator(text)) {
      print("search with phone");
      url = withPhone;
    } else
      url = withName;
    try {
      final response = await http.get(Uri.parse(Strings.apiLink + url));
      final body = json.decode(response.body);
      print(body.toString());
      names = List<VendorModel>.from(
          body['result']["users"].map((data) => VendorModel.fromMap(data)));
      setState(() {
        print(names.length.toString());
        // names.shuffle();
        filteredNames = names;
      });
    } catch (e) {
      print("sss" + e.toString());
    }
  }

  bool _phoneNumberValidator(String value) {
    String patttern = r'(^[0-9])';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}
