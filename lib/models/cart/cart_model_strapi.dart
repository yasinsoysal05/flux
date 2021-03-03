import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../entities/product.dart';
import '../entities/product_variation.dart';
import 'cart_base.dart';
import 'mixin/address_mixin.dart';
import 'mixin/cart_mixin.dart';
import 'mixin/coupon_mixin.dart';
import 'mixin/currency_mixin.dart';
import 'mixin/local_mixin.dart';
import 'mixin/magento_mixin.dart';
import 'mixin/opencart_mixin.dart';
import 'mixin/shopify_mixin.dart';
import 'mixin/vendor_mixin.dart';

class CartModelStrapi
    with
        ChangeNotifier,
        CartMixin,
        MagentoMixin,
        AddressMixin,
        LocalMixin,
        CurrencyMixin,
        CouponMixin,
        ShopifyMixin,
        VendorMixin,
        OpencartMixin
    implements CartModel {
  static final CartModelStrapi _instance = CartModelStrapi._internal();

  factory CartModelStrapi() => _instance;

  CartModelStrapi._internal();

  Future<void> initData() async {
    await getShippingAddress();
    await getCartInLocal();
    await getCurrency();
  }

  double getTotal() {
    double subtotal = getSubTotal();

    if (subtotal < 0.0) {
      subtotal = 0.0;
    }

    if (kPaymentConfig['EnableShipping']) {
      subtotal += getShippingCost();
    }
    return subtotal;
  }

  double getItemTotal(
      {ProductVariation productVariation, Product product, int quantity = 1}) {
    double subtotal = 0.0;
    if (productVariation != null) {
      subtotal = double.parse(productVariation.price) * quantity;
    } else {
      subtotal = double.parse(product.price) * quantity;
    }
    printLog('getItemTotal $subtotal');
    return subtotal;
  }

  String updateQuantity(Product product, String key, int quantity, {context}) {
    String message = '';
    int total = quantity;
    ProductVariation variation;

    if (key.contains('-')) {
      variation = getProductVariationById(key);
    }
    int stockQuantity =
        variation == null ? product.stockQuantity : variation.stockQuantity;

    if (product.manageStock == null || !product.manageStock) {
      productsInCart[key] = total;
    } else if (total <= stockQuantity) {
      if (product.minQuantity == null && product.maxQuantity == null) {
        productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity == null) {
        total < product.minQuantity
            ? message =
                '${S.of(context).minimumQuantityIs} ${product.minQuantity}'
            : productsInCart[key] = total;
      } else if (product.minQuantity == null && product.maxQuantity != null) {
        total > product.maxQuantity
            ? message =
                '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}'
            : productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity != null) {
        if (total >= product.minQuantity && total <= product.maxQuantity) {
          productsInCart[key] = total;
        } else {
          if (total < product.minQuantity) {
            message =
                '${S.of(context).minimumQuantityIs} ${product.minQuantity}';
          }
          if (total > product.maxQuantity) {
            message =
                '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}';
          }
        }
      }
    } else {
      message =
          '${S.of(context).currentlyWeOnlyHave} $stockQuantity ${S.of(context).ofThisProduct}';
    }
    if (message.isEmpty) {
      updateQuantityCartLocal(key: key, quantity: quantity);
      notifyListeners();
    }
    return message;
  }

  // Removes an item from the cart.
  void removeItemFromCart(String key) {
    if (productsInCart.containsKey(key)) {
      productsInCart.remove(key);
      productVariationInCart.remove(key);
      removeProductLocal(key);
    }
    notifyListeners();
  }

  // Removes everything from the cart.
  void clearCart() {
    clearCartLocal();
    productsInCart.clear();
    item.clear();
    productVariationInCart.clear();
    shippingMethod = null;
    paymentMethod = null;
    couponObj = null;
    notes = null;
    notifyListeners();
  }

  void setOrderNotes(String note) {
    notes = note;
    notifyListeners();
  }

  String addProductToCart({
    context,
    Product product,
    int quantity = 1,
    ProductVariation variation,
    Function notify,
    isSaveLocal = true,
    Map<String, dynamic> options,
  }) {
    String message = '';

    if (product.type == 'simple' &&
        product.attributes != null &&
        product.attributes.isNotEmpty) {
      if (variation == null) {
        message = S.of(context).loading;
        return message;
      }
    }

    var key = "${product.id}";
    if (variation != null) {
      if (variation.id != null) {
        key += "-${variation.id}";
      }
      for (var attribute in variation.attributes) {
        if (attribute.id == null) {
          key += "-" + attribute.name + attribute.option;
        }
      }
    }

    //Check product's quantity before adding to cart
    int total = !productsInCart.containsKey(key)
        ? quantity
        : productsInCart[key] + quantity;
    int stockQuantity =
        variation == null ? product.stockQuantity : variation.stockQuantity;
//    print('stock is here');
//    print(product.manageStock);

    if (product.manageStock == null || !product.manageStock) {
      productsInCart[key] = total;
    } else if (total <= stockQuantity) {
      if (product.minQuantity == null && product.maxQuantity == null) {
        productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity == null) {
        total < product.minQuantity
            ? message =
                '${S.of(context).minimumQuantityIs} ${product.minQuantity}'
            : productsInCart[key] = total;
      } else if (product.minQuantity == null && product.maxQuantity != null) {
        total > product.maxQuantity
            ? message =
                '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}'
            : productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity != null) {
        if (total >= product.minQuantity && total <= product.maxQuantity) {
          productsInCart[key] = total;
        } else {
          if (total < product.minQuantity) {
            message =
                '${S.of(context).minimumQuantityIs} ${product.minQuantity}';
          }
          if (total > product.maxQuantity) {
            message =
                '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}';
          }
        }
      }
    } else {
      message =
          '${S.of(context).currentlyWeOnlyHave} $stockQuantity ${S.of(context).ofThisProduct}';
    }

    if (message.isEmpty) {
      item[product.id] = product;
      productVariationInCart[key] = variation;

      if (isSaveLocal) {
        saveCartToLocal(
            product: product, quantity: quantity, variation: variation);
      }
    }
    notifyListeners();
    return message;
  }

  @override
  void setRewardTotal(double total) {
    rewardTotal = total;
    notifyListeners();
  }
}
