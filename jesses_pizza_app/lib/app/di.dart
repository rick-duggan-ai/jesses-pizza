import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/repositories/auth_repository.dart';
import 'package:jesses_pizza_app/data/repositories/menu_repository.dart';
import 'package:jesses_pizza_app/data/repositories/order_repository.dart';
import 'package:jesses_pizza_app/data/repositories/account_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_menu_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_order_repository.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: 'https://services.jessespizza.com:5000'),
  );
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IMenuRepository>(
    () => MenuRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IOrderRepository>(
    () => OrderRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<IAccountRepository>(
    () => AccountRepository(getIt<ApiClient>()),
  );
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<IAuthRepository>()),
  );
  getIt.registerFactory<MenuBloc>(
    () => MenuBloc(menuRepository: getIt<IMenuRepository>()),
  );
  getIt.registerFactory<CartBloc>(() => CartBloc());
  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(orderRepository: getIt<IOrderRepository>()),
  );
  getIt.registerFactory<AccountBloc>(
    () => AccountBloc(accountRepository: getIt<IAccountRepository>()),
  );
}
