import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/recovery_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/card_detail/presentation/card_detail_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';
import '../../features/collection/presentation/collection_screen.dart';
import '../../features/want_list/presentation/want_list_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../models/card_model.dart';


// Placeholder screens for router initialization
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title, style: Theme.of(context).textTheme.displayMedium)),
    );
  }
}

final goRouter = GoRouter(
  initialLocation: '/login', // Will be controlled by Auth state later
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/recovery',
      builder: (context, state) => const RecoveryScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
  path: '/card_detail',
  builder: (context, state) {
    final card = state.extra as CardModel;
    return CardDetailScreen(card: card);
        },
      ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/collection',
      builder: (context, state) => const CollectionScreen(),
    ),
    GoRoute(
      path: '/want_list',
      builder: (context, state) => const WantListScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
