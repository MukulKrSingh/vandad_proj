import 'package:vandad_proj/bloc/app_bloc.dart';

class TopBloc extends AppBloc {
  TopBloc({
    Duration? waitBeforeLoading,
    required Iterable<String> urls,
  }) : super(
          urls: urls,
          waitBeforeLoading: waitBeforeLoading,
        );
}
