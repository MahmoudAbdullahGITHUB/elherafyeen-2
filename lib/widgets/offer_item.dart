import 'dart:convert';

import "package:easy_localization/easy_localization.dart";
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/online_store/src/pages/product_detail.dart';
import 'package:elherafyeen/pages/user/update_product.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OfferItem extends StatelessWidget {
  VendorModel offer;
  bool edit;
  Function onDelete;

  OfferItem({this.offer, this.edit: false, this.onDelete});

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
    //if (height > 1080 || orpriientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) =>
                edit
                    ? UpdateProductPage(productId: offer.id.toString())
                    : ProductDetailPage(
                  product: offer,
                )));
      },
      child: Container(
          margin: EdgeInsets.all(15.0),
          // decoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     borderRadius: BorderRadius.circular(6.0),
          //     border: Border.all(width: 2.0, color: HColors.colorPrimaryDark)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      topRight: Radius.circular(6.0)),
                  child: Image.network(offer.logo ?? "",
                      width: width, fit: BoxFit.fill),
                ),
              ),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  offer.name ?? offer.description,
                  style:
                  TextStyle(color: HColors.colorPrimaryDark, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: offer.price_before != null &&
                      offer.price_before.isNotEmpty
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(offer.price_before,
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 14)),
                      Text("- " + offer.price_after,
                          style: TextStyle(fontSize: 12, color: Colors.grey,)),
                      Text("LE".tr(),
                          style: TextStyle(fontSize: 12, color: Colors.green)),
                    ],
                  )
                      : Text(offer.discount + "%"),
                ),
              ),
              edit
                  ? SizedBox(
                  width: double.infinity, child: TextButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(child: Text('Alert'.tr())),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "delete_product".tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                                child: Text('cancel'.tr()),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            FlatButton(
                                child: Text('Ok'.tr()),
                                onPressed: () {
                                  deleteIem();
                                  onDelete();
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    shape:
                    ButtonStyleButton.allOrNull<OutlinedBorder>(
                      new RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      .03))),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red),
                  ),
                  child: Text("delete".tr(), style: TextStyle(
                      color: Colors.white
                  ),)))
                  : SizedBox()
            ],
          )),
    );
  }

  Future<bool> deleteIem() async {
    final response = await http.post(
        Uri.parse(Strings.apiLink + "deleteProduct"),
        body: {"product_id": offer.id},
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    print(RegisterModel.shared.token.toString());

    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return true;
    }
  }
}
