import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/vehicle_model.dart';
import 'package:flutter/cupertino.dart';

class VendorModel {
  var key;
  String id;
  int qty;
  String category_id;
  String subscriber_name;
  String subscriber_phone;
  String receipt_number;
  String event_name;
  String pos_sub_id;
  String userId;
  String city;
  String lat;
  String lng;
  String price_before;
  String price_after;
  String maximum_load_limit;
  String shipping_type_name;
  String name;
  String title;
  String stock;
  String phone;
  String whatsapp;
  List<ReviewModel> reviews;
  dynamic activatedAt;
  String logo;
  String createdAt;
  dynamic servicedBy;
  dynamic subId;
  String typeId;
  String vehicle_type;
  String description;
  String status;
  String job_field_name;
  String service_desc;
  String experience_years;
  String discount;
  String roleId;
  String distance;
  bool isActive;
  String color;
  String address;
  String phone2;
  String date_to;
  String owner_name;
  String working_hours_name;
  String place_id;
  String classification_id;
  String classification_name;
  String type;
  int visits;
  List<String> gallery;
  List<CategoryModel> services;
  List<VehicleModel> vehicles;
  List<BrandModel> brands;
  List<CategoryModel> fields;
  List<CategoryModel> activities;
  Media media;
  Videos videos;

  VendorModel({
    this.key,
    this.id,
    this.activities,
    this.job_field_name,
    this.experience_years,
    this.service_desc,
    this.pos_sub_id,
    this.userId,
    this.reviews,
    this.lat,
    this.lng,
    this.subscriber_name,
    this.subscriber_phone,
    this.event_name,
    this.receipt_number,
    this.price_after,
    this.maximum_load_limit,
    this.shipping_type_name,
    this.visits,
    this.price_before,
    this.city,
    this.name,
    this.title,
    this.stock,
    this.phone,
    this.phone2,
    this.whatsapp,
    this.activatedAt,
    this.logo,
    this.createdAt,
    this.servicedBy,
    this.subId,
    this.typeId,
    this.date_to,
    this.vehicle_type,
    this.description,
    this.status,
    this.discount,
    this.roleId,
    this.distance,
    this.isActive,
    this.color,
    this.address,
    this.owner_name,
    this.type,
    this.working_hours_name,
    this.place_id,
    this.classification_id,
    this.classification_name,
    this.gallery,
    this.videos,
    this.vehicles,
    this.services,
    this.brands,
    this.fields,
    this.media,
    this.category_id,
    this.qty,
  });

