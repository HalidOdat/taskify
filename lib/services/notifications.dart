import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController {
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group',
        )
      ],
      debug: true,
    );
  }

  static Future<void> requestPermission() async {
    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<bool> createNotification({
    required int id,
    required String title,
    required String body,
    String channelKey = 'basic_channel',
    ActionType actionType = ActionType.Default,
  }) async {
    return await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: channelKey,
        actionType: actionType,
        title: title,
        body: body,
      ),
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //     '/notification-page',
    //     (route) =>
    //         (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }
}
