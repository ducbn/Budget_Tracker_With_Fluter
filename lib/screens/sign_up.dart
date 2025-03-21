import 'package:flutter/material.dart';
import 'package:thu_chi_ca_nhan/screens/login_screens.dart';
import 'package:thu_chi_ca_nhan/services/auth_service.dart';
import 'package:thu_chi_ca_nhan/utils/appvaildator.dart';

class SignUpView extends StatefulWidget {
  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  var authservice = AuthService();
  var isLoader = false;
  var appvalidator = AppValidator();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        "username": _userNameController.text,
        "email": _emailController.text,
        "phone": _phoneNumberController.text,
        "password": _passwordController.text,
        'remainingAmount': 0,
        'totalCredit': 0,
        'totalDebit': 0,
      };
      await authservice.createUser(data, context);

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
                    "https://cdn.tgdd.vn/GameApp/3/228487/Screentshots/misa-ung-dung-theo-doi-quan-ly-tai-chinh-ca-nhan-228487-logo-09-09-2020.png",
                    width: 120,
                    height: 120,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Tạo tài khoản mới",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildTextField(_userNameController, "Tên đăng nhập", Icons.person, appvalidator.validateUserName, iconColor: Colors.orange),
                  SizedBox(height: 12),
                  _buildTextField(_emailController, "Email", Icons.email, appvalidator.validateEmail, iconColor: Colors.blue),
                  SizedBox(height: 12),
                  _buildTextField(_phoneNumberController, "Số điện thoại", Icons.phone, appvalidator.validatePhoneNumber, iconColor: Colors.green),
                  SizedBox(height: 12),
                  _buildTextField(_passwordController, "Mật khẩu", Icons.lock, appvalidator.validatePassWord, isPassword: true, iconColor: Colors.red),
                  SizedBox(height: 40),
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
                        "Đăng ký",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
                    },
                    child: Text(
                      "Đã có tài khoản? Đăng nhập",
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