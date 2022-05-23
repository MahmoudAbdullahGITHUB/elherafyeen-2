import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/bloc/vendor/vendor_bloc.dart';
import 'package:elherafyeen/models/category_model.dart';
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

class AddMarchantPage extends StatefulWidget {
  bool staff;
  bool medical;

  AddMarchantPage({Key key, this.staff: false, this.medical: false})
      : super(key: key);

  @override
  _AddMarchantPageState createState() => _AddMarchantPageState();
}

class _AddMarchantPageState extends State<AddMarchantPage> {
  var typeCategory = "0";
  var typeMarchant = "0";
  List<String> galleryImagesBase64 = [];

  var nameController = TextEditingController();
  var directorNameController = TextEditingController();
  var descCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();
  var whatsCtrl = TextEditingController();
  var governateCtrl = TextEditingController();
  var addressCtrl = TextEditingController();
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

  File _image;
  var imageString = "";
  final picker = ImagePicker();

  var _loading = false;

  @override
  void initState() {
    super.initState();
    getAllActivities();
  }

  getAllActivities() async {
    listCategories =
        await VendorApi.fetchMerchantActivities(isMedical: widget.medical);
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
          title: Text(widget.medical
              ? "medical_educational".tr()
              : "online_dealers".tr()),
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
                List<String> provied = [];
                provied.add(typeCategory);

                setState(() => _loading = true);
                try {
                  await VendorApi.addMarchant(
                      context: context,
                      galleryImagesBase64: galleryImagesBase64,
                      staff: widget.staff ?? false,
                      name: nameController.text,
                      desc: descCtrl.text,
                      phone: phoneCtrl.text,
                      ownerName: directorNameController.text,
                      whatsapp: whatsCtrl.text,
                      governate: "",
                      lat: latitude.toString(),
                      lng: longitude.toString(),
                      providedServices: provied,
                      address: addressCtrl.text,
                      logo: imageString);

                  if (widget.staff) {
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
                } catch (e) {
                  setState(() => _loading = false);
                  print(e.toString());

                  errorSnackBar(e.toString(), context);
                }
              }

              return (listCategories.isEmpty)
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
                              RoundedTextField(
                                labelText: "directorName".tr(),
                                controller: directorNameController,
                                onChanged: (text) {},
                                // focusNode: manualFocus,
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
                                              BlocProvider.of<VendorBloc>(
                                                      context)
                                                  .add(LoadingBrands(
                                                      catId: typeCategory));
                                            }
                                            setState(() {});
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  )),
                              RoundedTextField(
                                labelText: "service_desc".tr(),
                                controller: descCtrl,
                                onChanged: (text) {},
                                isEnabled: true,
                                // focusNode: dateFocus,
                                inputType: TextInputType.text,
                              ),
                              if (widget.staff)
                                RoundedTextField(
                                  labelText: "phone".tr(),
                                  controller: phoneCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: dateFocus,
                                  inputType: TextInputType.phone,
                                ),
                              RoundedTextField(
                                labelText: "whatsapp".tr(),
                                controller: whatsCtrl,
                                onChanged: (text) {},
                                isEnabled: true,
                                // focusNode: dateFocus,
                                inputType: TextInputType.phone,
                              ),
                              RoundedTextField(
                                labelText: "addressName".tr(),
                                controller: addressCtrl,
                                onChanged: (text) {},
                                isEnabled: true,
                                // focusNode: colorFocus,
                                inputType: TextInputType.text,
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
