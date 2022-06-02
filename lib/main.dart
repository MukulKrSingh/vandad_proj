// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vandad_proj/apis/login_api.dart';
import 'package:vandad_proj/apis/notes_api.dart';
import 'package:vandad_proj/bloc/actions.dart';
import 'package:vandad_proj/bloc/app_state.dart';
import 'package:vandad_proj/dialogs/generic_dialog.dart';
import 'package:vandad_proj/dialogs/loading_screen.dart';
import 'package:vandad_proj/models.dart';
import 'package:vandad_proj/strings.dart';
import 'package:vandad_proj/views/iterable_list_view.dart';
import 'package:vandad_proj/views/login_view.dart';
import 'dart:developer' as devtools show log;

import 'bloc/app_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(
    MaterialApp(
      title: 'Bloc for Login',
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            //loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            //display error
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }
            //if we are logged in, but we have not fetched notes, fetch them now
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              LoadingScreen.instance().show(
                context: context,
                text: fetchingNotes,
              );
              context.read<AppBloc>().add(
                    LoadNotesAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              //print('yo');
              return LoginView(
                onLoginTapped: (
                  email,
                  password,
                ) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              //print('Hey');
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
