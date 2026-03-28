import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';

/// Persists cart items to local storage as JSON using SharedPreferences.
class CartStorageService {
  static const _key = 'cart_items';

  final SharedPreferences _prefs;

  CartStorageService(this._prefs);

  /// Save the current list of cart items.
  Future<void> save(List<CartItem> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _prefs.setString(_key, jsonEncode(jsonList));
  }

  /// Load previously persisted cart items. Returns empty list if none stored.
  List<CartItem> load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Clear persisted cart data.
  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
