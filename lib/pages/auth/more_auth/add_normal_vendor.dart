import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/bloc/vehicle/vehicle_bloc.dart';
import 'package:elherafyeen/bloc/vendor/vendor_bloc.dart';
import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/search_model.dart';
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

import '../authentication_page.dart';

class AddNormalVendor extends StatefulWidget {
  int idOfStaff;

  AddNormalVendor({Key key, this.idOfStaff: -1}) : super(key: key);

  @override
  _AddNormalVendorState createState() => _AddNormalVendorState();
}

class _AddNormalVendorState extends State<AddNormalVendor> {
  var typeCategory = "0";
  var typeStore = "0";
  var classificationId = "0";
  var workingHoursId = "0";
  var placeTypesId = "0";
  var _loading = false;
  var addressController = TextEditingController();
  var phoneCtrl = TextEditingController();
  var whatsCtrl = TextEditingController();
  var descCtrl = TextEditingController();
  var ownerNameController = TextEditingController();
  var descController = TextEditingController();
  var idSet = <String>{};
  var idSetServices = <String>{};
  var idSetBrands = <String>{};
  File _image;
  var imageString = "";
  List<String> galleryImagesBase64 = [];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
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

  bool chooseAllBrands = false;
  bool chooseAllFields = false;
  List<CategoryModel> listCategories = [];
  List<SearchModel> vendorFields = [];
  List<CategoryModel> servicesIntroduced = [];
  List<bool> storeTypeValues = [];
  List<bool> servicesValues = [];
  List<bool> brandValues = [];
  List<String> servicesValuesStrings = [];
  List<CategoryModel> classifications = [];
  List<CategoryModel> placeTypes = [];
  List<CategoryModel> workingHours = [];
  List<BrandModel> brands = [];
  List<String> galleryImages = [];
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

