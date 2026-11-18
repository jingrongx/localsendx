import 'package:refena_flutter/addons.dart';

/// Backports the pop-until actions of refena_flutter >= 3.4.
///
/// refena_flutter 3.4 cannot be used because it requires a newer Dart SDK
/// than the Flutter 3.32 toolchain this project is pinned to.
abstract class NavigateActionCompat {
  NavigateActionCompat._();

  /// Pops all routes until there is only one left.
  static NavigationPopUntilRootAction popUntilRoot() => NavigationPopUntilRootAction();

  /// Pops all routes until the specified page.
  static NavigationPopUntilAction<T> popUntil<T>() => NavigationPopUntilAction<T>();
}

/// Pops all routes until there is only one left.
class NavigationPopUntilRootAction extends BaseNavigationPopAction {
  @override
  void reduce() {
    ref.read(navigationProvider).key.currentState?.popUntil((route) => route.isFirst);
  }

  @override
  String get debugLabel => 'NavigationPopUntilRootAction()';
}

/// Pops all routes until the specified page.
class NavigationPopUntilAction<T> extends BaseNavigationPopAction {
  @override
  void reduce() {
    // Falls back to the root route when no page of type [T] is on the stack,
    // matching refena_flutter 3.5 (`NavigationService.popUntil`). Without the
    // fallback, e.g. `popUntil<WebSharePage>()` on a regular receive flow
    // popped the root route and left the navigator empty (black screen).
    ref.read(navigationProvider).key.currentState?.popUntil((route) => route.settings.name == T.toString() || route.isFirst);
  }

  @override
  String get debugLabel => 'NavigationPopUntilAction($T)';
}
