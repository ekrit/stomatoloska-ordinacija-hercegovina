import 'package:flutter/widgets.dart';

/// Root navigator key so non-widget code (e.g. the global 401 handler)
/// can navigate without a BuildContext.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
