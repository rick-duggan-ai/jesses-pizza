import 'package:shared_preferences/shared_preferences.dart';

/// Persists transaction GUIDs locally so guest users can view past orders
/// without an account.
class GuestTransactionStorage {
  static const _key = 'guest_transaction_guids';

  final SharedPreferences _prefs;

  GuestTransactionStorage({required SharedPreferences prefs}) : _prefs = prefs;

  /// Returns all stored transaction GUIDs, most recent first.
  List<String> getGuids() {
    return _prefs.getStringList(_key) ?? [];
  }

  /// Appends [guid] to the stored list (skip duplicates).
  Future<void> addGuid(String guid) async {
    final guids = getGuids();
    if (guids.contains(guid)) return;
    guids.insert(0, guid); // newest first
    await _prefs.setStringList(_key, guids);
  }

  /// Removes a single GUID from storage.
  Future<void> removeGuid(String guid) async {
    final guids = getGuids();
    guids.remove(guid);
    await _prefs.setStringList(_key, guids);
  }

  /// Clears all stored GUIDs.
  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
