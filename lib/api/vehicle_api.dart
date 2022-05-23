import 'dart:convert';

import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/brand_model_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/category_shape_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vehicle_model.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:http/http.dart' as http;

class VehicleApi {
  static final _url = Strings.apiLink;

  static Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(
        _url + "getVehicleCategories?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CategoryModel>.from(
          body['result'].map((data) => CategoryModel.fromMap(data)));
    }
  }

  static Future<List<CategoryModel>> fetchFuelTypes() async {
    final response = await http.get(
        Uri.parse(_url + "getFuelTypes?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CategoryModel>.from(
          body['result'].map((data) => CategoryModel.fromMap(data)));
    }
  }

  static Future<List<BrandModel>> fetchBrands({String categoryId}) async {
    final response = await http.get(Uri.parse(_url +
        "getCategoryBrands?category_id=$categoryId&lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<BrandModel>.from(
          body['result'].map((brand) => BrandModel.fromMap(brand)));
    }
  }

  static Future<List<BrandModelModel>> fetchBrandModel({String brandId}) async {
    final response = await http.get(Uri.parse(_url +
        "getBrandModels?brand_id=$brandId&lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<BrandModelModel>.from(
          body['result'].map((brand) => BrandModelModel.fromMap(brand)));
    }
  }

  static Future<List<CategoryShapeModel>> fetchBrandShapes(
      {String catId}) async {
    final response = await http.get(Uri.parse(_url +
        "getCategoryShapes?category_id=$catId&lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CategoryShapeModel>.from(
          body['result'].map((brand) => CategoryShapeModel.fromMap(brand)));
    }
  }

  static Future<List<VehicleModel>> fetchUserVehicles() async {
    final response = await http.get(
        Uri.parse(_url + "getMyVehiclesList?lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<VehicleModel>.from(body['result']['vehicles']
          .map((brand) => VehicleModel.fromJson(brand)));
    }
  }

  static Future<http.Response> fetchVehicleServices() async {
    final response = await http.get(Uri.parse(
        _url + "getAddVehiclePageServices?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return response;
      // List<CategoryModel>.from(
      //   body['result'].map((brand) => CategoryModel.fromMap(brand)));
    }
  }

  static Future<bool> addVehicle({
    String categoryId,
    String brandId,
    String modelId,
    String lat,
    String lng,
    String shapeId,
    String gearBoxId,
    String fuelTypeId,
    String cc,
    String manufacturingYear,
    String color,
    String image,
  }) async {
    final response = await http.post(
        Uri.parse(_url + "addVehicle?lang=${RegisterModel.shared.lang}"),
        body: {
          'category_id': categoryId,
          'brand_id': brandId,
          "lat": lat,
          "lng": lng,
          'model_id': modelId,
          'shape_id': shapeId,
          'gear_box_id': gearBoxId,
          "fuel_type_id": fuelTypeId,
          "cc": "12",
          "manufacturing_year": manufacturingYear,
          "color": color,
          "image": "data:image/jpeg;base64," + image,
        },
        headers: {
          "Authorization": "Bearer " + RegisterModel.shared.token,
          "Accept": "application/json"
        });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }
}
