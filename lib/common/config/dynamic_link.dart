// TODO: 5-Update Dynamic Link Setting
/// Ref: https://support.inspireui.com/help-center/articles/3/25/18/firebase-dynamic-link
const firebaseDynamicLinkConfig = {
  "isEnabled": true,
  // Domain is the domain name for your product.
  // Let’s assume here that your product domain is “example.com”.
  // Then you have to mention the domain name as : https://example.page.link.
  "uriPrefix": "https://dlcyasam.com.page.link",
  //The link your app will open
  "link": "https://dlcyasam.com/",
  //----------* Android Setting *----------//
  "androidPackageName": "com.innovarco.dlcstore",
  "androidAppMinimumVersion": 1,
  //----------* iOS Setting *----------//
  "iOSBundleId": "com.innovarco.com.dlcstore",
  "iOSAppMinimumVersion": "1.0.1",
  "iOSAppStoreId": "1542773849"
};
