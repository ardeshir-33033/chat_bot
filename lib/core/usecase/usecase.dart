abstract class UseCase<T, Params>{
  Future<T> call({required Params params});
}

/// TODO: ain`t better?
// abstract class UseCase<T , Params>{
//   T call(Params params);
// }