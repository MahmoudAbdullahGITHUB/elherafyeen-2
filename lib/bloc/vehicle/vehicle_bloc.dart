import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:elherafyeen/api/vehicle_api.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:meta/meta.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc({VehicleState initialState}) : super(initialState);
  List<CategoryModel> listCategories = [];
  List<CategoryModel> listGearBoxTypes = [];
  var listBrands = [];
  var listBrandsShape = [];
  var listBrandsModel = [];
  var listFuelTypes = [];

  @override
  VehicleState get initialState => InitialVehicleState();

  @override
  Stream<VehicleState> mapEventToState(VehicleEvent event) async* {
    if (event is FetchCategories) {
      yield LoadingCategories();
      try {
        var response = await VehicleApi.fetchVehicleServices();

        final body = json.decode(response.body);

        listCategories = List<CategoryModel>.from(body['result']['categories']
            .map((data) => CategoryModel.fromMap(data)));

        listFuelTypes = List<CategoryModel>.from(body['result']['fuelTypes']
            .map((data) => CategoryModel.fromMap(data)));
        listGearBoxTypes = List<CategoryModel>.from(body['result']
                ['gearBoxTypes']
            .map((data) => CategoryModel.fromMap(data)));

        if (listCategories != null && listCategories.length != 0) {
          var catId = listCategories[0].id;
          listBrands = await VehicleApi.fetchBrands(categoryId: catId);
          listBrandsShape = await VehicleApi.fetchBrandShapes(catId: catId);
          listBrandsModel =
              await VehicleApi.fetchBrandModel(brandId: listBrands[0].id);
        }
        yield CategoryLoaded(
            listBrands: listBrands,
            listBrandsModel: listBrandsModel,
            listBrandsShape: listBrandsShape,
            listCategories: listCategories,
            listGearBoxTypes: listGearBoxTypes,
            listFuelTypes: listFuelTypes);
      } catch (e) {
        yield LoadingCategoriesError(error: e.toString());
      }
    } else if (event is FetchBrand) {
      try {
        listBrands = await VehicleApi.fetchBrands(categoryId: event.catId);
        yield LoadedBrands(listBrands: listBrands);
      } catch (e) {
        // yield LoadingCategoriesError(error: e.toString());
        listBrands = [];
        yield CategoryLoaded(
            listBrands: listBrands,
            listBrandsModel: listBrandsModel,
            listBrandsShape: listBrandsShape,
            listCategories: listCategories,
            listGearBoxTypes: listGearBoxTypes,
            listFuelTypes: listFuelTypes);
      }
    } else if (event is FetchBrandModels) {
      try {
        listBrandsModel =
            await VehicleApi.fetchBrandModel(brandId: event.brandId);
        yield LoadedBrandsModel(listBrandsModel: listBrandsModel);
      } catch (e) {
        listBrandsModel = [];
        yield CategoryLoaded(
            listBrands: listBrands,
            listBrandsModel: listBrandsModel,
            listBrandsShape: listBrandsShape,
            listCategories: listCategories,
            listGearBoxTypes: listGearBoxTypes,
            listFuelTypes: listFuelTypes);
      }
    } else if (event is FetchShapes) {
      try {
        listBrandsShape = await VehicleApi.fetchBrandShapes(catId: event.catId);
        yield LoadedBrandsShape(listBrandsShape: listBrandsShape);
      } catch (e) {
        print("mahmoud" + "1" + e.toString());
        // yield LoadingCategoriesError(error: e.toString());
        listBrandsShape = [];
        yield CategoryLoaded(
            listBrands: listBrands,
            listBrandsModel: listBrandsModel,
            listBrandsShape: listBrandsShape,
            listCategories: listCategories,
            listGearBoxTypes: listGearBoxTypes,
            listFuelTypes: listFuelTypes);
      }
    } else if (event is FetchNothing) {
      yield LoadedNothing();
    }
    if (event is AddVehicle) {
      try {
        yield LoadingAddVehicle();
        var result = await VehicleApi.addVehicle(
          gearBoxId: event.gearBoxId,
          manufacturingYear: event.manufacturingYear,
          image: event.image,
          lat: event.lat,
          lng: event.lng,
          modelId: event.modelId,
          categoryId: event.categoryId,
          fuelTypeId: event.fuelTypeId,
          brandId: event.brandId,
          cc: event.cc,
          color: event.color,
          shapeId: event.shapeId,
        );
        yield AddedVehicle(result: result);
      } catch (e) {
        yield LoadingCategoriesError(error: e.toString());
      }
    }
  }
}
