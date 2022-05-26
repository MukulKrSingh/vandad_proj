import 'package:flutter/foundation.dart' show immutable;
import 'package:vandad_proj/bloc/person.dart';

const persons1Url = 'http://127.0.0.1:5500/API/person1.json';
const persons2Url = 'http://127.0.0.1:5500/API/person2.json';

typedef PersonLoader = Future<Iterable<PersonModel>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

//Event to Load Person Data
@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonLoader loader;
  const LoadPersonsAction({
    required this.url,required this.loader
  }) : super();
}
