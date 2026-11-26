import 'package:hexa_application/hexa_application.dart';
import 'package:test/test.dart';

/// Reads what a service returned when the test expects it to succeed
/// (D-160).
extension FutureEitherValues<L, R> on Future<Either<L, R>> {
  /// The value of the [Right]; a [Left] fails the test with its value.
  Future<R> get right async => switch (await this) {
    Right(:final value) => value,
    Left(:final value) => fail('Expected a Right, got a Left with $value'),
  };
}
