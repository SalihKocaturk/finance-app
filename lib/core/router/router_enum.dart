enum RouterEnum {
  login(
    '/login',
    'login',
  ),

  register(
    '/register',
    'register',
  ),
  home(
    '/home',
    'home',
  ),
  add(
    '/add',
    'add',
  ),
  profile(
    '/profile',
    'profile',
  ),
  transaction(
    '/transaction',
    'transaction',
  ),
  base(
    '/base',
    'base',
  );

  final String path;
  final String name;

  const RouterEnum(this.path, this.name);
}
