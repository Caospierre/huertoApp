import 'package:flutter/material.dart';
import 'package:huerto_app/src/services/hasura_service.dart';
import 'auth_service.dart';
import 'navigator_service.dart';

class InitServices {
  final AuthService authService;
  final NavigatorService navigatorService;
  final hasuraService;
  InitServices({
    this.authService,
    this.navigatorService,
    this.hasuraService,
  });

  static Future<InitServices> initialize() async {
    final AuthService _authService = new AuthService();
    final NavigatorService _navigatorService = new NavigatorService();
    final HasuraService _hasuraService = new HasuraService();

    return InitServices(
      authService: _authService,
      navigatorService: _navigatorService,
      hasuraService: _hasuraService,
    );
  }

  static InitServices of(BuildContext context) {
    final provider = context
        .getElementForInheritedWidgetOfExactType<ServicesProvider>()
        .widget as ServicesProvider;
    return provider.services;
  }
}

class ServicesProvider extends InheritedWidget {
  final InitServices services;

  ServicesProvider({Key key, this.services, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(ServicesProvider old) {
    if (services != old.services) {
      throw Exception('Services must be constant!');
    }
    return false;
  }
}