    void _showBottomSheet(BuildContext context) {
      TextEditingController controllerText = new TextEditingController();
      List<CategoryModel> _searchResult = [];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            onSearchTextChanged(String text) async {
              _searchResult.clear();
              if (text.isEmpty) {
                setState(() {});
                mystate(() {});
                return;
              }

              servicesIntroduced.forEach((userDetail) {
                if (userDetail.name.contains(text))
                  _searchResult.add(userDetail);
              });

              setState(() {});
              mystate(() {});
            }

            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: height,
                color: Color.fromRGBO(0, 0, 0, 0.001),
                child: GestureDetector(
                  onTap: () {},
                  child: DraggableScrollableSheet(
                    initialChildSize: .91,
                    minChildSize: 0.9,
                    maxChildSize: 0.95,
                    builder: (_, controller) {
                      return Container(
                        height: height * .75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8 * factor,
                                  horizontal: 16 * factor),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8 * factor),
                                    child: Center(
                                      child: InkWell(
                                          onTap: () => Navigator.pop(context),
                                          child: Text("done".tr())),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                        height: 48 * factor,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.04),
                                          color: HColors.colorPrimaryDark,
                                        ),
                                        child: TextField(
                                          controller: controllerText,
                                          style: TextStyle(color: Colors.white),
                                          onChanged: onSearchTextChanged,
                                          decoration: new InputDecoration(
                                            hintText: 'Search',
                                            border: InputBorder.none,
                                            suffixIcon: new IconButton(
                                              icon: new Icon(
                                                Icons.cancel,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                controllerText.clear();
                                                onSearchTextChanged('');
                                              },
                                            ),
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            prefixIcon: new Icon(Icons.search,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            // CheckboxListTile(
                            //   title: Text(
                            //     "chooseAll".tr(),
                            //     style: TextStyle(
                            //         fontSize: 14 * factor,
                            //         color: HColors.colorPrimaryDark),
                            //   ),
                            //   value: chooseAllFields,
                            //   onChanged: (newValue) {
                            //     try {
                            //       chooseAllFields = newValue;
                            //       if (chooseAllFields) {
                            //         for (var service in servicesIntroduced) {
                            //           if (!idSetServices.contains(service.id)) {
                            //             idSetServices.add(service.id);
                            //           }
                            //         }
                            //         for (int i = 0;
                            //             i < servicesValues.length;
                            //             i++) {
                            //           servicesValues[i] = true;
                            //         }
                            //       } else {
                            //         for (var service in servicesIntroduced) {
                            //           if (idSetServices.contains(service.id)) {
                            //             idSetServices.remove(service.id);
                            //           }
                            //         }
                            //         for (int i = 0;
                            //             i < servicesValues.length;
                            //             i++) {
                            //           servicesValues[i] = false;
                            //         }
                            //       }
                            //       mystate(() {});
                            //       setState(() {});
                            //       mystate(() {});
                            //     } catch (e) {
                            //       print(e.toString());
                            //     }
                            //   },
                            //   controlAffinity: ListTileControlAffinity
                            //       .leading, //  <-- leading Checkbox
                            // ),
                            Expanded(
                              child: ListView.builder(
                                controller: controller,
                                itemCount: (_searchResult.length != 0 ||
                                        controllerText.text.isNotEmpty)
                                    ? _searchResult.length
                                    : servicesIntroduced.length,
                                itemBuilder: (_, index) {
                                  var service;
                                  if (_searchResult.length != 0 ||
                                      controllerText.text.isNotEmpty) {
                                    service = _searchResult[index];
                                  } else {
                                    service = servicesIntroduced[index];
                                  }
                                  return CheckboxListTile(
                                    title: Text(
                                      service.name,
                                      style: TextStyle(
                                          fontSize: 14 * factor,
                                          color: HColors.colorPrimaryDark),
                                    ),
                                    value: servicesValues[index],
                                    onChanged: (newValue) {
                                      servicesValues[index] = newValue;
                                      if (!idSetServices.contains(service.id)) {
                                        idSetServices.add(service.id);
                                      } else {
                                        if (newValue == false) {
                                          if (idSetServices
                                              .contains(service.id)) {
                                            idSetServices.remove(service.id);
                                          }
                                        }
                                      }
                                      setState(() {});
                                      mystate(() {});
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          });
        },
      );
    }

    void _showBrands(BuildContext context) {
      TextEditingController controllerText = new TextEditingController();
      List<BrandModel> _searchResult = [];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter newMyState) {
            onSearchTextChanged(String text) async {
              _searchResult.clear();
              if (text.isEmpty) {
                setState(() {});
                newMyState(() {});
                return;
              }

              brands.forEach((userDetail) {
                if (userDetail.name.contains(text))
                  _searchResult.add(userDetail);
              });

              setState(() {});
              newMyState(() {});
            }

            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: height,
                color: Color.fromRGBO(0, 0, 0, 0.001),
                child: GestureDetector(
                  onTap: () {},
                  child: DraggableScrollableSheet(
                    initialChildSize: .91,
                    minChildSize: 0.9,
                    maxChildSize: 0.95,
                    builder: (_, controller) {
                      return Container(
                        height: height * .75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8 * factor,
                                  horizontal: 16 * factor),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8 * factor),
                                    child: Center(
                                      child: InkWell(
                                          onTap: () => Navigator.pop(context),
                                          child: Text("done".tr())),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                        height: 48 * factor,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.04),
                                          color: HColors.colorPrimaryDark,
                                        ),
                                        child: TextField(
                                          controller: controllerText,
                                          style: TextStyle(color: Colors.white),
                                          onChanged: onSearchTextChanged,
                                          decoration: new InputDecoration(
                                            hintText: 'Search',
                                            border: InputBorder.none,
                                            suffixIcon: new IconButton(
                                              icon: new Icon(
                                                Icons.cancel,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                controllerText.clear();
                                                onSearchTextChanged('');
                                              },
                                            ),
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            prefixIcon: new Icon(Icons.search,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                "chooseAll".tr(),
                                style: TextStyle(
                                    fontSize: 14 * factor,
                                    color: HColors.colorPrimaryDark),
                              ),
                              value: chooseAllBrands,
                              onChanged: (newValue) {
                                try {
                                  print("must change");
                                  chooseAllBrands = newValue;
                                  if (chooseAllBrands) {
                                    for (var brand in brands) {
                                      if (!idSetBrands.contains(brand.id)) {
                                        idSetBrands.add(brand.id);
                                      }
                                    }
                                    for (int i = 0;
                                        i < brandValues.length;
                                        i++) {
                                      brandValues[i] = true;
                                    }
                                  } else {
                                    for (var brand in brands) {
                                      if (idSetBrands.contains(brand.id)) {
                                        idSetBrands.remove(brand.id);
                                      }
                                    }
                                    for (int i = 0;
                                        i < brandValues.length;
                                        i++) {
                                      brandValues[i] = false;
                                    }
                                  }
                                  newMyState(() {});
                                  setState(() {});
                                  newMyState(() {});
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: controller,
                                itemCount: (_searchResult.length != 0 ||
                                        controllerText.text.isNotEmpty)
                                    ? _searchResult.length
                                    : brands.length,
                                itemBuilder: (_, index) {
                                  BrandModel brand;
                                  if (_searchResult.length != 0 ||
                                      controllerText.text.isNotEmpty) {
                                    brand = _searchResult[index];
                                  } else {
                                    brand = brands[index];
                                  }
                                  return CheckboxListTile(
                                    title: Row(
                                      children: [
                                        ClipOval(
                                            child: Image.network(
                                          brand.photo,
                                          width: 55 * factor,
                                          height: 55 * factor,
                                        )),
                                        Text(
                                          brand.name,
                                          style: TextStyle(
                                              fontSize: 14 * factor,
                                              color: HColors.colorPrimaryDark),
                                        ),
                                      ],
                                    ),
                                    value: brandValues[index],
                                    onChanged: (newValue) {
                                      try {
                                        print("must change");
                                        brandValues[index] = newValue;
                                        if (!idSetBrands.contains(brand.id)) {
                                          idSetBrands.add(brand.id);
                                        } else {
                                          if (newValue == false) {
                                            if (idSetBrands
                                                .contains(brand.id)) {
                                              idSetBrands.remove(brand.id);
                                            }
                                          }
                                        }
                                        newMyState(() {});
                                        setState(() {});
                                        newMyState(() {});
                                      } catch (e) {
                                        print("mahmoud " + e.toString());
                                      }
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          });
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("addNormalVendor".tr()),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  return VendorBloc()..add(LoadingEvents());
                },
              ),
            ],
            child: Builder(builder: (context) {
              _addVehicleButtonPressed() async {
                await getCurrentLocation();
                List<String> provied = [];
                for (var d in idSetServices) {
                  provied.add(d);
                }

                List<String> fields = [];
                for (var d in idSet) {
                  fields.add(d);
                }
                List<String> brands = [];
                for (var d in idSetBrands) {
                  brands.add(d);
                }
                setState(() => _loading = true);
                BlocProvider.of<VendorBloc>(context).add(
                  AddVendor(
                      context: context,
                      idOfStaff: widget.idOfStaff,
                      address: addressController.text,
                      working_hours: workingHoursId,
                      classification_id: classificationId,
                      owner_name: ownerNameController.text,
                      place_type_id: placeTypesId,
                      desc: descController.text,
                      logo: imageString,
                      providedServices: provied,
                      phone: phoneCtrl.text,
                      name: descCtrl.text,
                      whats: whatsCtrl.text,
                      brands: brands,
                      fields: fields,
                      categoryId: typeCategory,
                      lat: latitude.toString(),
                      lng: longitude.toString(),
                      galleryImagesBase64: galleryImagesBase64),
                );
              }

              return BlocListener<VendorBloc, VendorState>(
                listener: (context, state) async {
                  if (state is ErrorVendor) {
                    print('there is error');
                    setState(() => _loading = false);

                    ///Function that show snackBar
                    ///required [error] content of error and [context]
                    errorSnackBar(state.error, context);
                  }
                  if (state is VendorAdded) {
                    setState(() => _loading = false);
                    if (state.result) {
                      if (widget.idOfStaff != -1) {
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                                builder: (_) => TabBarPage(currentIndex: 0)),
                            (route) => false);
                      } else {
                        Fluttertoast.showToast(
                            msg: "success_login".tr(),
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 17,
                            toastLength: Toast.LENGTH_LONG);

                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                                builder: (_) => AuthenticationPage()),
                            (route) => false);
                      }
                    }
                  }
                },
                child: BlocBuilder<VendorBloc, VendorState>(
                    builder: (context, state) {
                  if (state is DataLoadded) {
                    listCategories = state.categories;
                    vendorFields = state.vendorFields;
                    servicesIntroduced = state.servicesIntroduced;
                    classifications = state.classifications;
                    workingHours = state.workingHours;
                    placeTypes = state.placeTypes;
                    brands = state.brands;

                    if (typeCategory == "0") {
                      listCategories.insert(0,
                          CategoryModel(id: "-1", name: "classification".tr()));
                      typeCategory = listCategories[0].id;
                    }
                    if (typeStore == "0") {
                      for (var i in vendorFields) {
                        storeTypeValues.add(false);
                      }
                      for (var i in servicesIntroduced) {
                        servicesValues.add(false);
                      }
                      for (var i in brands) {
                        brandValues.add(false);
                      }
                    }

                    if (workingHoursId == "0") {
                      workingHours.insert(0,
                          CategoryModel(id: "-1", name: "workingHours".tr()));
                      workingHoursId = workingHours[0].id;
                    }
                    if (classificationId == "0") {
                      classifications.insert(
                          0, CategoryModel(id: "-1", name: "centerSize".tr()));
                      classificationId = classifications[0].id;
                    }
                    if (placeTypesId == "0") {
                      placeTypes.insert(
                          0, CategoryModel(id: "-1", name: "serviceType".tr()));
                      placeTypesId = placeTypes[0].id;
                    }
                  }

                  if (state is BrandsLoaded) {
                    brands = state.brands;
                    idSetBrands.clear();
                    brandValues.clear();
                    for (var i in brands) {
                      brandValues.add(false);
                    }

                    BlocProvider.of<VendorBloc>(context).add(DoNothing());
                  }

                  if (state is LoadingVendor) {
                    return Container(
                      child: Center(
                          child: LoadingIndicator(
                        color: HColors.colorPrimaryDark,
                      )),
                    );
                  }

                  return ModalProgressHUD(
                      inAsyncCall: _loading,
                      color: Colors.white,
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
                                    title: "VendorPhoto".tr(),
                                    onTap: () {
                                      ImagePickerWidget(
                                          context: context,
                                          onTap: (value) {
                                            getImage(value);
                                          });
                                    }),
                            RoundedTextField(
                              labelText: "centerName".tr(),
                              controller: descController,
                              onChanged: (text) {},
                              isEnabled: true,
                              // focusNode: dateFocus,
                              inputType: TextInputType.text,
                            ),
                            Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(height * .04)),
                                  side: new BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                          BlocProvider.of<VendorBloc>(context)
                                              .add(LoadingBrands(
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
                                          if (typeCategory != "-1") {
                                            BlocProvider.of<VendorBloc>(context)
                                                .add(LoadingBrands(
                                                    catId: typeCategory));
                                          }
                                          setState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )),
                            InkWell(
                                onTap: () => _showBrands(context),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * .04)),
                                    side: new BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              idSetBrands.length != 0
                                                  ? idSetBrands.length
                                                          .toString() +
                                                      "Choosed".tr()
                                                  : "brands".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3
                                                  .copyWith(
                                                      fontSize: 16 * factor)),
                                        ),
                                        Icon(
                                          idSetBrands.length != 0
                                              ? Icons.check
                                              : Icons.keyboard_arrow_down,
                                          color: idSetBrands.length != 0
                                              ? Colors.green
                                              : Colors.grey.shade600,
                                          size: 16 * factor,
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            classifications != null
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
                                        value: classificationId.toString(),
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
                                                classifications.firstWhere(
                                                    (r) =>
                                                        r.id.toString() ==
                                                        newValue);
                                            classificationId = model.id;
                                          });
                                        },
                                        items: classifications
                                            .map<DropdownMenuItem<String>>(
                                                (CategoryModel value) {
                                          return DropdownMenuItem<String>(
                                            value: value.id.toString(),
                                            child: Text(value.name),
                                            onTap: () {
                                              classificationId = value.id;
                                              print(classificationId);
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
                                      Radius.circular(height * .04)),
                                  side: new BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: DropdownButton<String>(
                                    value: placeTypesId.toString(),
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
                                            placeTypes.firstWhere((r) =>
                                                r.id.toString() == newValue);
                                        placeTypesId = model.id;
                                      });
                                    },
                                    items: placeTypes
                                        .map<DropdownMenuItem<String>>(
                                            (CategoryModel value) {
                                      return DropdownMenuItem<String>(
                                        value: value.id.toString(),
                                        child: Text(value.name),
                                        onTap: () {
                                          placeTypesId = value.id;
                                          print(placeTypesId);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )),
                            InkWell(
                                onTap: () => _showBottomSheet(context),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * .04)),
                                    side: new BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              idSetServices.length != 0
                                                  ? idSetServices.length
                                                          .toString() +
                                                      "Choosed".tr()
                                                  : "services".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3
                                                  .copyWith(
                                                      fontSize: 16 * factor)),
                                        ),
                                        Icon(
                                          idSetServices.length != 0
                                              ? Icons.check
                                              : Icons.keyboard_arrow_down,
                                          color: idSetServices.length != 0
                                              ? Colors.green
                                              : Colors.grey.shade600,
                                          size: 16 * factor,
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: vendorFields.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckboxListTile(
                                  title: Text(
                                    vendorFields[index].field_name,
                                    style: TextStyle(
                                        fontSize: 14 * factor,
                                        color: HColors.colorPrimaryDark),
                                  ),
                                  value: storeTypeValues[index],
                                  onChanged: (newValue) {
                                    setState(() {
                                      storeTypeValues[index] = newValue;
                                      if (newValue) {
                                        if (!idSet
                                            .contains(vendorFields[index].id)) {
                                          idSet.add(vendorFields[index].id);
                                        }
                                      } else {
                                        if (idSet
                                            .contains(vendorFields[index].id)) {
                                          idSet.remove(vendorFields[index].id);
                                        }
                                      }
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                );
                              },
                            ),
                            RoundedTextField(
                              labelText: "owner_name".tr(),
                              controller: ownerNameController,
                              onChanged: (text) {},
                              // focusNode: manualFocus,
                              inputType: TextInputType.text,
                            ),
                            RoundedTextField(
                              labelText: "company_address".tr(),
                              controller: addressController,
                              onChanged: (text) {},
                              isEnabled: true,
                              // focusNode: capacityFocus,
                              inputType: TextInputType.text,
                            ),
                            widget.idOfStaff == -1
                                ? SizedBox()
                                : RoundedTextField(
                                    labelText: "company_phone".tr(),
                                    controller: phoneCtrl,
                                    onChanged: (text) {},
                                    isEnabled: true,
                                    // focusNode: capacityFocus,
                                    inputType: TextInputType.phone,
                                  ),
                            widget.idOfStaff == -1
                                ? SizedBox()
                                : RoundedTextField(
                                    labelText: "whatsapp".tr(),
                                    controller: whatsCtrl,
                                    onChanged: (text) {},
                                    isEnabled: true,
                                    // focusNode: capacityFocus,
                                    inputType: TextInputType.phone,
                                  ),
                            widget.idOfStaff == -1
                                ? SizedBox()
                                : RoundedTextField(
                                    labelText: "company_desc".tr(),
                                    controller: descCtrl,
                                    onChanged: (text) {},
                                    isEnabled: true,
                                    // focusNode: capacityFocus,
                                    inputType: TextInputType.text,
                                  ),
                            Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(height * .04)),
                                  side: new BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: DropdownButton<String>(
                                    value: workingHoursId.toString(),
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
                                            workingHours.firstWhere((r) =>
                                                r.id.toString() == newValue);
                                        workingHoursId = model.id;
                                      });
                                    },
                                    items: workingHours
                                        .map<DropdownMenuItem<String>>(
                                            (CategoryModel value) {
                                      return DropdownMenuItem<String>(
                                        value: value.id.toString(),
                                        child: Text(value.name),
                                        onTap: () {
                                          workingHoursId = value.id;
                                          print(workingHoursId);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )),
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
                            SizedBox(height: 6 * factor),
                            ButtonTheme(
                              minWidth: width * .85,
                              height: height * 0.08,
                              child: RaisedButton(
                                  color: HColors.colorSecondary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(height * .03))),
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
                      ));
                }),
              );
            })));
  }
}
