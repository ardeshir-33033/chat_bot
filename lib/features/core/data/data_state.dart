abstract class DataState<T> {
  const DataState();
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(this.data);

  final T data;
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(this.error);

  final String error; // TODO(hossein): change it to our custom error entity
}
