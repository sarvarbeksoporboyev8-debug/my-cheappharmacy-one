import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final double radiusKm; // 5–200
  final String language; // system, en, uz, ru
  final bool watchlistAlerts;
  final bool offerUpdates;
  final bool reservationUpdates;
  const AppSettings({required this.radiusKm, required this.language, required this.watchlistAlerts, required this.offerUpdates, required this.reservationUpdates});

  AppSettings copyWith({double? radiusKm, String? language, bool? watchlistAlerts, bool? offerUpdates, bool? reservationUpdates}) => AppSettings(
        radiusKm: radiusKm ?? this.radiusKm,
        language: language ?? this.language,
        watchlistAlerts: watchlistAlerts ?? this.watchlistAlerts,
        offerUpdates: offerUpdates ?? this.offerUpdates,
        reservationUpdates: reservationUpdates ?? this.reservationUpdates,
      );
}

class SettingsNotifier extends Notifier<AppSettings> {
  static const _kRadius = 'pref_radius_km';
  static const _kLang = 'pref_language';
  static const _kWatch = 'pref_watchlist_alerts';
  static const _kOffer = 'pref_offer_updates';
  static const _kRes = 'pref_reservation_updates';

  @override
  AppSettings build() {
    final initial = const AppSettings(radiusKm: 25, language: 'system', watchlistAlerts: true, offerUpdates: true, reservationUpdates: true);
    Future.microtask(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        state = AppSettings(
          radiusKm: (prefs.getDouble(_kRadius) ?? 25).clamp(5, 200),
          language: prefs.getString(_kLang) ?? 'system',
          watchlistAlerts: prefs.getBool(_kWatch) ?? true,
          offerUpdates: prefs.getBool(_kOffer) ?? true,
          reservationUpdates: prefs.getBool(_kRes) ?? true,
        );
      } catch (e) {
        debugPrint('Settings load failed: $e');
      }
    });
    return initial;
  }

  Future<void> setRadius(double km) async {
    state = state.copyWith(radiusKm: km);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_kRadius, km);
    } catch (e) {
      debugPrint('Radius save failed: $e');
    }
  }

  Future<void> setLanguage(String lang) async {
    state = state.copyWith(language: lang);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLang, lang);
    } catch (e) {
      debugPrint('Language save failed: $e');
    }
  }

  Future<void> setWatchlistAlerts(bool v) async {
    state = state.copyWith(watchlistAlerts: v);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kWatch, v);
    } catch (e) {
      debugPrint('Watchlist save failed: $e');
    }
  }

  Future<void> setOfferUpdates(bool v) async {
    state = state.copyWith(offerUpdates: v);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOffer, v);
    } catch (e) {
      debugPrint('Offer save failed: $e');
    }
  }

  Future<void> setReservationUpdates(bool v) async {
    state = state.copyWith(reservationUpdates: v);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kRes, v);
    } catch (e) {
      debugPrint('Reservation save failed: $e');
    }
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(() => SettingsNotifier());
