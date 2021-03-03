import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../config/dynamic_link.dart';
import 'general.dart';

class DynamicLinkService {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: firebaseDynamicLinkConfig['uriPrefix'],
      link: Uri.parse(firebaseDynamicLinkConfig['link']),
      androidParameters: AndroidParameters(
        packageName: firebaseDynamicLinkConfig['androidPackageName'],
        minimumVersion: firebaseDynamicLinkConfig['androidAppMinimumVersion'],
      ),
      iosParameters: IosParameters(
        bundleId: firebaseDynamicLinkConfig['iOSBundleId'],
        minimumVersion: firebaseDynamicLinkConfig['iOSAppMinimumVersion'],
        appStoreId: firebaseDynamicLinkConfig['iOSAppStoreId'],
      ));

  void generateFirebaseDynamicLink() async {
    final Uri dynamicUrl = await parameters.buildUrl();
    printLog(
        '[dynamic_link] Your Autogenerated Firebase Dynamic Link: $dynamicUrl');
  }
}