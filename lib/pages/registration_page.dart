import 'package:flutter/material.dart';
import 'package:dzirieat_app/functions/user_functions.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import firebase_auth

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}


class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _errorMessage = '';
  String _selectedRole = 'user';
  final List<String> _roles = ['user', 'admin'];
  static const Color burgundy = Color(0xFF800020);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/door.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/DZIR2.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 40),
                      buildTextField(_emailController, "Email", Icons.email),
                      SizedBox(height: 20),
                      buildTextField(_passwordController, "Password", Icons.lock, isPassword: true),
                      SizedBox(height: 20),
                      buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock_outline, isPassword: true),
                      SizedBox(height: 20),
                      buildRoleDropdown(),
                      SizedBox(height: 20),
                      if (_errorMessage.isNotEmpty)
                        Text(_errorMessage, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 30),
                      buildRegisterButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: burgundy),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: burgundy),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: burgundy),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        if (controller == _confirmPasswordController && value != _passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  Widget buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      style: TextStyle(color: Colors.white),
      dropdownColor: Colors.grey[800],
      decoration: InputDecoration(
        labelText: 'Select Role',
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: burgundy),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: burgundy),
        ),
      ),
      items: _roles.map((String role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() => _selectedRole = newValue!);
      },
    );
  }

  Widget buildRegisterButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          User? user = await UserFunctions().registerUser(
            _emailController.text,
            _passwordController.text,
          );

          if (user != null) {
            await UserFunctions().registerUserWithRole(user.uid, _selectedRole);
            setState(() => _errorMessage = '');
            Navigator.pushReplacementNamed(context, '/');
          } else {
            setState(() => _errorMessage = 'Registration failed. Please try again.');
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: burgundy,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text("Register", style: TextStyle(fontSize: 16)),
    );
  }
}