import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/data/api/api_client.dart';
import 'package:jesses_pizza_app/data/services/token_storage_service.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _repo;
  final ApiClient _apiClient;
  final TokenStorageService _tokenStorage;

  AuthBloc({
    required IAuthRepository repository,
    required ApiClient apiClient,
    required TokenStorageService tokenStorage,
  })  : _repo = repository,
        _apiClient = apiClient,
        _tokenStorage = tokenStorage,
        super(const AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<GuestLoginRequested>(_onGuestLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<ConfirmAccountRequested>(_onConfirmAccountRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenExpired>(_onTokenExpired);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<CheckStoredAuth>(_onCheckStoredAuth);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final user = await _repo.login(event.email, event.password, event.deviceId);
      _apiClient.setToken(user.token);
      await _tokenStorage.saveUser(user);
      emit(AuthState.authenticated(user: user));
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> _onGuestLoginRequested(
      GuestLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final user = await _repo.guestLogin(event.deviceId);
      _apiClient.setToken(user.token);
      await _tokenStorage.saveUser(user);
      emit(AuthState.authenticated(user: user));
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _repo.createUser(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
      );
      emit(AuthState.signupPending(email: event.email));
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> _onConfirmAccountRequested(
      ConfirmAccountRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _repo.confirmAccount(event.email, event.code);
      // After confirming, user must log in; emit unauthenticated so they proceed to login
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    _apiClient.clearToken();
    await _tokenStorage.clearAll();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onTokenExpired(TokenExpired event, Emitter<AuthState> emit) async {
    _apiClient.clearToken();
    await _tokenStorage.clearAll();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onDeleteAccountRequested(
      DeleteAccountRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _repo.deleteAccount();
      await _tokenStorage.clearAll();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> _onCheckStoredAuth(
      CheckStoredAuth event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final user = await _tokenStorage.restoreUser();
      if (user != null) {
        _apiClient.setToken(user.token);
        emit(AuthState.authenticated(user: user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (_) {
      emit(const AuthState.unauthenticated());
    }
  }
}
