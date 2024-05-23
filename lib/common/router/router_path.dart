class RouterPath {
  static const String signIn = '/sign_in';
  static const String signInRoute = '/sign_in';

  static const String signUp = '/sign_up';
  static const String signUpRoute = '/sign_up';

  static const String emailVerified = '/email_verified';
  static const String emailVerifiedRoute = '/email_verified';

  static const String home = '/home';
  static const String homeRoute = '/home';

  static const String account = 'account';
  static const String accountRoute = '$homeRoute/$account';

  static const String payment = 'payment';
  static const String paymentRouteFromHome = '$homeRoute/$payment';
  static const String paymentRouteFromAccount = '$accountRoute/$payment';
}
