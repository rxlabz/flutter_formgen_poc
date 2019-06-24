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
    formModel.addListener(() => print('submitted values ${formModel.value}'));
    super.initState();
  }

  @override
  void dispose() {
    formModel.dispose();
    super.dispose();
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

  String lastname;

  @required
  @obscure
  String password;
  String passwordValidator(String value) => validateRequired(value);

  @override
  Map<String, dynamic> get value => {
        'email': email,
        'lastname': lastname,
        'firstname': firstname,
        'password': password,
      };
  @override
  set value(_) {}

  UserFormModel({this.email, this.password}) : super(null);

  onSubmit() => notifyListeners();
}
