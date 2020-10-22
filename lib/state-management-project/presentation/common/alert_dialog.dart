import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogPage extends StatelessWidget {
  final BuildContext oldContext;
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  const AlertDialogPage({
    Key key,
    @required this.oldContext,
    @required this.title,
    @required this.content,
    @required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    } else {
      return AlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    }
  }
}
