
import 'cart_model.dart';

class Cart {
  final String delivery;
  final String notes;
  final String delivery_time;
  final String coupon;
  final int branchId;
  final int addressId;

  const Cart(
      {this.addressId,
      this.coupon,
      this.delivery_time,
      this.delivery,
      this.branchId,
      this.notes});

  static List<CartModel> cartProducts = [];

  static String countTotal() {
    double total = 0;
    for (var item in cartProducts) {
      total += item.quntity * int.tryParse(item.product.price_after).toDouble();
    }
    return "$total";
  }

  Map<String, dynamic> toJson() {
    return {
      "delivery_method": delivery,
      "notes": notes,
      "branch_id": branchId,
      "delivery_time": delivery_time,
      "address_id": addressId,
      "coupon": coupon,
      "product_list": cartProducts.map((e) => e.id).toList(),
      "qty": cartProducts.map((e) => e.quntity).toList(),
    };
  }

  Map<String, dynamic> toJsonCart() {
    return {
      // "shipping_user_id": shippId,
      "product_list": cartProducts.map((e) => toJsonProducts(e)).toList(),
    };
  }

  // "qty": cartProducts.map((e) => e.quntity).toList(),
  Map<String, dynamic> toJsonProducts(cartProduct) {
    return {"\"id\"": "\""+cartProduct.id.toString()+"\"", "\"amount\"": "\""+cartProduct.quntity.toString()+"\""};
  }
}
