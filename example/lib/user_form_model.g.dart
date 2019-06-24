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
