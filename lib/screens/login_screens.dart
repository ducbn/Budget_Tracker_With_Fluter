import 'package:flutter/material.dart';
import 'package:thu_chi_ca_nhan/screens/sign_up.dart';
import 'package:thu_chi_ca_nhan/services/auth_service.dart';
import 'package:thu_chi_ca_nhan/utils/appvaildator.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;
  var authservice = AuthService();
  var appvalidator = AppValidator();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };
      await authservice.login(data, context);
      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn.tgdd.vn/GameApp/3/228487/Screentshots/misa-ung-dung-theo-doi-quan-ly-tai-chinh-ca-nhan-228487-logo-09-09-2020.png',
                    height: 100,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Welcome Back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 50.0),
                  _buildTextField(_emailController, "Email", Icons.email, appvalidator.validateEmail, iconColor: Colors.blue),
                  SizedBox(height: 16.0),
                  _buildTextField(_passwordController, "Password", Icons.lock, appvalidator.validatePassWord, isPassword: true, iconColor: Colors.red),
                  SizedBox(height: 40.0),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (!isLoader) _submitForm();
                      },
                      child: isLoader
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpView()),
                      );
                    },
                    child: Text(
                      "Create a new account",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, String? Function(String?)? validator, {bool isPassword = false, Color iconColor = Colors.grey}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: hint,
        prefixIcon: Icon(icon, color: iconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}