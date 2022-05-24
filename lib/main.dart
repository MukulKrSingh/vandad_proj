// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());

  //GO
}

//Json Model class
@immutable
class PersonModel {
  final String name;
  final int age;

  const PersonModel({
    required this.name,
    required this.age,
  });

  PersonModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person (name = $name , age = $age';
}

//Event abstract class
@immutable
abstract class LoadAction {
  const LoadAction();
}

//Event to Load Person Data
@immutable
class LoadPersonsAction implements LoadAction {
  final PersonUrl url;
  const LoadPersonsAction({
    required this.url,
  }) : super();
}

//Extension on PersonUrl Enum to get urls
extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.persons1:
        return 'http://127.0.0.1:5500/API/person1.json';

      case PersonUrl.persons2:
        return 'http://127.0.0.1:5500/API/person2.json';
    }
  }
}

//Enum to get Url for each person
enum PersonUrl { persons1, persons2 }

//Function that gets Persons as per URL received
Future<Iterable<PersonModel>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => PersonModel.fromJson(e)));

//Bloc State class
@immutable
class FetchResult {
  final Iterable<PersonModel> persons;
  final bool isRetrievedFromCache;
  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      'fetchResult (is retieved from cache = $isRetrievedFromCache) and person = $persons';
}

//Bloc Header class

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<PersonModel>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        //We have value in cache, now we are going to grab that value
        final cachedPersons = _cache[url]!;
        final result = FetchResult(
          persons: cachedPersons,
          isRetrievedFromCache: true,
        );
        emit(result);
      } else {
        final persons = await getPersons(url.urlString);
        _cache[url] = persons;
        final result = FetchResult(
          persons: persons,
          isRetrievedFromCache: false,
        );
        emit(result);
      }
    });
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

//UI Class
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: ((context) => PersonBloc()),
      child: const HomePage(),
    ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                TextButton(
                  child: const Text('Load JSON #1'),
                  onPressed: () {
                    context
                        .read<PersonBloc>()
                        .add(const LoadPersonsAction(url: PersonUrl.persons1));
                  },
                ),
                TextButton(
                  child: const Text('Load JSON #2'),
                  onPressed: () {
                    context
                        .read<PersonBloc>()
                        .add(const LoadPersonsAction(url: PersonUrl.persons2));
                  },
                ),
              ],
            ),
            BlocBuilder<PersonBloc, FetchResult?>(
              buildWhen: (previousResult, currentResult) {
                return previousResult?.persons != currentResult?.persons;
              },
              builder: (context, fetchResult) {
                fetchResult?.log();
                final persons = fetchResult?.persons;
                if (persons == null) {
                  return const SizedBox();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: persons.length,
                    itemBuilder: (context, index) {
                      final person = persons[index]!;
                      return ListTile(
                        title: Text(person.name),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ));
  }
}