  factory VendorModel.fromMap(Map<String, dynamic> map) {
    print(map['distance'].toString());

    return new VendorModel(
      key: new GlobalKey(),
      id: map['id'].toString() ?? "0",
      category_id: map['category_id'].toString() ?? "1",
      qty: 1,
      userId: map['user_id'].toString() ?? map['id'] ?? "",
      pos_sub_id:
          map['pos_sub_id'] != null ? map['pos_sub_id'].toString() : "0",
      lat: map['lat'] != null ? map["lat"].toString() ?? "0.0" : "0.0",
      title: map['title'] != null ? map["title"].toString() ?? "" : "",
      lng: map['lng'] != null ? map['lng'].toString() ?? "0.0" : "0.0",
      subscriber_name: map['subscriber_name'] != null
          ? map['subscriber_name'].toString() ?? ""
          : "",
      subscriber_phone: map['subscriber_phone'] != null
          ? map['subscriber_phone'].toString() ?? ""
          : "",
      receipt_number: map['receipt_number'] != null
          ? map['receipt_number'].toString() ?? ""
          : "",
      event_name:
          map['event_name'] != null ? map['event_name'].toString() ?? "" : "",
      stock: map['stock'] != null ? map['stock'].toString() ?? "1" : "1",
      name: (map['name'] as String)
              .replaceAll(new RegExp('&rlm;'), ' ')
              .replaceAll(new RegExp('&amp;'), ' ') ??
          "",
      job_field_name: map['job_field_name'].toString() ?? "",
      maximum_load_limit: map['maximum_load_limit'] != null
          ? map['maximum_load_limit'].toString()
          : "",
      shipping_type_name: map['shipping_type_name'] != null
          ? map['shipping_type_name'].toString()
          : "",
      city: map['city_name'] ?? "",
      visits: map['visits'] != null
          ? map['visits']
          : map['visits_count'] != null
              ? map['visits_count']
              : 0,
      vehicle_type: map['vehicle_type'] != null
          ? map['vehicle_type'].toString()
          : "" ?? "",
      price_before: map['price_before'] != null
          ? map['price_before'].toString()
          : map['purchasing_price'] ?? "0",
      price_after: map['price_after'] != null
          ? map['price_after'].toString()
          : map['sale_price'] ?? map["price"].toString() ?? "0",
      service_desc: map['service_desc']
              .toString()
              .replaceAll(new RegExp('&rlm;'), ' ')
              .replaceAll(new RegExp('&amp;'), ' ') ??
          "",
      experience_years: map['experience_years'].toString() ?? "",
      owner_name: map['owner_name'] != null
          ? map["owner_name"]
          : map['name'] != null
              ? map['name']
              : "",
      phone: map['phone'] as String ?? map['owner_phone'] as String ?? "",
      phone2: map['phone2'].toString() == "null"
          ? ""
          : map['phone2'] as String ?? "",
      classification_name: map['category_name'] as String ?? "",
      classification_id: map['class_id'].toString() ?? "",
      type: map['classification_name'] as String ?? "",
      working_hours_name: map['working_hours_name'] as String ?? "",
      discount: map['discount_percentage'].toString() ?? "",
      date_to: map['date_to'].toString() ?? "",
      place_id: map['place_id'].toString() ?? "",
      whatsapp: map['whatsapp'] as String ?? "",
      activatedAt: map['activated_at'] as dynamic,
      logo: map['winch_image'] ??
          map['product_image'] ??
          map['logo'] ??
          map['company_image'] ??
          map['image'] ??
          map["photo"] ??
          "",
      createdAt: map['created_at'].toString() ?? "",
      servicedBy: map['serviced_by'] as dynamic ?? "",
      subId: map['sub_id'] as dynamic ?? "",
      typeId: map['type_id'].toString() ?? "",
      status: map['product_status'] != null
          ? map['product_status'].toString()
          : map['status'] != null
              ? map['status']
              : "",
      description: map['description'] != null
          ? map['description']
              .replaceAll(new RegExp('&rlm;'), ' ')
              .replaceAll(new RegExp('&amp;'), ' ')
          : map['desc'] != null
              ? map['desc']
                  .replaceAll(new RegExp('&rlm;'), ' ')
                  .replaceAll(new RegExp('&amp;'), ' ')
              : map['notes'] != null
                  ? map['notes']
                      .replaceAll(new RegExp('&rlm;'), ' ')
                      .replaceAll(new RegExp('&amp;'), ' ')
                  : map['name'] ?? "",
      address: map['address'] as String ?? "",
      roleId: map['role_id'].toString() ?? "",
      media: map['media'] != null ? Media.fromMap(map['media']) ?? null : null,
      distance: map['distance'] != null ? map['distance'].toString() : "" ?? "",
      isActive: map['is_active'] is bool
          ? map['is_active']
          : map['is_active'] is int
              ? map['is_active'] == 1
                  ? true
                  : false
              : false,
      reviews: map['reviews'] != null && map['reviews'].toString() != "[]"
          ? List<ReviewModel>.from(
              map['reviews'].map((data) => ReviewModel.fromMap(data)))
          : [],
      gallery: map['gallery'] != null
          ? List<String>.from(map['gallery'].map((brand) => brand['image']))
          : map['images'] != null
              ? List<String>.from(map['images'].map((brand) => brand['image']))
              : null,
      videos: map['videos'] != null ? Videos.fromMap(map['videos']) : null,
      color: map['color'] as String ?? "",
      vehicles: map['vehicles'] != null
          ? List<VehicleModel>.from(
              map['vehicles'].map((brand) => VehicleModel.fromJson(brand)))
          : null,
      services: map['services'] != null
          ? List<CategoryModel>.from(
              map['services'].map((brand) => CategoryModel.fromMap(brand)))
          : null,
      brands: map['brands'] != null
          ? List<BrandModel>.from(
              map['brands'].map((brand) => BrandModel.fromMap(brand)))
          : null,
      fields: map['fields'] != null
          ? List<CategoryModel>.from(
              map['fields'].map((brand) => CategoryModel.fromMap(brand)))
          : null,
      activities: map['activities'] != null
          ? List<CategoryModel>.from(
              map['activities'].map((brand) => CategoryModel.fromMap(brand)))
          : [],
    );
  }
}

class Media {
  String fb;
  String yt;
  String twitter;
  String insta;
  String linkedin;
  String telegram;

  Media(
      {this.fb,
      this.yt,
      this.twitter,
      this.insta,
      this.linkedin,
      this.telegram});

  factory Media.fromMap(Map<String, dynamic> map) {
    return new Media(
      fb: map['fb'] as String ?? "",
      yt: map['yt'] as String ?? "",
      twitter: map['twitter'] as String ?? "",
      insta: map['insta'] as String ?? "",
      linkedin: map['linkedin'] as String ?? "",
      telegram: map['telegram'] as String ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'fb': this.fb,
      'yt': this.yt,
      'twitter': this.twitter,
      'insta': this.insta,
      'linkedin': this.linkedin,
      'telegram': this.telegram,
    } as Map<String, dynamic>;
  }
}

class Videos {
  String video_link_1;
  String video_link_2;
  String video_link_3;
  String video_link_4;

  Videos(
      {this.video_link_1,
      this.video_link_2,
      this.video_link_3,
      this.video_link_4});

  factory Videos.fromMap(Map<String, dynamic> map) {
    return new Videos(
      video_link_1: map['video_link_1'] as String ?? "",
      video_link_2: map['video_link_2'] as String ?? "",
      video_link_3: map['video_link_3'] as String ?? "",
      video_link_4: map['video_link_4'] as String ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'video_link_1': this.video_link_1,
      'video_link_2': this.video_link_2,
      'video_link_3': this.video_link_3,
      'video_link_4': this.video_link_4,
    } as Map<String, dynamic>;
  }
}

class ReviewModel {
  String stars;

  ReviewModel({this.stars});

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return new ReviewModel(
      stars: map['stars'] != null ? map['stars'].toString() ?? "0" : "0",
    );
  }
}
