import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elherafyeen/api/auth_api.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/api/winsh_api.dart';
import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'winsh_event.dart';
part 'winsh_state.dart';

class WinshBloc extends Bloc<WinshEvent, WinshState> {
  WinshBloc({WinshState initialState}) : super(initialState);

  @override
  WinshState get initialState => InitialWinshState();

  @override
  Stream<WinshState> mapEventToState(WinshEvent event) async* {
    if (event is LoadCountries) {
      yield LoadingWinsh();
      try {
        var countries = await AuthApi.fetchCountries();
        yield CountriesLoadded(countries: countries);
      } catch (e) {
        yield WinshError(error: e.toString());
      }
    }
    if (event is LoadWinches) {
      yield LoadingWinsh();
      try {
        var winches = event.company
            ? await WinshApi.fetchWinchesForCompany(
                lat: event.lat, lng: event.lng, page: event.page)
            : await WinshApi.fetchWinchesForIndividuals(
                lat: event.lat, lng: event.lng, page: event.page);
        yield WinchesLoadded(winches: winches);
      } catch (e) {
        yield WinshError(error: e.toString());
      }
    }
    if (event is LoadCaptines) {
      yield LoadingWinsh();
      try {
        var winches = await HomeApi.getShippingRepsList(
            category_id: event.category_id, lat: event.lat, lng: event.lng);
        yield WinchesLoadded(winches: winches);
      } catch (e) {
        yield WinshError(error: e.toString());
      }
    }
    if (event is LoadNearbyCaptains) {
      yield LoadingWinsh();
      try {
        var winches =
            await HomeApi.getNearbyShippingList(lat: event.lat, lng: event.lng);
        yield WinchesLoadded(winches: winches);
      } catch (e) {
        yield WinshError(error: e.toString());
      }
    }

    if (event is AddWinshButtonPressed) {
      print("here");
      yield AddWinshLoading();
      try {
        var result = await WinshApi.addWinsh(
            context: event.context,
            staff_id: event.staff_id,
            country_id: event.country_id,
            country_code: event.country_code,
            company_name: event.company_name,
            whatsapp: event.whatsapp,
            phone2: event.phone2,
            driver_name: event.driver_name,
            lat: event.lat,
            lng: event.lng,
            company_img: event.company_img,
            winsh_img: event.winsh_img);

        yield WinshAdded(result: result);
      } catch (e) {
        yield WinshError(error: e.toString());
      }
    }
  }
}
