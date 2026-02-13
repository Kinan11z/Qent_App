import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';

class AppConfigurations {
  static const String ApplicationName = 'qent';

  static String BaseUrl = 'https://qent.azurewebsites.net/api/';
  static int PageSize = 10;
  static String AppConfigurationsImageUrl =
      'https://qent.azurewebsites.net/api/Images/';

  static const Map<String, String> BaseHeaders = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static DateFormat attachmentNameDateAndTime =
      DateFormat('dd-MM-yyyy-HH-mm', 'en');

  static String dayDisplayApiDateTimeFormatWithLocale(
    DateTime value,
    String locale,
  ) =>
      '${DateFormat(
        'EEEE ',
        locale,
      ).format(value)}${DateFormat(
        'd ',
        'en',
      ).format(value)}${DateFormat(
        'LLLL ',
        locale,
      ).format(value)}${DateFormat(
        'yyyy',
        'en',
      ).format(value)}';

  static DateFormat appDisplayDateFormat = DateFormat('dd/MM/yyyy', 'en');
  static DateFormat appointmentCreateApiDateTimeFormat =
      DateFormat('yyyy-MM-ddTHH:mm:ss', 'en');

  static bool isArabicInputPrevented = false;

  static AndroidDeviceInfo? _androidInfo;

  static AndroidDeviceInfo get androidInfo {
    if (_androidInfo == null) {
      throw Exception("can't request ios device info from android device");
    } else {
      return _androidInfo!;
    }
  }

  static IosDeviceInfo? _iosInfo;

  static IosDeviceInfo get iosInfo {
    if (_iosInfo == null) {
      throw Exception("can't request android device info from ios device");
    } else {
      return _iosInfo!;
    }
  }

  // device info
  static Future initDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      _androidInfo = await deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      _iosInfo = await deviceInfo.iosInfo;
    }
    // final webBrowserInfo = await deviceInfo.webBrowserInfo;
  }
}
