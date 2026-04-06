import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/notices/notices_screen.dart';
import 'screens/erp/erp_screen.dart';
import 'screens/moodle/moodle_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'widgets/shell.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (ctx, state) {
    final auth = ctx.read<AuthProvider>();
    final onAuth = ['/login', '/register']
      .contains(state.matchedLocation);
    if (!auth.isLoggedIn && !onAuth) return '/login';
    if (auth.isLoggedIn  && onAuth)  return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login',
      builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register',
      builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/erp',
      builder: (_, __) => const ERPScreen()),
    GoRoute(path: '/moodle',
      builder: (_, __) => const MoodleScreen()),
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home',
          builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/notices',
          builder: (_, __) => const NoticesScreen()),
        GoRoute(path: '/profile',
          builder: (_, __) => const ProfileScreen()),
      ],
    ),
  ],
);