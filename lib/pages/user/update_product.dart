import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/bloc/vendor/vendor_bloc.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/widgets/add_image_widget.dart';
import 'package:elherafyeen/widgets/image_picker_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/rounded_text_field.dart';
import 'package:elherafyeen/widgets/staff/show_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UpdateProductPage extends StatefulWidget {
  var productId;

  UpdateProductPage({Key key, this.productId}) : super(key: key);

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProductPage> {
  var typeCategory = "0";
  var typeMarchant = "0";
  List<String> galleryImagesBase64 = [];

  var nameController = TextEditingController();
  var directorNameController = TextEditingController();
  var descCtrl = TextEditingController();
  var afterPriceCtrl = TextEditingController();
  var beforePriceCtrl = TextEditingController();
  var stockCtrl = TextEditingController();
  var idSet = <String>{};
  FocusNode colorFocus = FocusNode();
  FocusNode modelFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode capacityFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode brandFocus = FocusNode();
  FocusNode shapeFocus = FocusNode();
  FocusNode manualFocus = FocusNode();
  FocusNode fuelFocus = FocusNode();
  List<String> galleryImages = [];
  var productStatus = TextEditingController();

  // List<String> status = ["productStatus".tr(), "new".tr(), "old".tr()];
  VendorModel product;

  File _image;
  var imageString = "";
  final picker = ImagePicker();

  var _loading = false;

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  getProduct() async {
    print("MAHMOUD" + widget.productId.toString());
    product = await HomeApi.fetchProductDetails(
        product_id: widget.productId.toString());
    if (product != null) {
      beforePriceCtrl.text = product.price_before ?? "";
      afterPriceCtrl.text = product.price_after ?? "";
      nameController.text = product.name ?? "";
      stockCtrl.text = product.stock ?? "";
      descCtrl.text = product.description ?? "";
      productStatus.text = product.status ?? "productStatus".tr();
    }
    setState(() {});
  }

  Future getImage(bool gallery, {bool list: false}) async {
    final pickedFile = await picker.getImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _image = await CropImageMethod(image: _image);
      if (list) {
        List<int> imageBytes = _image.readAsBytesSync();
        print(imageBytes);
        final bytes = await _image.readAsBytes();
        galleryImagesBase64.add(base64Encode(bytes));
        galleryImages.add(_image.path);
        setState(() {});
      } else {
        List<int> imageBytes = _image.readAsBytesSync();
        print(imageBytes);
        final bytes = await _image.readAsBytes();
        imageString = base64Encode(bytes);
        print(imageString);
        setState(() {});
      }
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  List<CategoryModel> listCategories = [];

  double latitude;
  double longitude;
  var currentLocation;

  Future<Map<String, double>> getCurrentLocation() async {
    Map<String, double> result = {"latitude": 0.0, "longitude": 0.0};
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      result = {
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude
      };
      setState(() {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    } catch (e) {
      currentLocation = null;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  return VendorBloc()..add(LoadingEventsForMarket());
                },
              ),
            ],
            child: Builder(builder: (context) {
              _addVehicleButtonPressed() async {
                await getCurrentLocation();
                // List<String> provied = [];
                // provied.add(typeCategory);

                setState(() => _loading = true);
                try {
                  await VendorApi.updateProduct(
                      product_id: widget.productId,
                      context: context,
                      name: nameController.text,
                      notes: descCtrl.text,
                      galleryImagesBase64: galleryImages,
                      before_price: beforePriceCtrl.text,
                      after_price: afterPriceCtrl.text,
                      stock: stockCtrl.text,
                      status: productStatus.text,
                      // brand_id: typeCategory.toString(),
                      logo: imageString);

                  Navigator.pop(context);
                } catch (e) {
                  setState(() => _loading = false);
                  print(e.toString());

                  errorSnackBar(e.toString(), context);
                }
              }

              return (product == null)
                  ? Container(
                      child: Center(
                          child: LoadingIndicator(
                        color: HColors.colorPrimaryDark,
                      )),
                    )
                  : ModalProgressHUD(
                      inAsyncCall: _loading,
                      progressIndicator: LoadingIndicator(
                        color: HColors.colorPrimaryDark,
                      ),
                      child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              product.logo != null && product.logo.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        ImagePickerWidget(
                                            context: context,
                                            onTap: (value) {
                                              getImage(value);
                                            });
                                      },
                                      child: Image.network(product.logo,
                                          width: width * .2,
                                          height: height * .15),
                                    )
                                  : _image != null
                                      ? InkWell(
                                          onTap: () {
                                            ImagePickerWidget(
                                                context: context,
                                                onTap: (value) {
                                                  getImage(value);
                                                });
                                          },
                                          child: Image.file(_image,
                                              width: width * .2,
                                              height: height * .15),
                                        )
                                      : AddImageWidget(
                                          title: "capture".tr(),
                                          onTap: () {
                                            ImagePickerWidget(
                                                context: context,
                                                onTap: (value) {
                                                  getImage(value);
                                                });
                                          }),
                              RoundedTextField(
                                labelText: "name".tr(),
                                controller: nameController,
                                onChanged: (text) {},
                                // focusNode: manualFocus,
                                inputType: TextInputType.text,
                              ),
                              // Card(
                              //     elevation: 5,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.all(
                              //           Radius.circular(height * .04)),
                              //       side: new BorderSide(
                              //           color: Colors.grey, width: 1),
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 8),
                              //       child: DropdownButton<String>(
                              //         value: typeCategory.toString(),
                              //         underline: SizedBox(),
                              //         icon: Icon(
                              //           Icons.keyboard_arrow_down,
                              //         ),
                              //         autofocus: true,
                              //         iconSize: 16 * factor,
                              //         isExpanded: true,
                              //         elevation: 16,
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .headline3
                              //             .copyWith(fontSize: 16 * factor),
                              //         onChanged: (String newValue) {
                              //           setState(() {
                              //             CategoryModel model =
                              //                 listCategories.firstWhere((r) =>
                              //                     r.id.toString() == newValue);
                              //             typeCategory = model.id;
                              //             if (typeCategory != "-1") {
                              //               BlocProvider.of<VendorBloc>(context)
                              //                   .add(LoadingBrands(
                              //                       catId: typeCategory));
                              //             }
                              //           });
                              //         },
                              //         items: listCategories
                              //             .map<DropdownMenuItem<String>>(
                              //                 (CategoryModel value) {
                              //           return DropdownMenuItem<String>(
                              //             value: value.id.toString(),
                              //             child: Text(value.name),
                              //             onTap: () {
                              //               typeCategory = value.id;
                              //               print(typeCategory);
                              //               if (typeCategory != "-1") {
                              //                 BlocProvider.of<VendorBloc>(
                              //                         context)
                              //                     .add(LoadingBrands(
                              //                         catId: typeCategory));
                              //               }
                              //               setState(() {});
                              //             },
                              //           );
                              //         }).toList(),
                              //       ),
                              //     )),
                              // Card(
                              //     elevation: 5,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.all(
                              //           Radius.circular(height * .04)),
                              //       side:
                              //           new BorderSide(color: Colors.grey, width: 1),
                              //     ),
                              //     child: Padding(
                              //       padding:
                              //           const EdgeInsets.symmetric(horizontal: 8),
                              //       child: DropdownButton<String>(
                              //         value: productStatus.toString(),
                              //         underline: SizedBox(),
                              //         icon: Icon(
                              //           Icons.keyboard_arrow_down,
                              //         ),
                              //         autofocus: true,
                              //         iconSize: 16 * factor,
                              //         isExpanded: true,
                              //         elevation: 16,
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .headline3
                              //             .copyWith(fontSize: 16 * factor),
                              //         onChanged: (String newValue) {
                              //           setState(() {
                              //             String model = status.firstWhere(
                              //                 (r) => r.toString() == newValue);
                              //             productStatus = model;
                              //           });
                              //         },
                              //         items: status.map<DropdownMenuItem<String>>(
                              //             (String value) {
                              //           return DropdownMenuItem<String>(
                              //             value: value.toString(),
                              //             child: Text(value),
                              //             onTap: () {
                              //               productStatus = value;
                              //               print(productStatus);
                              //               setState(() {});
                              //             },
                              //           );
                              //         }).toList(),
                              //       ),
                              //     )),
                              RoundedTextField(
                                labelText: "productStatus".tr(),
                                controller: productStatus,
                                onChanged: (text) {},
                                // focusNode: manualFocus,
                                inputType: TextInputType.text,
                              ),
                              RoundedTextField(
                                labelText: "price_before".tr(),
                                controller: beforePriceCtrl,
                                onChanged: (text) {},
                                // focusNode: manualFocus,
                                inputType: TextInputType.number,
                              ),
                              RoundedTextField(
                                labelText: "price_after".tr(),
                                controller: afterPriceCtrl,
                                onChanged: (text) {},
                                isEnabled: true,
                                // focusNode: dateFocus,
                                inputType: TextInputType.number,
                              ),
                              RoundedTextField(
                                labelText: "notes".tr(),
                                controller: descCtrl,
                                onChanged: (text) {},
                                isEnabled: true,
                                // focusNode: dateFocus,
                                inputType: TextInputType.text,
                              ),
                              RoundedTextField(
                                labelText: "stock".tr(),
                                controller: stockCtrl,
                                onChanged: (text) {},
                                isEnabled: true,
                                // focusNode: colorFocus,
                                inputType: TextInputType.number,
                              ),
                              (product.gallery != null &&
                                      product.gallery.length != 0)
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: product.gallery.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (_) => ShowImage(
                                                          image: product
                                                              .gallery[index],
                                                        )));
                                          },
                                          child: Container(
                                            width: width * .2,
                                            height: height * .12,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(width * .02)),
                                              child: Image.network(
                                                  product.gallery[index],
                                                  width: width * .2,
                                                  height: height * .12,
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                        );
                                      },
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        crossAxisSpacing: 5.0,
                                        mainAxisSpacing: 5.0,
                                      ),
                                    )
                                  : SizedBox(),
                              Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(width * .02)),
                                      side: BorderSide(
                                          color: HColors.colorPrimaryDark,
                                          width: 1 * factor)),
                                  color: Colors.white,
                                  child: Container(
                                    margin: EdgeInsets.all(width * .02),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: galleryImages.length + 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index == 0) {
                                          return RaisedButton(
                                            onPressed: () {
                                              ImagePickerWidget(
                                                  context: context,
                                                  onTap: (value) {
                                                    getImage(value, list: true);
                                                  });
                                            },
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        width * .04)),
                                                side: BorderSide(
                                                    color: Colors.grey)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                      HColors.colorPrimaryDark,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return Container(
                                          width: width * .2,
                                          height: height * .12,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        width * .02)),
                                                child: Image.file(
                                                    File(galleryImages[
                                                        index - 1]),
                                                    width: width * .2,
                                                    height: height * .12,
                                                    fit: BoxFit.fill),
                                              ),
                                              Positioned.fill(
                                                  child: Align(
                                                alignment: Alignment.topLeft,
                                                child: InkWell(
                                                  onTap: () {
                                                    galleryImages
                                                        .removeAt(index - 1);
                                                    galleryImagesBase64
                                                        .removeAt(index - 1);
                                                    setState(() {});
                                                  },
                                                  child: Image.asset(
                                                    'assets/Icon ionic-ios-close-circle.png',
                                                    width: width * .08,
                                                    height: height * .08,
                                                  ),
                                                ),
                                              ))
                                            ],
                                          ),
                                        );
                                      },
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 5.0,
                                        mainAxisSpacing: 5.0,
                                      ),
                                    ),
                                  )),
                              ButtonTheme(
                                minWidth: width * .85,
                                height: height * 0.08,
                                child: RaisedButton(
                                    color: HColors.colorSecondary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(height * .03))),
                                    child: Text(
                                      "ok".tr(),
                                      style:
                                          TextStyle(color: HColors.colorButton),
                                    ),
                                    onPressed: () {
                                      _addVehicleButtonPressed();
                                    }),
                              )
                            ],
                          )),
                    );
            })));
  }
}
