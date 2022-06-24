import 'package:flutter/material.dart';
import 'package:vandad_proj/bloc/app_bloc.dart';
import 'package:vandad_proj/bloc/app_state.dart';
import 'package:vandad_proj/bloc/bloc_events.dart';
import 'package:vandad_proj/extensions/streams/start_with.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(
            event,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, appState) {
          if (appState.error != null) {
            return const Text('An Error Ocurred, Try again in a moment!!');
          } else if (appState.data != null) {
            //we have data
            return Image.memory(
              appState.data!,
              fit: BoxFit.fill,
            );
          } else {
            //Loading State
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
