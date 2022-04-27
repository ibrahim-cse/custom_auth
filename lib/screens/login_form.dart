// Email: eve.holt@reqres.in
// Password: cityslicka
// Token: QpwL5tke4Pnpja7X4

import 'package:custom_auth/api/api_service.dart';
import 'package:custom_auth/common/progressHUD.dart';
import 'package:custom_auth/model/login_model.dart';
import 'package:custom_auth/screens/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool hidePassword = true;
  LoginRequestModel? requestModel;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    requestModel = LoginRequestModel(email: '', password: '');
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).accentColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.2),
                              offset: const Offset(0, 10),
                              blurRadius: 20)
                        ]),
                    child: Form(
                      key: globalFormKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) => requestModel!.email = input!,
                            validator: (input) => !input!.contains("@")
                                ? 'Email ID should be valid'
                                : null,
                            decoration: const InputDecoration(
                              hintText: 'Email Address',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff0001234),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff0001234),
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color(0xff0001234),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => requestModel!.password = input!,
                            validator: (input) => input!.length < 3
                                ? 'Password should be more than three character'
                                : null,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff0001234),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff0001234),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xff0001234),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                icon: Icon(hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                color: const Color(0xff0001234),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (validateAndSave()) {
                                setState(() {
                                  isApiCallProcess = true;
                                });
                                APIService apiService = APIService();
                                apiService.login(requestModel!).then((value) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  if (value.token.isNotEmpty) {
                                    const snackBar = SnackBar(
                                      content: Text('Login successful'),
                                    );
                                    scaffoldKey.currentState
                                        ?.showSnackBar(snackBar);
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
                                      );
                                    });
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text(value.error),
                                    );
                                    scaffoldKey.currentState
                                        ?.showSnackBar(snackBar);
                                  }
                                });
                                print(requestModel!.toJson());
                              }
                            },
                            child: const Text('Login'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
