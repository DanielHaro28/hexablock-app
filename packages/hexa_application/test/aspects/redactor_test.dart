import 'package:hexa_application/hexa_application.dart';
import 'package:test/test.dart';

/// An object whose text holds an e-mail, as a `toString` might.
final class _Account {
  const _Account(this.email);

  final String email;

  @override
  String toString() => 'Account($email)';
}

void main() {
  const redactor = Redactor();
  const mask = Redactor.mask;

  group('SEC-WEB-06', () {
    test('should_mask_the_value_when_the_key_names_a_secret', () {
      // Arrange
      final data = {
        'password': 'hunter2',
        'accessToken': 'abc',
        'refresh_token': 'def',
        'userEmail': 'someone',
        'Authorization': 'Bearer xyz',
        'secret': 's',
        'pwd': 'p',
        'jwt': 'j',
        'Set-Cookie': 'c',
        'api_key': 'k',
        'sessionId': 'i',
        'credential': 'c',
      };

      // Act
      final redacted = redactor.redact(data);

      // Assert
      expect(redacted.values, everyElement(mask));
      expect(redacted.keys, data.keys);
    });

    test('should_mask_an_email_when_it_is_inside_any_text', () {
      // Arrange
      final data = {'note': 'sent by player@example.test today'};

      // Act
      final redacted = redactor.redact(data);

      // Assert
      expect(redacted['note'], 'sent by $mask today');
    });

    test('should_mask_a_jwt_when_it_is_inside_any_text', () {
      // Arrange
      final data = {
        'header': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIn0.c2ln',
      };

      // Act
      final redacted = redactor.redact(data);

      // Assert
      expect(redacted['header'], 'Bearer $mask');
    });

    test('should_redact_nested_maps_and_lists_when_they_hold_secrets', () {
      // Arrange
      final data = {
        'form': {
          'password': 'hunter2',
          'fields': ['name', 'a@b.test'],
        },
      };

      // Act
      final redacted = redactor.redact(data);

      // Assert
      expect(redacted, {
        'form': {
          'password': mask,
          'fields': ['name', mask],
        },
      });
    });

    test('should_redact_the_text_of_an_object_when_it_is_not_plain_data', () {
      // Arrange
      final data = {'account': const _Account('player@example.test')};

      // Act
      final redacted = redactor.redact(data);

      // Assert
      expect(redacted['account'], 'Account($mask)');
    });

    test('should_mask_a_secret_field_when_it_is_inside_an_object_text', () {
      // Arrange: a record prints as `(email: ..., password: ...)`.
      final data = {
        'command': (email: 'player@example.test', password: 'secret-1'),
      };

      // Act
      final redacted = redactor.redact(data);

      // Assert
      expect(redacted['command'], '(email: $mask, password: $mask)');
    });

    test('should_mask_a_bearer_token_when_it_is_not_a_jwt', () {
      // Arrange
      final data = {'header': 'Bearer opaque-refresh-123'};

      // Act
      final redacted = redactor.redact(data);

      // Assert
      expect(redacted['header'], 'Bearer $mask');
    });

    test('should_mask_an_email_when_it_is_a_map_key', () {
      // Arrange
      final data = {
        'players': {'player@example.test': 3},
      };

      // Act
      final redacted = redactor.redact(data);

      // Assert
      expect(redacted['players'], {mask: 3});
    });

    test('should_keep_numbers_flags_and_plain_text_when_nothing_is_secret', () {
      // Arrange
      final data = {'ms': 12, 'ok': true, 'move': 'PlacePiece(0, (1, 2))'};

      // Act
      final redacted = redactor.redact(data);

      // Assert
      expect(redacted, data);
    });
  });
}
