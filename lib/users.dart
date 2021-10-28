library appwrite_flutter;

import 'package:appwrite/appwrite.dart';
import 'package:logging_lite/run_with_trace.dart';
import 'package:appwrite_flutter/appwrite.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }

  static User fromMap(Map<String, dynamic> map) =>
      User(id: map['\$id'], name: map['name'], email: map['email']);
}

class UserSession {
  final String id;
  final String userId;
  final String provider;

  UserSession({required this.id, required this.userId, required this.provider});

  @override
  String toString() {
    return 'UserSession{id: $id, userId: $userId, provider: $provider}';
  }

  static UserSession fromMap(Map<String, dynamic> map) => UserSession(
      id: map['\$id'], userId: map['userId'], provider: map['provider']);
}

class UserRepository {
  final IAppWrite _appWrite;

  UserRepository(this._appWrite);

  Future<UserSession> login(String email, String password) async =>
      runWithTraceAsync<UserSession>(
          'login',
          () => _appWrite.accounts
              .createSession(email: email, password: password)
              .then((response) => UserSession.fromMap(response.data)));

  Future<User> register(String name, String email, String password) async =>
      runWithTraceAsync<User>(
          'register',
          () => _appWrite.accounts
              .create(name: name, email: email, password: password)
              .then((response) => User.fromMap(response.data)));

  Future<Response> recoverPassword(String email) async =>
      runWithTraceAsync<Response>(
          'recover password',
          () => _appWrite.accounts
              .createRecovery(email: email, url: 'http://localhost'));

  Future<User> getCurrentUser() async => runWithTraceAsync<User>(
      'get current user',
      () => _appWrite.accounts
          .get()
          .then((response) => User.fromMap(response.data)));

  Future<void> logOff() async => runWithTraceAsync<void>(
      'logOff', () => _appWrite.accounts.deleteSessions());

  Future<void> removeCurrentUser() async => runWithTraceAsync<void>(
      'remove current user', () => _appWrite.accounts.delete());

  Future<UserSession> anonymousLogin() async => runWithTraceAsync<UserSession>(
      'anonymous login',
      () => _appWrite.accounts
          .createAnonymousSession()
          .then((response) => UserSession.fromMap(response.data)));

  Future<UserSession> magicLinkLogin(String email) async =>
      runWithTraceAsync<UserSession>(
          'magic link login',
          () => _appWrite.accounts
              .createMagicURLSession(email: email)
              .then((response) => UserSession.fromMap(response.data)));
}
