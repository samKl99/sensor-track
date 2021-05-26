import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/sensor_track_button.dart';
import 'package:sensor_track/components/sensor_track_text_field.dart';
import 'package:sensor_track/services/authentication_service.dart';
import 'package:sensor_track/services/snackbar_service.dart';
import 'package:sensor_track/style/style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  late bool _isLoginFlow;
  late bool _isEmailValid;
  late bool _isPasswordValid;
  late bool _isPasswordConfirmValid;
  late bool _isLoading;

  bool get _isLoginButtonEnabled {
    if (_isLoginFlow) {
      return _isEmailValid && _isPasswordValid;
    } else {
      return _isEmailValid && _isPasswordValid && _isPasswordConfirmValid;
    }
  }

  AuthenticationService get _authenticationService => Provider.of<AuthenticationService>(context, listen: false);

  @override
  void initState() {
    _isLoginFlow = true;
    _isEmailValid = false;
    _isPasswordValid = false;
    _isPasswordConfirmValid = false;
    _isLoading = false;

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _passwordConfirmController.addListener(_onPasswordConfirmChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        children: [
          const SizedBox(
            height: 120.0,
          ),
          header,
          const SizedBox(
            height: 80.0,
          ),
          emailInput,
          const SizedBox(
            height: 16.0,
          ),
          passwordInput,
          !_isLoginFlow
              ? Column(
                  children: [
                    const SizedBox(
                      height: 16.0,
                    ),
                    passwordConfirmInput,
                  ],
                )
              : Container(),
          const SizedBox(
            height: 40.0,
          ),
          submitButton,
          const SizedBox(
            height: 16.0,
          ),
          registerButton,
        ],
      ),
    );
  }

  Widget get header => Column(
        children: [
          Image.asset(
            "assets/logo.png",
            width: 200.0,
          ),
        ],
      );

  Widget get emailInput => SensorTrackTextField(
        controller: _emailController,
        hint: "E-Mail Adresse",
        keyBoardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return _validateEmail(value);
        },
      );

  Widget get passwordInput => SensorTrackTextField(
        controller: _passwordController,
        hint: "Passwort",
        obscureText: true,
      );

  Widget get passwordConfirmInput => SensorTrackTextField(
        controller: _passwordConfirmController,
        hint: "Passwort wiederholen",
        obscureText: true,
      );

  Widget get submitButton => SensorTrackButton(
        text: _isLoginFlow ? "Login" : "Registrieren",
        textStyle: const TextStyle(
          fontSize: 18.0,
        ),
        color: Theme.of(context).accentColor,
        loading: _isLoading,
        onPressed: _isLoginButtonEnabled ? _authenticateWithCredentials : null,
      );

  Widget get registerButton => SensorTrackButton(
        text: _isLoginFlow ? "Registrieren" : "Anmelden",
        textStyle: const TextStyle(
          fontSize: 18.0,
        ),
        color: primaryColorLight,
        onPressed: _changeLoginFlow,
      );

  Future<void> _authenticateWithCredentials() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (_isLoginFlow) {
        await _authenticationService.login(email, password);
      } else {
        await _authenticationService.register(email, password);
      }
    } catch (e) {
      SnackBarService.showErrorSnackBar(context, "${_isLoginFlow ? "Login" : "Registrierung"} fehlgeschlagen");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeLoginFlow() {
    setState(() {
      _isLoginFlow = !_isLoginFlow;
    });
  }

  void _onEmailChanged() {
    setState(() {
      _isEmailValid = EmailValidator.validate(_emailController.text);
    });
  }

  void _onPasswordChanged() {
    setState(() {
      _isPasswordValid = _passwordController.text.isNotEmpty;
    });
  }

  void _onPasswordConfirmChanged() {
    setState(() {
      _isPasswordConfirmValid = _passwordConfirmController.text.trim() == _passwordController.text.trim();
    });
  }

  String? _validateEmail(final String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "Bitte eine E-Mail Adresse eingeben";
      }
      if (!EmailValidator.validate(value)) {
        return "Die E-Mail Adresse ist nicht gültig";
      }
    }

    return null;
  }
}
