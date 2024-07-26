import 'package:flutter/material.dart';
import 'features/image_processing/presentation/pages/home_page.dart';
import 'features/image_processing/presentation/pages/image_editing_page.dart';
import 'features/image_processing/presentation/pages/profile_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case '/edit':
        return MaterialPageRoute(builder: (_) => ImageEditingPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
