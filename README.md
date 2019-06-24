# Flutter form generation POC

A little code generation experimentation : Define a FormModel, and generate a FormWidget

For example, this model : 

```dart
@RXForm()
class UserFormModel extends ValueNotifier<Map<String, String>> {
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
  Map<String, String> get value => {
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
```

will generate

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_form_model.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

class UserForm extends StatefulWidget {
  UserForm(this.model);

  final UserFormModel model;

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController;

  TextEditingController firstnameController;

  TextEditingController lastnameController;

  TextEditingController passwordController;

  bool _autovalidate = false;

  @override
  void initState() {
    emailController = TextEditingController();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(children: [
          TextFormField(
              key: Key('emailField'),
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: widget.model.emailValidator,
              onSaved: (value) => widget.model.email = value,
              autovalidate: _autovalidate),
          TextFormField(
              key: Key('firstnameField'),
              controller: firstnameController,
              decoration: InputDecoration(labelText: 'Firstname'),
              onSaved: (value) => widget.model.firstname = value),
          TextFormField(
              key: Key('lastnameField'),
              controller: lastnameController,
              decoration: InputDecoration(labelText: 'Lastname'),
              onSaved: (value) => widget.model.lastname = value),
          TextFormField(
              key: Key('passwordField'),
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              validator: widget.model.passwordValidator,
              onSaved: (value) => widget.model.password = value,
              autovalidate: _autovalidate),
          RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  widget.model.onSubmit();
                } else
                  setState(() => _autovalidate = true);
              })
        ]));
  }
}
```

and could be used this way : 

```dart
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
```

## Resources

- [BoringShow](https://www.youtube.com/watch?v=mYDFOdl-aWM)
- [Code generation in Dart : the basics](https://medium.com/flutter-community/part-1-code-generation-in-dart-the-basics-3127f4c842cc)
- [Code generation in Dart : source_gen & build_runner](https://medium.com/flutter-community/part-2-code-generation-in-dart-annotations-source-gen-and-build-runner-bbceee28697b)

- source code generation lib : [code_builder](https://pub.dartlang.org/packages/code_builder)