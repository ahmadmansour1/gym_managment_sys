import '../error/failures.dart';

class Result<T> {
  const Result._({this.data, this.failure});

  factory Result.ok(T data) => Result._(data: data);

  factory Result.err(Failure failure) => Result._(failure: failure);

  final T? data;
  final Failure? failure;

  bool get isOk => failure == null;
}
