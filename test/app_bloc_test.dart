import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:vandad_proj/apis/login_api.dart';
import 'package:vandad_proj/apis/notes_api.dart';
import 'package:vandad_proj/bloc/actions.dart';
import 'package:vandad_proj/bloc/app_bloc.dart';
import 'package:vandad_proj/bloc/app_state.dart';
import 'package:vandad_proj/models.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturenForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturenForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturenForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  }) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturenForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPasssword;
  final LoginHandle handleToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPasssword,
    required this.handleToReturn,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPasssword = '',
        handleToReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptedEmail && password == acceptedPasssword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}

const acceptedLoginHandle = LoginHandle(token: 'ABC');

void main() {
  blocTest<AppBloc, AppState>(
    'Initial State of bloc should be AppState.empty()',
    build: () => AppBloc(
      acceptedLoginHandle: acceptedLoginHandle,
      loginApi: const DummyLoginApi.empty(),
      notesApi: const DummyNotesApi.empty(),
    ),
    verify: (appState) => expect(
      appState.state,
      const AppState.empty(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'Can we Login with valid credentials',
    build: () => AppBloc(
      acceptedLoginHandle: acceptedLoginHandle,
      loginApi: const DummyLoginApi(
        acceptedEmail: 'bar@baz.com',
        acceptedPasssword: 'foo',
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi(
        acceptedLoginHandle: LoginHandle.fooBar(),
        notesToReturenForAcceptedLoginHandle: mockNotes,
      ),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'We should not be able to Login with invalid credentials',
    build: () => AppBloc(
      acceptedLoginHandle: acceptedLoginHandle,
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@bar.com',
        acceptedPasssword: 'baz',
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi(
        acceptedLoginHandle: LoginHandle.fooBar(),
        notesToReturenForAcceptedLoginHandle: mockNotes,
      ),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: LoginErrors.invalidHandle,
        loginHandle: null,
        fetchedNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Load some notes with valid login handle',
    build: () => AppBloc(
      acceptedLoginHandle: acceptedLoginHandle,
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@bar.com',
        acceptedPasssword: 'baz',
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi(
        acceptedLoginHandle: acceptedLoginHandle,
        notesToReturenForAcceptedLoginHandle: mockNotes,
      ),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoginAction(
          email: 'foo@bar.com',
          password: 'baz',
        ),
      );
      appBloc.add(const LoadNotesAction());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: mockNotes,
      ),
    ],
  );
}
