// lib/core/services/crash_route_observer.dart
import 'package:flutter/material.dart';

class CrashRouteObserver extends NavigatorObserver {

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _recordNavigation('push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _recordNavigation('pop', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _recordNavigation('replace', newRoute, oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _recordNavigation('remove', route, previousRoute);
  }

  void _recordNavigation(String action, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final routeName = route?.settings.name ?? 'unknown';
    final previousRouteName = previousRoute?.settings.name ?? 'none';

    // _crashService.recordAppState({
    //   'navigation_action': action,
    //   'current_route': routeName,
    //   'previous_route': previousRouteName,
    //   'timestamp': DateTime.now().toIso8601String(),
    //   'navigation_stack_depth': navigator?.widget.pages.length ?? 0,
    // });

    // // Also record as a code change for tracking user journey
    // _crashService.recordCodeChange(
    //   'navigation',
    //   '$action: $previousRouteName -> $routeName',
    // );
  }
}