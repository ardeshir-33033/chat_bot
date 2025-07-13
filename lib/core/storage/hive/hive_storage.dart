import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import 'hive_constants.dart';
import 'hive_local_storage.dart';

class HiveLocalStorageImpl extends HiveLocalStorage {
  @override
  Future<void> initialStorage() async {
    await Hive.initFlutter();
    await _openBoxes();
  }

  Future<void> _openBoxes() async {
    /// چک کن که باکس باز نشده باشه، بعد بازش کن
    if (!Hive.isBoxOpen(HiveConstants.accessToken)) {
      await Hive.openBox(HiveConstants.accessToken);
    }
    if (!Hive.isBoxOpen(HiveConstants.userIdBox)) {
      await Hive.openBox(HiveConstants.userIdBox);
    }
    if (!Hive.isBoxOpen(HiveConstants.refreshToken)) {
      await Hive.openBox(HiveConstants.refreshToken);
    }
  }

  Future<Box> _getBox(String boxKey) async {
    if (!Hive.isBoxOpen(boxKey)) {
      return await Hive.openBox(boxKey);
    }
    return Hive.box(boxKey);
  }

  @override
  Future<T?> getData<T>({
    required String boxKey,
    required String objectKey,
  }) async {
    final box = await _getBox(boxKey); // اطمینان از باز بودن باکس
    return box.get(objectKey) as T?;
  }

  @override
  Future<void> saveData<T>({
    required String boxKey,
    required String objectKey,
    required data,
  }) async {
    final box = await _getBox(boxKey); // اطمینان از باز بودن باکس
    await box.put(objectKey, data);
  }

  @override
  Future<void> clearObject({required String boxKey}) async {
    if (await Hive.boxExists(boxKey)) {
      await Hive.deleteBoxFromDisk(boxKey);
    }
  }

  @override
  Future<void> deleteKey<T>({
    required String boxKey,
    required String itemKey,
  }) async {
    final box = await _getBox(boxKey);
    await box.delete(itemKey);
  }

  @override
  Future<List<T>> getDataList<T>({required String boxKey}) async {
    final box = await _getBox(boxKey);
    return box.values.toList().cast<T>();
  }

  @override
  Future<List<T>> getDataListFilter<T>({
    required String boxKey,
    required String startKey,
    required String endKey,
  }) async {
    final box = await _getBox(boxKey);
    return box
        .valuesBetween(startKey: startKey, endKey: endKey)
        .toList()
        .cast<T>();
  }

  @override
  Future<void> deleteData<T>({
    required String boxKey,
    required String objectKey,
  }) async {
    final box = await _getBox(boxKey);
    await box.delete(objectKey);
  }

  @override
  Future<void> putAll<T>({
    required String boxKey,
    required Map<dynamic, T> entries,
  }) async {
    final box = await _getBox(boxKey);
    await box.putAll(entries);
  }

  @override
  Future<int> deleteAllData<T>({required String boxKey}) async {
    final box = await _getBox(boxKey);
    return await box.clear();
  }

  @override
  Future<void> clearAll() async {
    // حذف تمام داده‌ها از دیسک
    await Hive.deleteFromDisk();

    // بستن تمام باکس‌ها
    await Hive.close();
  }
}
