enum RouterEnum {
  login(
    '/login',
    'login',
  ),
  home(
    '/home',
    'home',
  ),
  register(
    '/register',
    'register',
  );

  final String path;
  final String name;

  const RouterEnum(this.path, this.name);
}
