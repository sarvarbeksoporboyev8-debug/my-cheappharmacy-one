import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeveloperSettings {
  final bool developerMode;
  final bool useMockData;
  final String apiBaseUrl;
  final String? apiToken; // stored securely
  const DeveloperSettings({required this.developerMode, required this.useMockData, required this.apiBaseUrl, this.apiToken});

  DeveloperSettings copyWith({bool? developerMode, bool? useMockData, String? apiBaseUrl, String? apiToken}) => DeveloperSettings(
        developerMode: developerMode ?? this.developerMode,
        useMockData: useMockData ?? this.useMockData,
        apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
        apiToken: apiToken ?? this.apiToken,
      );
}

class DeveloperSettingsNotifier extends Notifier<DeveloperSettings> {
  static const _kDevMode = 'dev_mode_enabled';
  static const _kUseMock = 'dev_use_mock';
  static const _kApiBase = 'dev_api_base_url';
  static const _kApiToken = 'dev_api_token';
  final _storage = const FlutterSecureStorage();

  @override
  DeveloperSettings build() {
    final initial = DeveloperSettings(developerMode: !kReleaseMode, useMockData: true, apiBaseUrl: 'https://example.com', apiToken: null);
    Future.microtask(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final dev = prefs.getBool(_kDevMode) ?? (!kReleaseMode);
        final mock = prefs.getBool(_kUseMock) ?? true;
        final base = prefs.getString(_kApiBase) ?? 'https://example.com';
        final token = await _storage.read(key: _kApiToken);
        state = DeveloperSettings(developerMode: dev, useMockData: mock, apiBaseUrl: base, apiToken: token);
      } catch (e) {
        debugPrint('Dev settings load failed: $e');
      }
    });
    return initial;
  }

  Future<void> setDeveloperMode(bool enabled) async {
    state = state.copyWith(developerMode: enabled);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kDevMode, enabled);
    } catch (e) {
      debugPrint('Dev mode save failed: $e');
    }
  }

  Future<void> setUseMock(bool mock) async {
    state = state.copyWith(useMockData: mock);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kUseMock, mock);
    } catch (e) {
      debugPrint('Use mock save failed: $e');
    }
  }

  Future<void> setApiBaseUrl(String base) async {
    state = state.copyWith(apiBaseUrl: base);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kApiBase, base);
    } catch (e) {
      debugPrint('API base save failed: $e');
    }
  }

  Future<void> setApiToken(String? token) async {
    state = state.copyWith(apiToken: token);
    try {
      if (token == null || token.isEmpty) {
        await _storage.delete(key: _kApiToken);
      } else {
        await _storage.write(key: _kApiToken, value: token);
      }
    } catch (e) {
      debugPrint('API token save failed: $e');
    }
  }
}

final developerSettingsProvider = NotifierProvider<DeveloperSettingsNotifier, DeveloperSettings>(() => DeveloperSettingsNotifier());
