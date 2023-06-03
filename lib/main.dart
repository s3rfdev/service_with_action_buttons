import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

part './functions/service.dart';
part './functions/permisstions.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const String urlLaunchActionId = 'id_1';
const String urlLaunchActionId2 = 'id_2';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  MyService.onStart(service);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyService.initializeService();
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _notificationsEnabled = false;
  void getPermissions(bool granted) {
    setState(() {
      _notificationsEnabled = granted;
    });
  }

  @override
  void initState() {
    super.initState();
    Permisstions()._isAndroidPermissionGranted(getPermissions);
    Permisstions()._requestPermissions(getPermissions);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Backgrund Service App'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                children: <Widget>[
                  const Divider(),
                  const Text(
                    'Notifications with actions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    child: Text('Stop Service'),
                    onPressed: () async {
                      MyService.stopService();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Start Service'),
                    onPressed: () async {
                      MyService.initializeService();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
