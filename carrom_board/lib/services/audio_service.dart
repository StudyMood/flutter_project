import 'package:flutter/services.dart';

/// Audio service for synthesized sound feedback and haptics
class CarromAudioService {
  static final CarromAudioService _instance = CarromAudioService._internal();
  factory CarromAudioService() => _instance;
  CarromAudioService._internal();

  bool soundEnabled = true;

  void playStrikerHit(double intensity) {
    if (!soundEnabled) return;
    try {
      if (intensity > 15.0) {
        HapticFeedback.heavyImpact();
      } else if (intensity > 5.0) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (_) {}
  }

  void playCoinHit(double intensity) {
    if (!soundEnabled) return;
    try {
      if (intensity > 8.0) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    } catch (_) {}
  }

  void playWallHit(double intensity) {
    if (!soundEnabled) return;
    try {
      HapticFeedback.selectionClick();
    } catch (_) {}
  }

  void playPocketSound() {
    if (!soundEnabled) return;
    try {
      HapticFeedback.heavyImpact();
    } catch (_) {}
  }
}
