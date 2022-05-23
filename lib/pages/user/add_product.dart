import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/bloc/vehicle/vehicle_bloc.dart';
import 'package:elherafyeen/bloc/vendor/vendor_bloc.dart';
import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/brand_model_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/category_shape_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/widgets/add_image_widget.dart';
import 'package:elherafyeen/widgets/image_picker_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/rounded_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddProductPage extends StatefulWidget {
  AddProductPage({Key key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  var typeCategory = "0";
  var typeMarchant = "0";
  var typeGearBox = "0";
  var brandType = "0";
  var shapeId = "0";
  List<String> galleryImagesBase64 = [];

  var nameController = TextEditingController();
  var directorNameController = TextEditingController();
  var descCtrl = TextEditingController();
  var afterPriceCtrl = TextEditingController();
  var whatsCtrl = TextEditingController();
  var beforePriceCtrl = TextEditingController();
  var stockCtrl = TextEditingController();
  var product_position = TextEditingController();
  var product_direction = TextEditingController();
  var model_year = TextEditingController();
  var idSet = <String>{};
  FocusNode colorFocus = FocusNode();
  FocusNode modelFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode capacityFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode brandFocus = FocusNode();
  FocusNode shapeFocus = FocusNode();
  FocusNode manualFocus = FocusNode();
  var modelId = "0";
  FocusNode fuelFocus = FocusNode();
  List<String> galleryImages = [];
  var productStatus = TextEditingController();
  List<String> status = ["productStatus".tr(), "new".tr(), "old".tr()];

  File _image;
  var imageString = "";
  final picker = ImagePicker();

  var _loading = false;

  List<CategoryModel> listCategories = [];
  List<CategoryModel> listGearBoxTypes = [];
  List<BrandModel> listBrands = [];
  List<CategoryShapeModel> listBrandsShape = [];
  List<BrandModelModel> listBrandsModel = [];
  List<CategoryModel> listFuelTypes = [];

  @override
  void initState() {
    super.initState();
    // getAllActivities();
  }

  getAllActivities() async {
    listCategories = await VendorApi.fetchMerchantActivities();
    listCategories.insert(
        0, CategoryModel(id: "-1", name: "choose category".tr()));
    typeCategory = listCategories.first.id;
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
          title: Text("add_product".tr()),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  return VehicleBloc()..add(FetchCategories());
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
                  await VendorApi.addProduct(
                      context: context,
                      name: nameController.text,
                      notes: descCtrl.text,
                      galleryImagesBase64: galleryImages,
                      before_price: beforePriceCtrl.text,
                      after_price: afterPriceCtrl.text,
                      stock: stockCtrl.text,
                      status: productStatus.text,
                      brand_id: brandType,
                      model_id: modelId,
                      position: product_position.text ?? "",
                      direction: product_direction.text ?? "",
                      year: model_year.text ?? "",
                      // brand_id: typeCategory.toString(),
                      logo: imageString);

                  Navigator.pop(context);
                } catch (e) {
                  setState(() => _loading = false);
                  print(e.toString());

                  errorSnackBar(e.toString(), context);
                }
              }

              return BlocListener<VehicleBloc, VehicleState>(
                listener: (context, state) async {
                  if (state is LoadingCategoriesError) {
                    print('there is error');

                    ///Function that show snackBar
                    ///required [error] content of error and [context]
                    // errorSnackBar(state.error, context);
                  }
                  if (state is AddedVehicle) {
                    Fluttertoast.showToast(
                        msg: "success_login".tr(),
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 17,
                        toastLength: Toast.LENGTH_LONG);
                  }
                },
                child: BlocBuilder<VehicleBloc, VehicleState>(
                    builder: (context, state) {
                  if (state is CategoryLoaded) {
                    listBrands = state.listBrands;
                    listBrandsShape = state.listBrandsShape;
                    listGearBoxTypes = state.listGearBoxTypes;
                    listCategories = state.listCategories;
                    listFuelTypes = state.listFuelTypes;
                    listBrandsModel = state.listBrandsModel;

                    if (typeCategory == "0") {
                      listCategories.insert(
                          0,
                          CategoryModel(
                              id: "-1",
                              name: "choose category".tr(),
                              logo: ""));
                      typeCategory = listCategories[0].id;
                    }

                    if (brandType == "0") {
                      listBrands.insert(
                          0,
                          BrandModel(
                              id: "-1", name: "choose brand".tr(), photo: ""));
                      brandType = listBrands[0].id;
                    }
                    if (modelId == "0") {
                      listBrandsModel.insert(
                          0,
                          BrandModelModel(
                              id: "-1", model_name: "choose brand model".tr()));
                      modelId = listBrandsModel[0].id;
                    }
                  }

                  if (state is LoadedBrands) {
                    print("brands loaded");
                    listBrands = [];
                    // listBrandsModel = [];
                    listBrands = state.listBrands;
                    //
                    if (listBrands.isNotEmpty &&
                        !listBrands[0].name.contains("choose brand".tr()))
                      listBrands.insert(
                          0,
                          BrandModel(
                              id: "-1", name: "choose brand".tr(), photo: ""));
                    if (listBrands.isNotEmpty) brandType = listBrands[0].id;

                    BlocProvider.of<VehicleBloc>(context)
                        .add(FetchShapes(catId: typeCategory));
                  }

                  if (state is LoadedBrandsModel) {
                    print("LoadedBrandsModel");
                    listBrandsModel = [];
                    listBrandsModel = state.listBrandsModel;
                    listBrandsModel.insert(
                        0,
                        BrandModelModel(
                            id: "-1", model_name: "choose brand model".tr()));
                    if (listBrandsModel.isNotEmpty)
                      modelId = listBrandsModel[0].id;

                    BlocProvider.of<VehicleBloc>(context).add(FetchNothing());
                  }

                  if (state is LoadingCategories) {
                    return Container(
                      child: Center(
                          child: LoadingIndicator(
                        color: HColors.colorPrimaryDark,
                      )),
                    );
                  }
                  return ModalProgressHUD(
                    inAsyncCall: _loading,
                    progressIndicator: LoadingIndicator(
                      color: HColors.colorPrimaryDark,
                    ),
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _image != null
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
                            if (RegisterModel.shared.type_id != "9")
                              Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * .04)),
                                    side: new BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: DropdownButton<String>(
                                      value: typeCategory.toString(),
                                      underline: SizedBox(),
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      autofocus: true,
                                      iconSize: 16 * factor,
                                      isExpanded: true,
                                      elevation: 16,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(fontSize: 16 * factor),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          CategoryModel model =
                                              listCategories.firstWhere((r) =>
                                                  r.id.toString() == newValue);
                                          typeCategory = model.id;
                                          if (typeCategory != "-1") {
                                            print(
                                                "elherafyeen Loading Brands & Shapes");
                                            reInitBrands();
                                            reInitShapes();
                                            BlocProvider.of<VehicleBloc>(
                                                    context)
                                                .add(FetchBrand(
                                                    catId: typeCategory));
                                          }
                                        });
                                      },
                                      items: listCategories
                                          .map<DropdownMenuItem<String>>(
                                              (CategoryModel value) {
                                        return DropdownMenuItem<String>(
                                          value: value.id.toString(),
                                          child: Text(value.name),
                                          onTap: () {
                                            typeCategory = value.id;
                                            print(typeCategory);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  )),
                            if (RegisterModel.shared.type_id != "9")
                              listBrands != null && listBrands.length > 1
                                  ? Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(height * .04)),
                                        side: new BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: DropdownButton<String>(
                                          value: brandType.toString(),
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                          ),
                                          autofocus: true,
                                          iconSize: 16 * factor,
                                          isExpanded: true,
                                          elevation: 16,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              .copyWith(fontSize: 16 * factor),
                                          underline: SizedBox(),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              BrandModel model =
                                                  listBrands.firstWhere((r) =>
                                                      r.id.toString() ==
                                                      newValue);
                                              brandType = model.id;
                                              if (brandType != "-1") {
                                                print(
                                                    "elherafyeen Loading BrandsModels");
                                                listBrandsModel = [];
                                                listBrandsModel.insert(
                                                    0,
                                                    BrandModelModel(
                                                        id: "-1",
                                                        model_name:
                                                            "choose brand model"
                                                                .tr()));

                                                BlocProvider.of<VehicleBloc>(
                                                        context)
                                                    .add(FetchBrandModels(
                                                        brandId: brandType));
                                              }
                                            });
                                          },
                                          items: listBrands
                                              .map<DropdownMenuItem<String>>(
                                                  (BrandModel value) {
                                            return DropdownMenuItem<String>(
                                              value: value.id.toString(),
                                              child: Row(
                                                children: [
                                                  value.photo != null &&
                                                          value.photo != ""
                                                      ? ClipOval(
                                                          child: Image.network(
                                                          value.photo ?? "",
                                                          width: 30 * factor,
                                                          height: 30 * factor,
                                                        ))
                                                      : SizedBox(),
                                                  Text(value.name),
                                                ],
                                              ),
                                              onTap: () {
                                                brandType = value.id;
                                                print(brandType);

                                                if (brandType != "-1") {
                                                  print(
                                                      "elherafyeen Loading BrandsModels");
                                                }
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ))
                                  : SizedBox(),
                            if (RegisterModel.shared.type_id != "9")
                              listBrandsModel != null &&
                                      listBrandsModel.length > 1
                                  ? Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(height * .04)),
                                        side: new BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: DropdownButton<String>(
                                          value: modelId.toString(),
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                          ),
                                          autofocus: true,
                                          iconSize: 16 * factor,
                                          isExpanded: true,
                                          elevation: 16,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              .copyWith(fontSize: 16 * factor),
                                          underline: SizedBox(),
                                          onChanged: (String newValue) {
                                            BrandModelModel model =
                                                listBrandsModel.firstWhere(
                                                    (r) =>
                                                        r.id.toString() ==
                                                        newValue);
                                            modelId = model.id;
                                            setState(() {});
                                          },
                                          items: listBrandsModel
                                              .map<DropdownMenuItem<String>>(
                                                  (BrandModelModel value) {
                                            return DropdownMenuItem<String>(
                                              value: value.id.toString(),
                                              child: Text(value.model_name),
                                              onTap: () {
                                                modelId = value.id.toString();
                                                print(modelId);
                                                // setState(() {});
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ))
                                  : SizedBox(),
                            // Card(
                            //     elevation: 5,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.all(
                            //           Radius.circular(height * .04)),
                            //       side: new BorderSide(
                            //           color: Colors.grey, width: 1),
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
                            if (RegisterModel.shared.type_id != "9")
                              RoundedTextField(
                                labelText: "product_position".tr(),
                                controller: product_position,
                                onChanged: (text) {},
                                isEnabled: true,
                                focusNode: dateFocus,
                                inputType: TextInputType.text,
                              ),
                            if (RegisterModel.shared.type_id != "9")
                              RoundedTextField(
                                labelText: "product_direction".tr(),
                                controller: product_direction,
                                onChanged: (text) {},
                                isEnabled: true,
                                focusNode: dateFocus,
                                inputType: TextInputType.text,
                              ),
                            if (RegisterModel.shared.type_id != "9")
                              RoundedTextField(
                                labelText: "date".tr(),
                                controller: model_year,
                                onChanged: (text) {},
                                isEnabled: true,
                                focusNode: dateFocus,
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
                                                  Radius.circular(width * .04)),
                                              side: BorderSide(
                                                  color: Colors.grey)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: HColors.colorPrimaryDark,
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
                                                  Radius.circular(width * .02)),
                                              child: Image.file(
                                                  File(
                                                      galleryImages[index - 1]),
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
                }),
              );
            })));
  }

  reInitBrands() {
    listBrands = [];
    listBrands.insert(
        0, BrandModel(id: "-1", name: "choose brand".tr(), photo: ""));
    brandType = listBrands[0].id;
    setState(() {});
  }

  reInitShapes() {
    listBrandsShape = [];
    listBrandsShape.insert(
        0, CategoryShapeModel(id: "-1", shape_name: "choose shape".tr()));

    if (listBrandsShape.isNotEmpty) shapeId = listBrandsShape[0].id;
  }
}
