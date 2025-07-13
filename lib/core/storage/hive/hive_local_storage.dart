
abstract class HiveLocalStorage {

  Future<void> initialStorage();

  Future<void> clearAll();

  Future<void> clearObject({
    required String boxKey,
  });

  Future<void> deleteKey<T>({
    required String boxKey,
    required String itemKey,
  });

  Future<void> saveData<T>({
    required String boxKey,
    required String objectKey,
    required dynamic data,
  });

  Future<T?> getData<T>({
    required String boxKey,
    required String objectKey,
  });

  Future<List<T>> getDataList<T>({
    required String boxKey,
  });

  Future<List<T>> getDataListFilter<T>({
    required String boxKey,
    required String startKey,
    required String endKey,
  });

  Future<void> deleteData<T>({
    required String boxKey,
    required String objectKey,
  });

  Future<int> deleteAllData<T>({
    required String boxKey,
  });

  Future<void> putAll<T>({
    required String boxKey,
    required Map<dynamic, T> entries,
  });
}
