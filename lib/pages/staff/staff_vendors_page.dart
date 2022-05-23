import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/api/payment_api.dart';
import 'package:elherafyeen/api/staff_api.dart';
import 'package:elherafyeen/api/user_api.dart';
import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/subscription_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/car_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/staff/staff_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffVendorsPage extends StatefulWidget {
  String id;

  StaffVendorsPage({Key key, this.id}) : super(key: key);

  @override
  _StaffVendorsPageState createState() => _StaffVendorsPageState();
}

class _StaffVendorsPageState extends State<StaffVendorsPage> {
  var _loading = true;
  List<VendorModel> vendorModels = [];
  List<String> listColors = [];
  List<int> lisColorsNum = [];
  int touchedIndex;

  @override
  void initState() {
    loadStaff();
    super.initState();
  }

  void callPhone(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  loadStaff() async {
    vendorModels = await StaffApi.getVendorsUnderById(widget.id);
    if (vendorModels != null && vendorModels.isNotEmpty) {
      for (var vendor in vendorModels) {
        if (vendor.color != null) {
          if (!listColors.contains(vendor.color)) listColors.add(vendor.color);
        }
      }
      for (var colorsNum in listColors) {
        int num = 0;
        for (var vendor in vendorModels) {
          if (colorsNum == vendor.color) {
            num++;
          }
        }
        lisColorsNum.add(num);
      }
    }
    if (vendorModels != null && vendorModels.isNotEmpty) {
      vendorModels.sort((a, b) => a.id.compareTo(b.id));
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> showingColors() {
      return List.generate(listColors.length, (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? 25 : 16;
        final double radius = isTouched ? 60 : 50;
        return PieChartSectionData(
          color: HexColor.fromHex(listColors[i]),
          value: 40,
          title: lisColorsNum[i].toString(),
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        );
      });
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("show Vendors staff".tr()),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: Colors.white,
        progressIndicator: LoadingIndicator(
          color: HColors.colorPrimaryDark,
        ),
        child: SingleChildScrollView(
          child: vendorModels.isNotEmpty
              ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(25),
                      height: 150,
                      child: PieChart(PieChartData(
                          pieTouchData:
                              PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              final desiredTouch = pieTouchResponse.touchInput
                                      is! PointerExitEvent &&
                                  pieTouchResponse.touchInput
                                      is! PointerUpEvent;
                              if (desiredTouch &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse
                                    .touchedSection.touchedSectionIndex;
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          }),
                          startDegreeOffset: 180,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingColors())),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemExtent: 95 * factor,
                      itemCount: vendorModels.length,
                      itemBuilder: (BuildContext context, int index) {
                        return StaffItem(
                          staff: vendorModels[index],
                          pay: true,
                          payFun: () async {
                            var methods = await HomeApi.getPaymentMethods();
                            showPaymentMethods(
                                context: context,
                                methodes: methods,
                                id: vendorModels[index].userId.toString());
                          },
                          callFun: () async {
                            await VendorApi.addStaffToVendor(
                                vendorModels[index].userId);
                          },
                        );
                      },
                    ),
                  ],
                )
              : SizedBox(),
        ),
      ),
    );
  }

  var style = TextStyle(color: HColors.colorPrimaryDark, fontSize: 17);
  var styleMedium = TextStyle(color: HColors.colorPrimaryDark, fontSize: 12);

  void showSubChoices(
      {BuildContext context,
      List<SubscriptionModel> subscribtions,
      String id,
      String method_id}) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white.withOpacity(0),
        builder: (_) => Card(
              margin: EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: subscribtions.length,
                      itemBuilder: (BuildContext context, int index) {
                        var sub = subscribtions[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () async {
                              bool result = await VendorApi.payStaff(
                                  id, sub.id, method_id);
                              if (result) {
                                Fluttertoast.showToast(
                                    msg: "added".tr(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pop(context);
                              }
                            },
                            title: Text(
                              sub.name,
                              style: style,
                            ),
                            subtitle: Text(
                              sub.value + "LE".tr(),
                              style: styleMedium,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  Future<void> showPaymentMethods(
      {BuildContext context, List<CategoryModel> methodes, String id}) async {
    String phone = await UserApi.getActivePhone() ?? "";

    showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white.withOpacity(0),
        builder: (_) => Card(
              margin: EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: methodes.length,
                      itemBuilder: (BuildContext context, int index) {
                        var sub = methodes[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () async {
                              if (index == 0) {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                    context: context,
                                    barrierColor: Colors.white.withOpacity(0),
                                    backgroundColor:
                                        Colors.white.withOpacity(0),
                                    builder: (_) => Card(
                                          margin: EdgeInsets.all(12),
                                          color: Colors.white,
                                          child: Container(
                                            child: Center(
                                                child: Text("sendPayment".tr() +
                                                    phone)),
                                          ),
                                        ));
                              } else if (index == 1) {
                                var subs =
                                    await PaymentApi.getSubscriptionsTypes();
                                showSubChoices(
                                    context: context,
                                    subscribtions: subs,
                                    id: id,
                                    method_id: methodes[index].id.toString());
                              } else {
                                String image = await HomeApi.getImageQRCode();
                                Navigator.pop(context);
                                showModalBottomSheet(
                                    context: context,
                                    barrierColor: Colors.white.withOpacity(0),
                                    backgroundColor:
                                        Colors.white.withOpacity(0),
                                    builder: (_) => Card(
                                          margin: EdgeInsets.all(12),
                                          color: Colors.white,
                                          child: Container(
                                            margin: EdgeInsets.all(12),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .35,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .35,
                                            child: Center(
                                                child: Image.network(
                                              image ?? "",
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .35,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .35,
                                            )),
                                          ),
                                        ));
                              }
                            },
                            leading: Image.network(
                              sub.logo,
                              height: 67,
                              width: 67,
                            ),
                            title: Text(
                              sub.name,
                              style: style,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
  }
}
