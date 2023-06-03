part of '../main.dart';

// ignore: avoid_classes_with_only_static_members
class MyService {
  static Future<void> initializeService() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final FlutterBackgroundService service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
    service.startService();
  }

  static void onStart(ServiceInstance service) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // bring to foreground
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          const AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails(
            'my_foreground',
            'MY FOREGROUND SERVICE',
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                urlLaunchActionId,
                'Stop',
                icon: DrawableResourceAndroidBitmap('stop'),
                contextual: true,
              ),
              AndroidNotificationAction(
                urlLaunchActionId2,
                'Play',
                icon: DrawableResourceAndroidBitmap('play'),
                contextual: true,
              ),
            ],
          );

          const NotificationDetails notificationDetails = NotificationDetails(
            android: androidNotificationDetails,
          );
          await flutterLocalNotificationsPlugin.show(888, 'COOL SERVICE',
              'Awesome ${DateTime.now()}', notificationDetails,
              payload: 'item z');
        }
      }

      /// you can see this log in logcat
      print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
    });
  }

  static void stopService() {
    final FlutterBackgroundService service = FlutterBackgroundService();
    service.invoke('stopService');
  }
}
