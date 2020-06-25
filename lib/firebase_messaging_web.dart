library firebase_messaging_web;

import 'dart:async';
import 'dart:js';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FirebaseMessagingWebPlugin {

  final MethodChannel _channel;

  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
        'plugins.flutter.io/firebase_messaging',
        const StandardMethodCodec(),
        registrar.messenger
    );
    final FirebaseMessagingWebPlugin instance = FirebaseMessagingWebPlugin(channel);
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  FirebaseMessagingWebPlugin(this._channel);

  Future<dynamic> handleMethodCall(MethodCall call) async {
    print("Method call ${call.method} ${call.arguments}");
    switch (call.method) {
      case 'getToken':
        return _getToken();
      case 'configure':
        return _configure();
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The firebase_messaging plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  _getToken() {
    final completer = Completer();
    final messaging = context["firebase"].callMethod("messaging");
    messaging.callMethod("getToken").callMethod("then", [ (token) async {
      print("Received $token in web");
      if ( token == null && context.hasProperty("Notification")){
        return context["Notification"].callMethod('requestPermission')
            .callMethod('then', [ _onPermissionStatusChanged ]);
      }
      completer.complete(token);
    }]);
    return completer.future;
  }

  _onPermissionStatusChanged(String permission) {
    print("Received Notification permission $permission");
    switch(permission){
      case "granted": return _getToken();
    }
  }

  _configure() {
    print("Registered onMessage listener");
    final messaging = context["firebase"].callMethod("messaging");
    messaging.callMethod('onMessage', [ (JsObject message) {
      print("Message $message");
      _channel.invokeMethod('onMessage', {
        if (message.hasProperty("notification") != null) "notification": {
          "title": message["notification"]["title"],
          "body": message["notification"]["body"],
        }
      });
    }]);
  }
}