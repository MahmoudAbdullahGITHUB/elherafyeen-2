import 'dart:convert';

import 'package:elherafyeen/models/payment_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/subscription_model.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:http/http.dart' as http;

class PaymentApi {
  static final _url = Strings.apiLink;

  static Future<List<SubscriptionModel>> getSubscriptionsTypes() async {
    final response = await http.get(
        Uri.parse(
            _url + "get_subscriptions_types?lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<SubscriptionModel>.from(
          body['result'].map((data) => SubscriptionModel.fromMap(data)));
    }
  }

  static Future<PaymentModel> getKioskPaymentAuth({String subId}) async {
    final response = await http.post(Uri.parse(_url + "kioskPaymentAuth"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      var token = body['result']['token'].toString();
      var merchant_id = body['result']['merchant_id'].toString();

      var secondeStap = await PaymentApi.kioskOrderRegisteration(
          token: token, merchant_id: merchant_id, sub_id: subId);

      var thirdStep = await PaymentApi.getKioskPaymentKey(
          token: token, odrder_id: secondeStap, sub_id: subId);

      var lastStep = await PaymentApi.getKioskPaymentsFinish(toekn: thirdStep);

      return lastStep;
    }
  }

  static Future<String> kioskOrderRegisteration({
    String token,
    String merchant_id,
    String sub_id,
  }) async {
    final response =
        await http.post(Uri.parse(_url + "kioskOrderRegisteration"), body: {
      "auth_token": token,
      "merchant_id": merchant_id,
      "sub_id": sub_id,
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token
    });
    final body = json.decode(response.body);
    print("mahmoud3" + body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return body['result']['order_id'].toString();
    }
  }

  static Future<String> getKioskPaymentKey({
    String token,
    String odrder_id,
    String sub_id,
  }) async {
    print("mahmoud dd");
    final response =
        await http.post(Uri.parse(_url + "kioskPaymentKey"), body: {
      "auth_token": token,
      "order_id": odrder_id,
      "sub_id": sub_id,
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token
    }).timeout(Duration(seconds: 15));
    print("mahmoud2" + response.body);
    final body = json.decode(response.body);

    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return body['result']['token'].toString();
    }
  }

  static Future<PaymentModel> getKioskPaymentsFinish({
    String toekn,
  }) async {
    final response = await http.post(Uri.parse(_url + "kioskPayments"), body: {
      "payment_token": toekn,
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token
    });
    final body = json.decode(response.body);
    print("mahmoud4" + body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return PaymentModel.fromMap(body['result']);
    }
  }
}
