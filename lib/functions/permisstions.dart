part of '../main.dart';

class Permisstions {
  Future<void> _isAndroidPermissionGranted(Function setState) async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      setState(granted);
    }
  }

  Future<void> _requestPermissions(Function setState) async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool granted =
          await androidImplementation?.requestPermission() ?? false;
      setState(granted);
    }
  }
}
