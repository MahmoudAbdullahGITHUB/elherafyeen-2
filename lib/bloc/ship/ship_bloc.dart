import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elherafyeen/api/auth_api.dart';
import 'package:elherafyeen/api/shpping_api.dart';
import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/models/shipping_type_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'ship_event.dart';
part 'ship_state.dart';

class ShipBloc extends Bloc<ShipEvent, ShipState> {
  ShipBloc({ShipState initialState}) : super(initialState);

  @override
  ShipState get initialState => InitialShipState();

  @override
  Stream<ShipState> mapEventToState(ShipEvent event) async* {
    if (event is LoadCountries) {
      yield LoadingShip();
      try {
        var countries = await AuthApi.fetchCountries();
        var shippingTypes = await ShippingApi.fetchShippingTypes();

        yield CountriesAndShippingTypesLoadded(
            countries: countries, shippingTypes: shippingTypes);
      } catch (e) {
        yield ShipError(error: e.toString());
      }
    }

    if (event is AddShippingCoButtonPressed) {
      print("here");
      yield AddShipLoading();
      try {
        var result = await ShippingApi.addShippingCompany(
            context: event.context,
            staff: event.staff,
            country_id: event.country_id,
            country_code: event.country_code,
            company_name: event.company_name,
            whatsapp: event.whatsapp,
            phone2: event.phone2,
            lat: event.lat,
            lng: event.lng,
            phone: event.phone,
            company_address: event.company_details,
            company_img: event.company_img,
            company_phone: event.company_phone,
            shipping_type: event.shipping_type,
            owner_name: event.owner_name);

        yield ShipAdded(result: result);
      } catch (e) {
        yield ShipError(error: e.toString());
      }
    }
  }
}
