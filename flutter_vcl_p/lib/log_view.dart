import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogView extends StatelessWidget {

  void _onDelete() {
    print('on delete');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Log'),
        trailing: CupertinoButton(
            child: Icon(Icons.delete),
            onPressed: _onDelete,
        ),
      ),
      child: Center(
          child: Text(
              'log'),
      ),
    );
  }
}