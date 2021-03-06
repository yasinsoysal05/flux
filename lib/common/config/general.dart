import '../../common/constants.dart';

/// Default app config, it's possible to set as URL
const kAppConfig = 'https://dlcyasam.com/wp-content/uploads/config_tr.json';

// TODO: 4-Update Google Map Address
/// Ref: https://support.inspireui.com/help-center/articles/3/25/16/google-map-address
/// The Google API Key to support Pick up the Address automatically
/// We recommend to generate both ios and android to restrict by bundle app id
/// The download package is remove these keys, please use your own key
const kGoogleAPIKey = {
  "android": "AIzaSyDW3uXzZepWBPi-69BIYKyS-xo9NjFSFhQ",
  "ios": "AIzaSyDW3uXzZepWBPi-69BIYKyS-xo9NjFSFhQ",
  "web": "AIzaSyDW3uXzZepWBPi-69BIYKyS-xo9NjFSFhQ"
};

/// user for upgrader version of app, remove the comment from lib/app.dart to enable this feature
/// https://tppr.me/5PLpD
const kUpgradeURLConfig = {
  "android": "https://play.google.com/store/apps/details?id=com.innovarco.dlcstore",
  "ios": "https://apps.apple.com/us/app/dlc-online-al%C4%B1%C5%9Fveri%C5%9F/id1542773849"
};

/// Use for Rating app on store feature
/// make sure to replace the bundle ID by your own ID to prevent the app review reject
const kStoreIdentifier = {
  "disable": true,
  "android": "com.innovarco.dlcstore",
  "ios": "1542773849"
};

const kAdvanceConfig = {
  "DefaultLanguage": "tr",
  "DetailedBlogLayout": kBlogLayout.halfSizeImageType,
  "EnablePointReward": false,
  "hideOutOfStock": true,
  "EnableRating": true,
  "hideEmptyProductListRating": true,
  "EnableShipping": true,

  /// Enable search by SKU in search screen
  "EnableSkuSearch": true,

  /// Show stock Status on product List & Product Detail
  "showStockStatus": true,

  /// Gird count setting on Category screen
  "GridCount": 3,

  // TODO: 4.Upgrade App Performance & Image Optimize
  /// set isCaching to true if you have upload the config file to mstore-api
  /// set kIsResizeImage to true if you have finished running Re-generate image plugin
  /// ref: https://support.inspireui.com/help-center/articles/3/8/19/app-performance
  "isCaching": true,
  "kIsResizeImage": true,

  // TODO: 3.Update Mutli-Currencies and Default Currency
  /// Stripe payment only: set currencyCode and smallestUnitRate.
  /// All API requests expect amounts to be provided in a currency’s smallest unit.
  /// For example, to charge 10 USD, provide an amount value of 1000 (i.e., 1000 cents).
  /// Reference: https://stripe.com/docs/currencies#zero-decimal
  "DefaultCurrency": {
    "symbol": "\₺",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": false,
    "currency": "TRY",
    "currencyCode": "try",
    "smallestUnitRate": 100, // 100 cents = 1 usd
  },
  "Currencies": [
    {
      "symbol": "\₺",
      "decimalDigits": 2,
      "symbolBeforeTheNumber": false,
      "currency": "TL",
      "currencyCode": "tl",
      "smallestUnitRate": 100, // 100 cents = 1 usd
    },
  ],

  // TODO: 3.Update Magento Config Product
  /// Below config is used for Magento store
  "DefaultStoreViewCode": "",
  "EnableAttributesConfigurableProduct": ["color", "size"],
  "EnableAttributesLabelConfigurableProduct": ["color", "size"],

  /// if the woo commerce website supports multi languages
  /// set false if the website only have one language
  "isMultiLanguages": true,

  ///Review gets approved automatically on woocommerce admin without requiring administrator to approve.
  "EnableApprovedReview": false,

  /// Sync Cart from website and mobile
  "EnableSyncCartFromWebsite": true,
  "EnableSyncCartToWebsite": true,

  /// Disable shopping Cart due to Listing Users request
  "EnableShoppingCart": false,

  /// Enable firebase to support FCM, realtime chat for Fluxstore MV
  "EnableFirebase": false,

  /// ratio Product Image, default value is 1.2 = height / width
  "RatioProductImage": 1.2,

  /// Enable Coupon Code When checkout
  "EnableCouponCode": true,

  /// Enable to Show Coupon list.
  "ShowCouponList": true,

  /// Enable this will show all coupons in Coupon list.
  /// Disable will show only coupons which is restricted to the current user's email.
  "ShowAllCoupons": true,

  /// Show expired coupons in Coupon list.
  "ShowExpiredCoupons": true,
  "AlwaysShowTabBar": false,
};

// TODO: 3.Update Social Login Login
/// ref: https://support.inspireui.com/help-center/articles/3/25/15/social-login
const kLoginSetting = {
  "IsRequiredLogin": false,
  'showAppleLogin': false,
  'showFacebook': false,
  'showSMSLogin': false,
  'showGoogleLogin': false,
  "showPhoneNumberWhenRegister": false,
  "requirePhoneNumberWhenRegister": false,
};

// TODO: 3.Update Left Menu Setting
/// this could be config via Fluxbuilder tool http://fluxbuilder.com/
const kDefaultDrawer = {
  "logo": "assets/images/logo.png",
  "background": null,
  "items": [
    {"type": "home", "show": true},
    {"type": "blog", "show": false},
    {"type": "categories", "show": true},
    {"type": "cart", "show": true},
    {"type": "profile", "show": true},
    {"type": "login", "show": true},
    {"type": "category", "show": true},
  ]
};

// TODO: 3.Update The Setting Screens Menu
/// you could order the position to change menu
/// this feature could be done via Fluxbuilder
const kDefaultSettings = [
  'products',
  'chat',
  'wishlist',
  'notifications',
  'language',
  'currencies',
  'darkTheme',
  'order',
  'point',
  'rating',
  'privacy',
  'about'
];

// TODO: 3.Update Push Notification For OneSignal
/// Ref: https://support.inspireui.com/help-center/articles/3/8/14/push-notifications
const kOneSignalKey = {
  'enable': true,
  'appID': '8951d4e6-d4b5-4161-9ea6-595c81c80cb9',
};

/// Use for set default SMS Login
class LoginSMSConstants {
  static const String countryCodeDefault = 'TR';
  static const String dialCodeDefault = '+90';
  static const String nameDefault = 'Türkiye';
}

/// update default dark theme
/// advance color theme could be changed from common/styles.dart
const kDefaultDarkTheme = false;
