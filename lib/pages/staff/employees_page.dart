import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/staff_api.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/staff/staff_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeesPage extends StatefulWidget {
  String role;

  EmployeesPage({Key key, this.role}) : super(key: key);

  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  var _loading = true;
  List<VendorModel> vendorModels = [];
  List<CategoryModel> categories = [];

  var firstDpManagers = true;

  @override
  void initState() {
    loadStaff();
    super.initState();
  }

  loadStaff() async {
    // if (widget.role == "1" || widget.role == "4") {
    var body = await StaffApi.fetchEmployeesbyAdmin();
    if (body['result']['department_managers'] != null) {
      vendorModels = List<VendorModel>.from(body['result']
              ['department_managers']
          .map((data) => VendorModel.fromMap(data)));

      categories = List<CategoryModel>.from(
          body['result']['roles'].map((data) => CategoryModel.fromMap(data)));
    } else {
      vendorModels = List<VendorModel>.from(body['result']['staff']['staff']
          .map((data) => VendorModel.fromMap(data)));
    }
    // } else {
    //   vendorModels = await StaffApi.fetchEmployeesbyTeamLeader();
    // }

    vendorModels.sort((a, b) => b.id.compareTo(a.id));
    setState(() {
      _loading = false;
    });
  }

  void callPhone(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("show Employee".tr()),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        child: ModalProgressHUD(
          inAsyncCall: _loading,
          color: Colors.white,
          progressIndicator: LoadingIndicator(
            color: HColors.colorPrimaryDark,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  // categories.isNotEmpty
                  //     ? ListTile(
                  //         title: Text(categories[0].name),
                  //         leading: Icon(Icons.keyboard_arrow_down_sharp),
                  //         onTap: () {
                  //           firstDpManagers = !firstDpManagers;
                  //           setState(() {});
                  //         },
                  //       )
                  //     : SizedBox(),
                  Visibility(
                    visible: firstDpManagers,
                    child: vendorModels.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: vendorModels.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StaffItem(
                                  staff: vendorModels[index],
                                  showDetails: true);
                            },
                          )
                        : SizedBox(),
                  ),
                  // categories.isNotEmpty
                  //     ? ListView.builder(
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemCount: categories.length,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           if (index == 0) {
                  //             return SizedBox();
                  //           }
                  //           return ListTile(
                  //             onTap: () {
                  //               Navigator.push(
                  //                   context,
                  //                   CupertinoPageRoute(
                  //                       builder: (_) => EmployeesRolesPage(
                  //                             role: categories[index].id,
                  //                           )));
                  //             },
                  //             title: Text(categories[index].name),
                  //             leading: Icon(Icons.keyboard_arrow_down_sharp),
                  //           );
                  //         },
                  //       )
                  //     : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
