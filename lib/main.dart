import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pushadmin/firebase_options.dart';
import 'package:pushadmin/screens/admin_home_screen.dart';
import 'package:pushadmin/services/admin_notification_service.dart';
import 'package:pushadmin/services/authservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthService();
  await authService.signInAnonymously();
  final notificationsService = AdminNotificationService();
  await notificationsService.initialize();

  await notificationsService.login('adminapp');

  // Check subscription
  final isSubscribed = await notificationsService.isSubscribed();
  print('Is subscribed: $isSubscribed');

  // Get push token
  final token = await notificationsService.getPushToken();
  print('Push token: $token');

  // Get external user ID
  final externalUserId = await notificationsService.getExternalUserId();
  print('External User ID: $externalUserId');

  // Add tags
  await notificationsService.addTags({'role': 'admin', 'access_level': 'full'});

  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: AdminHomeScreen(),
    );
  }
}
