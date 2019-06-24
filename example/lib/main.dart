
import 'package:flutter/material.dart';

import 'user_form_model.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserFormScreen(),
    );
  }
}
