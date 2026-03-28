import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/api/api_endpoints.dart';
import 'package:jesses_pizza_app/presentation/screens/account/privacy_policy_screen.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    final getIt = GetIt.instance;
    if (getIt.isRegistered<ApiClient>()) {
      getIt.unregister<ApiClient>();
    }
    getIt.registerSingleton<ApiClient>(mockApiClient);
  });

  tearDown(() {
    final getIt = GetIt.instance;
    if (getIt.isRegistered<ApiClient>()) {
      getIt.unregister<ApiClient>();
    }
  });

  Widget buildSubject({bool requireAcceptance = false}) {
    return MaterialApp(
      home: PrivacyPolicyScreen(requireAcceptance: requireAcceptance),
    );
  }

  group('PrivacyPolicyScreen', () {
    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<Response<dynamic>>();
      when(() => mockApiClient.get<dynamic>(ApiEndpoints.privacy))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future so no timer is left pending
      completer.complete(Response(
        requestOptions: RequestOptions(path: ApiEndpoints.privacy),
        data: 'Policy text',
      ));
      await tester.pumpAndSettle();
    });

    testWidgets('displays privacy policy text when loaded', (tester) async {
      when(() => mockApiClient.get<dynamic>(ApiEndpoints.privacy))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiEndpoints.privacy),
                data: 'We respect your privacy and protect your data.',
              ));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(
        find.text('We respect your privacy and protect your data.'),
        findsOneWidget,
      );
    });

    testWidgets('displays policy from map response with content key',
        (tester) async {
      when(() => mockApiClient.get<dynamic>(ApiEndpoints.privacy))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiEndpoints.privacy),
                data: {'content': 'Policy from map.'},
              ));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Policy from map.'), findsOneWidget);
    });

    testWidgets('shows error and retry button on failure', (tester) async {
      when(() => mockApiClient.get<dynamic>(ApiEndpoints.privacy))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.privacy),
        message: 'Network error',
      ));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(
        find.text('Unable to load privacy policy. Please try again.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('retry button re-fetches policy', (tester) async {
      var callCount = 0;
      when(() => mockApiClient.get<dynamic>(ApiEndpoints.privacy))
          .thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          throw DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.privacy),
            message: 'Network error',
          );
        }
        return Response(
          requestOptions: RequestOptions(path: ApiEndpoints.privacy),
          data: 'Loaded on retry.',
        );
      });

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Loaded on retry.'), findsOneWidget);
    });

    testWidgets('does not show I Agree button when requireAcceptance is false',
        (tester) async {
      when(() => mockApiClient.get<dynamic>(ApiEndpoints.privacy))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiEndpoints.privacy),
                data: 'Policy text.',
              ));

      await tester.pumpWidget(buildSubject(requireAcceptance: false));
      await tester.pumpAndSettle();

      expect(find.text('I Agree'), findsNothing);
    });

    testWidgets('shows I Agree button when requireAcceptance is true',
        (tester) async {
      when(() => mockApiClient.get<dynamic>(ApiEndpoints.privacy))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiEndpoints.privacy),
                data: 'Policy text.',
              ));

      await tester.pumpWidget(buildSubject(requireAcceptance: true));
      await tester.pumpAndSettle();

      expect(find.text('I Agree'), findsOneWidget);
    });

    testWidgets('I Agree button pops with true', (tester) async {
      bool? poppedValue;

      when(() => mockApiClient.get<dynamic>(ApiEndpoints.privacy))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiEndpoints.privacy),
                data: 'Policy text.',
              ));

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedValue = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) =>
                      const PrivacyPolicyScreen(requireAcceptance: true),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('I Agree'), findsOneWidget);
      await tester.tap(find.text('I Agree'));
      await tester.pumpAndSettle();

      expect(poppedValue, isTrue);
    });

    testWidgets('has Privacy Policy title in app bar', (tester) async {
      when(() => mockApiClient.get<dynamic>(ApiEndpoints.privacy))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiEndpoints.privacy),
                data: 'Text.',
              ));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget);
    });
  });
}
