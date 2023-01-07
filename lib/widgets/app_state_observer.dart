import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pentellio/services/user_service.dart';
import 'package:universal_html/html.dart';

class AppStateObserver extends StatefulWidget {
  const AppStateObserver(
      {super.key,
      required this.child,
      required this.userService,
      required this.uId});

  final Widget child;
  final UserService userService;
  final String uId;

  @override
  State<AppStateObserver> createState() => _AppStateObserverState();
}

class _AppStateObserverState extends State<AppStateObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      window.onLoad.listen((event) {
        widget.userService.userCameBack(widget.uId);
      });
      window.onUnload.listen((event) async {
        widget.userService.userLeftApp(widget.uId);
      });
    } else {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.userService.userCameBack(widget.uId);
    } else {
      widget.userService.userLeftApp(widget.uId);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
