import 'package:hexa_application/hexa_application.dart';
import 'package:test/test.dart';

/// A service that returns its command.
final class _EchoService implements ICommandService<int, int> {
  const _EchoService();

  @override
  Future<Either<AppFailure, int>> execute(int command) async => Right(command);
}

/// An aspect that only delegates, to chain with another kind of aspect.
final class _PassAspect<TCommand, TResult> extends Aspect<TCommand, TResult> {
  _PassAspect(super.inner);

  @override
  Type get kind => _PassAspect;

  @override
  Future<Either<AppFailure, TResult>> execute(TCommand command) =>
      inner.execute(command);
}

void main() {
  group('D-160', () {
    test('should_keep_the_service_type_when_an_aspect_wraps_it', () async {
      // Arrange
      const service = _EchoService();

      // Act
      final ICommandService<int, int> wrapped = ExceptionAspect(service);

      // Assert
      expect(await wrapped.execute(7), const Right<AppFailure, int>(7));
    });

    test('should_chain_the_aspects_when_each_kind_appears_once', () async {
      // Arrange
      const service = _EchoService();

      // Act
      final chain = _PassAspect(ExceptionAspect(service));

      // Assert
      expect(await chain.execute(3), const Right<AppFailure, int>(3));
    });

    test('should_throw_when_an_aspect_wraps_the_same_kind_of_aspect', () {
      // Arrange
      final once = ExceptionAspect(const _EchoService());

      // Act
      ExceptionAspect<int, int> twice() => ExceptionAspect(once);

      // Assert
      expect(twice, throwsArgumentError);
    });

    test(
      'should_throw_when_the_same_kind_of_aspect_has_wider_type_arguments',
      () {
        // Arrange: Dart's covariance lets an <int, num> aspect wrap an
        // <int, int> chain, so the two runtime types differ.
        final once = ExceptionAspect<int, int>(const _EchoService());

        // Act
        ExceptionAspect<int, num> twice() => ExceptionAspect<int, num>(once);

        // Assert
        expect(twice, throwsArgumentError);
      },
    );

    test(
      'should_throw_when_the_same_kind_of_aspect_is_deeper_in_the_chain',
      () {
        // Arrange
        final chain = _PassAspect(ExceptionAspect(const _EchoService()));

        // Act
        ExceptionAspect<int, int> again() => ExceptionAspect(chain);

        // Assert
        expect(again, throwsArgumentError);
      },
    );
  });
}
