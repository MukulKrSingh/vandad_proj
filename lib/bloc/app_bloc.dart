import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vandad_proj/apis/login_api.dart';
import 'package:vandad_proj/apis/notes_api.dart';
import 'package:vandad_proj/bloc/actions.dart';
import 'package:vandad_proj/bloc/app_state.dart';

import '../models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;
  final LoginHandle acceptedLoginHandle;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
    required this.acceptedLoginHandle,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        //Start Loading
        emit(
          const AppState(
            isLoading: true,
            loginError: null,
            loginHandle: null,
            fetchedNotes: null,
          ),
        );

        //Log the User in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );

        emit(
          AppState(
            isLoading: false,
            loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      },
    );
    on<LoadNotesAction>(
      ((event, emit) async {
        //Start Loading Notes
        emit(
          AppState(
            isLoading: true,
            loginError: null,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );

        //get the Login Handle
        final loginHandle = state.loginHandle;
        if (loginHandle != acceptedLoginHandle) {
          //Invalid Login Handle could not load notes
          emit(
            AppState(
              isLoading: false,
              loginError: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
              fetchedNotes: null,
            ),
          );
          return;
        }

        //We have a valid login handle and we want to fetch notes

        final notes = await notesApi.getNotes(
          loginHandle: loginHandle!,
        );

        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      }),
    );
  }
}
