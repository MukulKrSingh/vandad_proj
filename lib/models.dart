// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart' show immutable;

@immutable
class LoginHandle {
  final String token;

  const LoginHandle({
    required this.token,
  });
  const LoginHandle.fooBar() : token = 'foobar';

  @override
  bool operator ==(covariant LoginHandle other) {
    return token == other.token;
  }

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LoginHandle(token =  $token)';
}

enum LoginErrors {
  invalidHandle,
  unknownError,
}

@immutable
class Note {
  final String title;

  const Note({
    required this.title,
  });

  @override
  String toString() => 'Note(title = $title)';
}

final mockNotes =
    Iterable.generate(3, (i) => Note(title: 'Note ${i + 1}'),);
