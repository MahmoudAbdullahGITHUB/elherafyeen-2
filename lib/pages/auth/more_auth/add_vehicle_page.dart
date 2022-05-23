import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/bloc/vehicle/vehicle_bloc.dart';
import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/brand_model_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/category_shape_model.dart';
import 'package:elherafyeen/pages/home/home_page.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
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

import '../authentication_page.dart';

class AddVehiclePage extends StatefulWidget {
  AddVehiclePage({Key key}) : super(key: key);

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  var typeCategory = "0";
  var typeGearBox = "0";
  var brandType = "0";
  var shapeId = "0";
  var manualController = TextEditingController();
  var fuelId = "0";
  var colorController = TextEditingController();
  var modelId = "0";
  var dateOfCreationController = TextEditingController();
  var capacityController = TextEditingController();

  FocusNode colorFocus = FocusNode();
  FocusNode modelFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode capacityFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode brandFocus = FocusNode();
  FocusNode shapeFocus = FocusNode();
  FocusNode manualFocus = FocusNode();
  FocusNode fuelFocus = FocusNode();

  File _image;
  var imageString = "";
  final picker = ImagePicker();

  Future getImage(bool gallery) async {
    final pickedFile = await picker.getImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _image = await CropImageMethod(image: _image);
      setState(() async {
        List<int> imageBytes = _image.readAsBytesSync();
        print(imageBytes);
        final bytes = await _image.readAsBytes();
        imageString = base64Encode(bytes);
        print(imageString);
      });
      print(imageString);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  List<CategoryModel> listCategories = [];
  List<CategoryModel> listGearBoxTypes = [];
  List<BrandModel> listBrands = [];
  List<CategoryShapeModel> listBrandsShape = [];
  List<BrandModelModel> listBrandsModel = [];
  List<CategoryModel> listFuelTypes = [];
  double latitude = 0.0;
  double longitude = 0.0;
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
          // backgroundColor: Colors.red,
          title: Text("addVehicle".tr()),
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
                // await getCurrentLocation();
                shapeId == '-1' ? shapeId = '' : shapeId = shapeId;
                modelId == '-1' ? modelId = '' : modelId = modelId;

                BlocProvider.of<VehicleBloc>(context).add(
                  AddVehicle(
                    gearBoxId: typeGearBox,
                    manufacturingYear: dateOfCreationController.text,
                    image: imageString,
                    lat: latitude.toString(),
                    lng: longitude.toString(),
                    modelId: modelId,
                    categoryId: typeCategory,
                    fuelTypeId: fuelId,
                    brandId: brandType,
                    cc: capacityController.text,
                    color: colorController.text,
                    shapeId: shapeId,
                  ),
                );
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
                    //TODO
                    // Fluttertoast.showToast(
                    //     msg: "success_login".tr(),
                    //     backgroundColor: Colors.green,
                    //     textColor: Colors.white,
                    //     fontSize: 17,
                    //     toastLength: Toast.LENGTH_LONG);

                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (_) => TabBarPage(currentIndex: 0,)),
                        (route) => false);
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
                    if (typeGearBox == "0") {
                      listGearBoxTypes.insert(
                          0,
                          CategoryModel(
                              id: "-1", name: "choose gearBox".tr(), logo: ""));
                      typeGearBox = listCategories[0].id;
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
                    if (shapeId == "0") {
                      listBrandsShape.insert(
                          0,
                          CategoryShapeModel(
                              id: "-1", shape_name: "choose shape".tr()));
                      shapeId = listBrandsShape[0].id;
                    }
                    if (fuelId == "0") {
                      listFuelTypes.insert(
                          0, CategoryModel(id: "-1", name: "fuel type".tr()));
                      fuelId = listFuelTypes[0].id;
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

                    // listBrandsModel = [];
                    // if (listBrandsModel.isNotEmpty &&
                    //     !listBrandsModel[0]
                    //         .model_name
                    //         .contains("choose brand model".tr()))
                    //   listBrandsModel.insert(
                    //       0,
                    //       BrandModelModel(
                    //           id: "-1", model_name: "choose brand model".tr()));
                    // if (listBrandsModel.isNotEmpty)
                    //   modelId = listBrandsModel[0].id;
                    //
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

                  if (state is LoadedBrandsShape) {
                    print("LoadedBrandsModel");
                    reInitShapes();
                    listBrandsShape.addAll(state.listBrandsShape);
                    print(listBrandsShape.toString());
                  }

                  if (state is LoadingCategories) {
                    return Container(
                      child: Center(
                          child: LoadingIndicator(
                        color: HColors.colorPrimaryDark,
                      )),
                    );
                  }
                  return SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Column(
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
                                  : AddImageWidget(onTap: () {
                                      ImagePickerWidget(
                                          context: context,
                                          onTap: (value) {
                                            getImage(value);
                                          });
                                    }),
                              Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * .01)),
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
                              listBrands != null && listBrands.length > 1
                                  ? Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(height * .01)),
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
                              listBrandsModel != null &&
                                      listBrandsModel.length > 1
                                  ? Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(height * .01)),
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
                              listBrandsShape != null &&
                                      listBrandsShape.length > 1
                                  ? Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(height * .01)),
                                        side: new BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: DropdownButton<String>(
                                          value: shapeId.toString(),
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
                                              CategoryShapeModel model =
                                                  listBrandsShape.firstWhere(
                                                      (r) =>
                                                          r.id.toString() ==
                                                          newValue);
                                              shapeId = model.id;
                                            });
                                          },
                                          items: listBrandsShape
                                              .map<DropdownMenuItem<String>>(
                                                  (CategoryShapeModel value) {
                                            return DropdownMenuItem<String>(
                                              value: value.id.toString(),
                                              child: Text(value.shape_name),
                                              onTap: () {
                                                shapeId = value.id;
                                                print(shapeId);
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ))
                                  : SizedBox(),
                              Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * .01)),
                                    side: new BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: DropdownButton<String>(
                                      value: typeGearBox.toString(),
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
                                          CategoryModel model =
                                              listGearBoxTypes.firstWhere((r) =>
                                                  r.id.toString() == newValue);
                                          typeGearBox = model.id;
                                        });
                                      },
                                      items: listGearBoxTypes
                                          .map<DropdownMenuItem<String>>(
                                              (CategoryModel value) {
                                        return DropdownMenuItem<String>(
                                          value: value.id.toString(),
                                          child: Text(value.name),
                                          onTap: () {
                                            typeGearBox = value.id;
                                            print(typeGearBox);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  )),
                              Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * .01)),
                                    side: new BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: DropdownButton<String>(
                                      value: fuelId.toString(),
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
                                          CategoryModel model =
                                          listFuelTypes.firstWhere((r) =>
                                          r.id.toString() == newValue);
                                          fuelId = model.id;
                                        });
                                      },
                                      items: listFuelTypes
                                          .map<DropdownMenuItem<String>>(
                                              (CategoryModel value) {
                                            return DropdownMenuItem<String>(
                                              value: value.id.toString(),
                                              child: Text(value.name),
                                              onTap: () {
                                                fuelId = value.id;
                                                print(fuelId);
                                              },
                                            );
                                          }).toList(),
                                    ),
                                  )),
                              RoundedTextField(
                                labelText: "capacity".tr(),
                                controller: capacityController,
                                onChanged: (text) {},
                                isEnabled: true,
                                focusNode: capacityFocus,
                                inputType: TextInputType.number,
                              ),
                              RoundedTextField(
                                labelText: "date".tr(),
                                controller: dateOfCreationController,
                                onChanged: (text) {},
                                isEnabled: true,
                                focusNode: dateFocus,
                                inputType: TextInputType.number,
                              ),
                              RoundedTextField(
                                labelText: "color".tr(),
                                controller: colorController,
                                onChanged: (text) {},
                                isEnabled: true,
                                focusNode: colorFocus,
                                inputType: TextInputType.text,
                              ),
                              SizedBox(height: 6 * factor),
                              ButtonTheme(
                                minWidth: width * .85,
                                height: height * 0.08,
                                child: RaisedButton(
                                    color: HColors.colorSecondary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(height * .02))),
                                    child: state is! LoadingAddVehicle
                                        ? Text(
                                            "ok".tr(),
                                            style: TextStyle(
                                                color: HColors.colorButton),
                                          )
                                        : CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                HColors.colorButton),
                                            strokeWidth: .6),
                                    onPressed: () {
                                      _addVehicleButtonPressed();
                                    }),
                              )
                            ],
                          ),
                        ],
                      ));
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
