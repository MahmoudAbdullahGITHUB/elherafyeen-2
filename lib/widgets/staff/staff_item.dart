import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/staff/employees_roles_page.dart';
import 'package:elherafyeen/widgets/car_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffItem extends StatelessWidget {
  VendorModel staff;
  bool pay;
  Function payFun;
  Function callFun;
  bool showDetails;

  StaffItem(
      {this.staff,
      this.pay: false,
      this.payFun,
      this.callFun,
      this.showDetails: false});

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
   // if (height > 2040) factor = 3.0;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListTile(
          onTap: () {
            if (showDetails) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => EmployeesRolesPage(
                            role: staff.userId,
                          )));
            } else {
              callFun();
            }
          },
          tileColor: Colors.grey.shade200,
          leading:
              (staff.logo != null) ? Image.network(staff.logo) : SizedBox(),
          title: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text(staff.name), Text(staff.phone.toString())],
              )),
              pay
                  ? InkWell(
                      onTap: () => payFun(),
                      child: Container(
                        width: 70 * factor,
                        height: 90 * factor,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipOval(
                                  child: Container(
                                      width: 40 * factor,
                                      height: 40 * factor,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/dollar-coin.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ))),
                              SizedBox(
                                height: 2 * factor,
                              ),
                              Text("payCash".tr())
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  callPhone(staff.phone);
                },
                child: ClipOval(
                  child: Container(
                    width: 35,
                    height: 35,
                    child: Icon(Icons.call),
                  ),
                ),
              ),
              SizedBox(width: 3),
              ClipOval(
                child: Container(
                  width: 25,
                  height: 25,
                  color: staff.color.isNotEmpty ?HexColor.fromHex(staff.color??""):
                  Colors.grey.shade200
                ),
              )
            ],
          )
          // ],
          // )
          ),
    );
  }
}
