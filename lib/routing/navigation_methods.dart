import 'package:flutter/material.dart';

class NavigationMethods {
  final BuildContext _context;
  NavigationMethods.of(this._context);
  
  Future navigateTo(Widget screen, String name) async =>
      await Navigator.of(_context).push(route(screen, name));

  Future navigateNamedTo<T>({String path = '/', T? args}) async =>
      await Navigator.of(_context).pushNamed(path, arguments: args);

  Future popAndNavigateNamedTo({String path = '/'}) async {
    Navigator.pop(_context);
    await navigateNamedTo(path: path);
  }

  Future navigateAndReplacementTo(Widget screen, String name) async =>
      await Navigator.of(_context).pushReplacement(route(screen, name));

  Future navigateNamedAndReplacementTo<T>({String path = '/', T? args}) async =>
      await Navigator.of(_context).pushReplacementNamed(path, arguments: args);

  Future navigateAndRemoveUntil(Widget screen, String name) async =>
      await Navigator.of(_context)
          .pushAndRemoveUntil(route(screen, name), (Route<dynamic> route) => false);

  Future navigateNamedAndRemoveUntil<T>({String path = '/', T? args}) async =>
      await Navigator.of(_context)
          .pushNamedAndRemoveUntil(path, (Route<dynamic> route) => false, arguments: args);
}

Route route(Widget page, String name) {
  return PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
    return page;
  }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }, settings: RouteSettings(name: name));
}
