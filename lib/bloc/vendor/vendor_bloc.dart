import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:elherafyeen/api/vehicle_api.dart';
import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/search_model.dart';
import 'package:elherafyeen/models/store_type_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'vendor_event.dart';

part 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  VendorBloc({VendorState initialState}) : super(initialState);
  List<CategoryModel> categories = [];
  var brands = [];
  List<CategoryModel> servicesIntroduced = [];
  List<SearchModel> vendorFields = [];
  List<CategoryModel> classifications = [];
  List<CategoryModel> placeTypes = [];
  List<CategoryModel> workingHours = [];

  @override
  VendorState get initialState => InitialVendorState();

  @override
  Stream<VendorState> mapEventToState(VendorEvent event) async* {
    if (event is LoadingEvents) {
      yield LoadingVendor();
      try {
        var response = await VendorApi.fetchVendorServices();
        final body = json.decode(response.body);
        if (body != null) {
          categories = List<CategoryModel>.from(body['result']['categories']
              .map((data) => CategoryModel.fromMap(data)));
          if (categories.isNotEmpty)
            brands = await VehicleApi.fetchBrands(categoryId: categories[0].id);

          vendorFields = List<SearchModel>.from(body['result']['fields']
              .map((data) => SearchModel.fromMap(data)));

          classifications = List<CategoryModel>.from(body['result']
                  ['classifications']
              .map((data) => CategoryModel.fromMap(data)));

          placeTypes = List<CategoryModel>.from(body['result']['placeTypes']
              .map((data) => CategoryModel.fromMap(data)));

          workingHours = List<CategoryModel>.from(body['result']['workingHours']
              .map((data) => CategoryModel.fromMap(data)));
          servicesIntroduced = List<CategoryModel>.from(body['result']
                  ['services']
              .map((data) => CategoryModel.fromMap(data)));
        }
        yield DataLoadded(
            vendorFields: vendorFields,
            categories: categories,
            brands: brands,
            servicesIntroduced: servicesIntroduced,
            classifications: classifications,
            placeTypes: placeTypes,
            workingHours: workingHours);
      } catch (e) {
        print("mahmoud" + e.toString());
        yield ErrorVendor(error: e.toString());
      }
    }
    if (event is LoadingEventsForMarket) {
      yield LoadingVendor();
      try {
        var toolTypes = await VendorApi.fetchStoreToolsTypes();
        var categories = await VehicleApi.fetchCategories();
        yield DataLoaddedMarket(storeTypes: toolTypes, categories: categories);
      } catch (e) {
        yield ErrorVendor(error: e.toString());
      }
    }
    if (event is LoadingBrands) {
      // yield LoadingVendor();
      try {
        var brands = await VehicleApi.fetchBrands(categoryId: event.catId);
        yield BrandsLoaded(brands: brands);
      } catch (e) {
        yield ErrorVendor(error: e.toString());
      }
    }
    if (event is DoNothing) {
      yield LoadNothing();
    }

    if (event is AddVendor) {
      // yield LoadingVendor();
      try {
        var result = await VendorApi.addVendor(
            context: event.context,
            categoryId: event.categoryId,
            idOfStaff: event.idOfStaff,
            whats: event.whats,
            classification_id: event.classification_id,
            place_type_id: event.place_type_id,
            working_hours: event.working_hours,
            owner_name: event.owner_name,
            galleryImagesBase64: event.galleryImagesBase64,
            lat: event.lat,
            lng: event.lng,
            name: event.name,
            phone: event.phone,
            brands: event.brands,
            fields: event.fields,
            providedServices: event.providedServices,
            logo: event.logo,
            address: event.address,
            desc: event.desc);
        yield VendorAdded(result: result);
      } catch (e) {
        yield ErrorVendor(error: e.toString());
      }
    }
  }
}
