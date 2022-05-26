import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:vandad_proj/bloc/bloc_actions.dart';
import 'package:vandad_proj/bloc/person.dart';
import 'package:vandad_proj/bloc/persons_bloc.dart';

const mockedPersons1 = [
  PersonModel(name: 'Foo1', age: 20),
  PersonModel(name: 'Bar1', age: 40)
];

const mockedPersons2 = [
  PersonModel(name: 'Foo2', age: 20),
  PersonModel(name: 'Bar2', age: 40)
];

Future<Iterable<PersonModel>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<PersonModel>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group('Testing Bloc', () {
    //write our tests here
    late PersonBloc bloc;
    setUp(() {
      bloc = PersonBloc();
      //setUp functions runs before performing any tests and sets up everything which is required for performing tests;
    });
    blocTest<PersonBloc, FetchResult?>('Testing Initial State',
        build: () => bloc, verify: (bloc) => expect(bloc.state, null));


    //Fetch mock data Persons 1 and compare it with FetchResult

    blocTest<PersonBloc, FetchResult?>(
        'Mock retrieving persons from first Iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const LoadPersonsAction(
              url: 'dummy_url_1', loader: mockGetPersons1));
          bloc.add(const LoadPersonsAction(
              url: 'dummy_url_1', loader: mockGetPersons1));
        },
        expect: () => [
              const FetchResult(
                  persons: mockedPersons1, isRetrievedFromCache: false),
              const FetchResult(
                  persons: mockedPersons1, isRetrievedFromCache: true),
            ]);


    
    //Fetch mock data Persons 2 and compare it with FetchResult

    blocTest<PersonBloc, FetchResult?>(
        'Mock retrieving persons  from second Iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const LoadPersonsAction(
              url: 'dummy_url_2', loader: mockGetPersons2));

          bloc.add(const LoadPersonsAction(
              url: 'dummy_url_2', loader: mockGetPersons2));
        },
        expect: () => [
          const FetchResult(persons: mockedPersons2, isRetrievedFromCache: false),
          const FetchResult(persons: mockedPersons2, isRetrievedFromCache: true),
        ]);
  });
}
