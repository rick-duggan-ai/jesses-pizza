import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_state.dart';

class MockAccountRepository extends Mock implements IAccountRepository {}

void main() {
  late MockAccountRepository mockRepo;

  final tProfile = <String, dynamic>{'firstName': 'Jesse', 'lastName': 'Smith'};
  final tAddresses = <Address>[];
  final tCreditCards = <CreditCard>[];

  setUp(() {
    mockRepo = MockAccountRepository();
  });

  group('AccountBloc', () {
    test('initial state is AccountInitial', () {
      final bloc = AccountBloc(repository: mockRepo);
      expect(bloc.state, const AccountState.initial());
      bloc.close();
    });

    blocTest<AccountBloc, AccountState>(
      'emits [loading, loaded] on LoadProfile success',
      build: () {
        when(() => mockRepo.getAccountInfo()).thenAnswer((_) async => tProfile);
        when(() => mockRepo.getAddresses()).thenAnswer((_) async => tAddresses);
        when(() => mockRepo.getCreditCards()).thenAnswer((_) async => tCreditCards);
        return AccountBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const AccountEvent.loadProfile()),
      expect: () => [
        const AccountState.loading(),
        AccountState.loaded(
          profile: tProfile,
          addresses: tAddresses,
          creditCards: tCreditCards,
        ),
      ],
    );

    blocTest<AccountBloc, AccountState>(
      'emits [loading, error] on LoadProfile failure',
      build: () {
        when(() => mockRepo.getAccountInfo())
            .thenThrow(Exception('Network error'));
        when(() => mockRepo.getAddresses()).thenAnswer((_) async => tAddresses);
        when(() => mockRepo.getCreditCards()).thenAnswer((_) async => tCreditCards);
        return AccountBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const AccountEvent.loadProfile()),
      expect: () => [
        const AccountState.loading(),
        isA<AccountError>(),
      ],
    );
  });
}
