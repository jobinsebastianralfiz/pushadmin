import 'dart:convert';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/offer.dart';

class AdminNotificationService {
  static const String ONE_SIGNAL_APP_ID =
      "add yours";

  Future<void> initialize() async {
    try {
      OneSignal.initialize(ONE_SIGNAL_APP_ID);

      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      await OneSignal.Notifications.requestPermission(true);

      //setup handlers
    } catch (e) {
      print("Error initilizing onesignal $e");
      rethrow;
    }
  }

  void _setupHandlers() {
    // foreground

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print("New Notificaions received");
      event.preventDefault();
    });

    OneSignal.Notifications.addClickListener((event) {
      print("Clicked notification: ${event.notification.title}");
      if (event.notification.additionalData != null) {
        final data = event.notification.additionalData!;
        if (data.containsKey('offer_id')) {
          print('offerid is ${data['offer_id']}');
        }
      }
    });
  }

  Future<bool> isSubscribed() async {
    try {
      final pushSubscription = OneSignal.User.pushSubscription;
      return pushSubscription.optedIn ?? false;
    } catch (e) {
      print('Error checking subscription: $e');
      return false;
    }
  }

  Future<String?> getPushToken() async {
    try {
      final pushSubscription = OneSignal.User.pushSubscription;
      return pushSubscription.token;
    } catch (e) {
      print('Error getting push token: $e');
      return null;
    }
  }

  // Get external user ID
  Future<String?> getExternalUserId() async {
    try {
      return OneSignal.User.getExternalId();
    } catch (e) {
      print('Error getting external user ID: $e');
      return null;
    }
  }

  // Add tags for segmentation
  Future<void> addTags(Map<String, String> tags) async {
    try {
      await OneSignal.User.addTags(tags);
    } catch (e) {
      print('Error adding tags: $e');
      rethrow;
    }
  }

  Future<void> removeTags(List<String> tagKeys) async {
    try {
      await OneSignal.User.removeTags(tagKeys);
    } catch (e) {
      print('Error removing tags: $e');
      rethrow;
    }
  }

  // Get tags
  Future<Map<String, dynamic>?> getTags() async {
    try {
      final tags = await OneSignal.User.getTags();
      return tags;
    } catch (e) {
      print('Error getting tags: $e');
      return null;
    }
  }

  // Login user
  Future<void> login(String externalId) async {
    try {
      await OneSignal.login(externalId);
    } catch (e) {
      print('Error logging in: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await OneSignal.logout();
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }

  // Enable/disable push notifications
  Future<void> setPushEnabled(bool enabled) async {
    try {
      await OneSignal.Notifications.requestPermission(enabled);
    } catch (e) {
      print('Error setting push enabled: $e');
      rethrow;
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await OneSignal.Notifications.clearAll();
    } catch (e) {
      print('Error clearing notifications: $e');
      rethrow;
    }
  }

  Future<void> sendNotification(Offer offer) async {
    final String oneSignalAppId = "add yours";

    final String oneSignalRestApiKey =
        "add yours";

    final String notificationUrl = 'https://onesignal.com/api/v1/notifications';

    final Map<String, dynamic> notificationPayload = {
      'app_id': oneSignalAppId,
      'included_segments': ['All'],
      'contents': {
        'en': 'New offer available: ${offer.title}',
      },
      'headings': {
        'en': 'New Offer',
      },
      'data': {
        'offer_id': offer.id,
      },
    };

    try {
      final response = await http.post(
        Uri.parse(notificationUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Basic $oneSignalRestApiKey',
        },
        body: json.encode(notificationPayload),
      );
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print(
            'Failed to send notification. StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
