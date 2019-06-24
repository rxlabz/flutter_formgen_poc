import 'package:formgen_lib/formgen_lib.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

//import 'target_login_form.dart';

part 'user_form_model.g.dart';

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final UserFormModel formModel = UserFormModel();

  @override
  void initState() {
    formModel.addListener(() => print('submitted values ${formModel.values}'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UserForm(formModel),
      ),
    );
  }
}

@RXForm()
class UserFormModel extends ValueNotifier {
  @required
  String email;
  String emailValidator(String value) =>
      validateMail(value) ?? validateRequired(value);

  String firstname;
  String firstnameValidator(String value) => null;

  String lastname;
  String lastnameValidator(String value) => null;

  @required
  @obscure
  String password;
  String passwordValidator(String value) => validateRequired(value);

  Map<String, dynamic> get values => {
        'login': email,
        'password': password,
        'firstname': password,
        'password': password,
      };

  UserFormModel({this.email, this.password}) : super(null);

  onSubmit() {
    notifyListeners();
  }
}
