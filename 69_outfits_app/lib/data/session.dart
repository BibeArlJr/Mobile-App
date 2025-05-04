class Session {
  // Singleton
  Session._();
  static final Session _instance = Session._();
  factory Session() => _instance;

  String? username;

  bool get isLoggedIn => username != null;
}
