// lib/core/services/cache_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheManager {
  Future<void> cacheData(String key, Map<String, dynamic> data, {Duration? expiry});
  Future<Map<String, dynamic>?> getCachedData(String key);
  Future<void> clearCache(String key);
  Future<void> clearAllCache();
  Future<bool> isCacheValid(String key);
}

class CacheManagerImpl implements CacheManager {
  final SharedPreferences sharedPreferences;
  static const String _expiryPrefix = '_expiry_';
  static const String _dataPrefix = '_data_';

  CacheManagerImpl(this.sharedPreferences);

  @override
  Future<void> cacheData(String key, Map<String, dynamic> data, {Duration? expiry}) async {
    try {
      final dataKey = '$_dataPrefix$key';
      final expiryKey = '$_expiryPrefix$key';

      // Store the data
      await sharedPreferences.setString(dataKey, jsonEncode(data));

      // Store expiry time if provided
      if (expiry != null) {
        final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
        await sharedPreferences.setInt(expiryKey, expiryTime);
      }
    } catch (e) {
      print('Error caching data for key $key: $e');
      throw CacheException('Failed to cache data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedData(String key) async {
    try {
      final dataKey = '$_dataPrefix$key';
      final expiryKey = '$_expiryPrefix$key';

      // Check if cache has expired
      final expiryTime = sharedPreferences.getInt(expiryKey);
      if (expiryTime != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now > expiryTime) {
          // Cache has expired, clear it
          await clearCache(key);
          return null;
        }
      }

      // Get cached data
      final cachedData = sharedPreferences.getString(dataKey);
      if (cachedData != null) {
        return jsonDecode(cachedData) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('Error getting cached data for key $key: $e');
      // Clear potentially corrupted cache
      await clearCache(key);
      return null;
    }
  }

  @override
  Future<void> clearCache(String key) async {
    try {
      final dataKey = '$_dataPrefix$key';
      final expiryKey = '$_expiryPrefix$key';

      await Future.wait([
        sharedPreferences.remove(dataKey),
        sharedPreferences.remove(expiryKey),
      ]);
    } catch (e) {
      print('Error clearing cache for key $key: $e');
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      final keys = sharedPreferences.getKeys();
      final cacheKeys = keys.where((key) => 
          key.startsWith(_dataPrefix) || key.startsWith(_expiryPrefix)
      ).toList();

      await Future.wait(
        cacheKeys.map((key) => sharedPreferences.remove(key))
      );
    } catch (e) {
      print('Error clearing all cache: $e');
      throw CacheException('Failed to clear all cache: $e');
    }
  }

  @override
  Future<bool> isCacheValid(String key) async {
    try {
      final expiryKey = '$_expiryPrefix$key';
      final dataKey = '$_dataPrefix$key';

      // Check if data exists
      if (!sharedPreferences.containsKey(dataKey)) {
        return false;
      }

      // Check expiry if set
      final expiryTime = sharedPreferences.getInt(expiryKey);
      if (expiryTime != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        return now <= expiryTime;
      }

      // No expiry set, cache is valid if data exists
      return true;
    } catch (e) {
      print('Error checking cache validity for key $key: $e');
      return false;
    }
  }

  // Helper methods for specific cache operations
  Future<void> cacheServiceCategories(Map<String, dynamic> data) async {
    await cacheData('service_categories', data, expiry: const Duration(hours: 1));
  }

  Future<Map<String, dynamic>?> getCachedServiceCategories() async {
    return await getCachedData('service_categories');
  }

  Future<void> clearServiceCategoriesCache() async {
    await clearCache('service_categories');
  }

  // Get cache info for debugging
  Future<CacheInfo> getCacheInfo(String key) async {
    final dataKey = '$_dataPrefix$key';
    final expiryKey = '$_expiryPrefix$key';

    final hasData = sharedPreferences.containsKey(dataKey);
    final expiryTime = sharedPreferences.getInt(expiryKey);
    
    DateTime? expiryDateTime;
    bool isExpired = false;
    
    if (expiryTime != null) {
      expiryDateTime = DateTime.fromMillisecondsSinceEpoch(expiryTime);
      isExpired = DateTime.now().isAfter(expiryDateTime);
    }

    return CacheInfo(
      key: key,
      hasData: hasData,
      expiryTime: expiryDateTime,
      isExpired: isExpired,
      isValid: hasData && !isExpired,
    );
  }

  // Get all cache keys
  List<String> getAllCacheKeys() {
    final keys = sharedPreferences.getKeys();
    return keys.where((key) => key.startsWith(_dataPrefix))
        .map((key) => key.substring(_dataPrefix.length))
        .toList();
  }

  // Get cache size estimation
  Future<int> getCacheSizeEstimate() async {
    int totalSize = 0;
    final keys = sharedPreferences.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_dataPrefix)) {
        final data = sharedPreferences.getString(key);
        if (data != null) {
          totalSize += data.length;
        }
      }
    }
    
    return totalSize;
  }
}

// Cache info model
class CacheInfo {
  final String key;
  final bool hasData;
  final DateTime? expiryTime;
  final bool isExpired;
  final bool isValid;

  const CacheInfo({
    required this.key,
    required this.hasData,
    this.expiryTime,
    required this.isExpired,
    required this.isValid,
  });

  @override
  String toString() {
    return 'CacheInfo(key: $key, hasData: $hasData, expiryTime: $expiryTime, isExpired: $isExpired, isValid: $isValid)';
  }
}

// Cache exception
class CacheException implements Exception {
  final String message;
  
  const CacheException(this.message);
  
  @override
  String toString() => 'CacheException: $message';
}