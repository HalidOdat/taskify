import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';

class LightStreamController {
  Light? _light;
  StreamSubscription<int>? _subscription;
  final StreamController<int> _lightStreamController = StreamController<int>();

  Stream<int> get lightStream => _lightStreamController.stream;

  void onData(int luxValue) {
    _lightStreamController.sink.add(luxValue);
  }

  void startListening() {
    _light = Light();
    try {
      _subscription = _light?.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      debugPrint(exception.toString());
    }
  }

  void stopListening() {
    _subscription?.cancel();
    _lightStreamController.close();
  }
}
