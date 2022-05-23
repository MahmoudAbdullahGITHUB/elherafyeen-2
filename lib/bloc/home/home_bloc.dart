import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/search_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({HomeState initialState}) : super(initialState);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is FetchHomeCategories) {
      yield HomeLoading();
      try {
        List<CategoryModel> categories = await HomeApi.fetchCategories();
        yield CategoriesLoaded(categories: categories);
      } catch (e) {
        yield HomeError(error: e.toString());
      }
    }
    if (event is FetchVehicleCategories) {
      yield HomeLoading();
      try {
        List<CategoryModel> categories = await HomeApi.fetchVehicleCategories();
        yield CategoriesLoaded(categories: categories);
      } catch (e) {
        yield HomeError(error: e.toString());
      }
    } else if (event is FetchVendorsToSearchWith) {
      yield HomeLoading();
      try {
        List<SearchModel> searches =
            await HomeApi.fetchVendorToSearch(categoryId: event.categoryId);
        yield VendrosToSearchWith(searches: searches);
      } catch (e) {
        yield HomeError(error: e.toString());
      }
    } else if (event is FetchServices) {
      yield HomeLoading();
      try {
        List<CategoryModel> searches = await HomeApi.fetchServices();
        yield ServicesLoaded(searches: searches);
      } catch (e) {
        yield HomeError(error: e.toString());
      }
    } else if (event is FetchCategoryBrands) {
      yield HomeLoading();
      try {
        List<BrandModel> brands =
            await HomeApi.fetchBrands(categoryId: event.catId);
        yield BrandsLoaded(brands: brands);
      } catch (e) {
        yield HomeError(error: e.toString());
      }
    } else if (event is FetchOutsideMaintenence) {
      yield HomeLoading();
      print("here staret");
      try {
        List<VendorModel> vendors = await HomeApi.fetchOutsideMaintenance(
            lat: event.lat, lng: event.lng);
        print("here end");

        yield VendorLoaded(vendors: vendors);
      } catch (e) {
        print("here ${e.toString()}");

        yield HomeError(error: e.toString());
      }
    } else if (event is FetchOnlineDealers) {
      yield HomeLoading();
      print("here staret");
      try {
        List<VendorModel> vendors = await HomeApi.fetchOnlineDealers(
            id: event.id, lat: event.lat, lng: event.lng);
        print("here end");

        yield VendorLoaded(vendors: vendors);
      } catch (e) {
        print("here ${e.toString()}");

        yield HomeError(error: e.toString());
      }
    } else if (event is FetchMedicalMerchant) {
      yield HomeLoading();
      print("here staret");
      try {
        List<VendorModel> vendors =
            await HomeApi.fetchMedicalDealers(lat: event.lat, lng: event.lng);
        print("here end");

        yield VendorLoaded(vendors: vendors);
      } catch (e) {
        print("here ${e.toString()}");

        yield HomeError(error: e.toString());
      }
    } else if (event is FetchMyServices) {
      yield HomeLoading();
      try {
        List<VendorModel> vendors = await HomeApi.fetchMyServices(
            lat: event.lat, lng: event.lng, id: event.id);
        yield VendorLoaded(vendors: vendors);
      } catch (e) {
        print("here ${e.toString()}");

        yield HomeError(error: e.toString());
      }
    } else if (event is FetchJobs) {
      yield HomeLoading();
      try {
        List<VendorModel> vendors =
            await HomeApi.fetchJobs(lat: event.lat, lng: event.lng);
        print('fetchJobsmbloc');
        yield VendorLoaded(vendors: vendors);
      } catch (e) {
        print("here ${e.toString()}");

        yield HomeError(error: e.toString());
      }
    } else if (event is FetchDisableJobs) {
      yield HomeLoading();
      try {
        List<VendorModel> vendors =
            await HomeApi.FetchDisableJobs(lat: event.lat, lng: event.lng);

        yield VendorLoaded(vendors: vendors);
      } catch (e) {
        print("here ${e.toString()}");

        yield HomeError(error: e.toString());
      }
    } else if (event is Search) {
      yield HomeLoading();
      try {
        List<VendorModel> vendors = await HomeApi.fetchVendorsResult(
            category_id: event.catId,
            brand_id: event.brandId,
            lat: event.lat,
            lng: event.lng,
            field_id: event.searchId);
        yield VendorLoaded(vendors: vendors);
      } catch (e) {
        yield HomeError(error: e.toString());
      }
    }
  }
}
