import 'package:ecommerce_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change password"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 6.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Your email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                obscureText: true,
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  hintText: "Your current password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                obscureText: true,
                controller: _newPasswordController,
                decoration: InputDecoration(
                  hintText: "Your new password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  loadDialog();
                  changePassword(
                    email: _emailController.text,
                    currentPassword: _currentPasswordController.text,
                    newPassword: _newPasswordController.text,
                  );
                },
                child: Text("Change password"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadDialog() {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (email.isNotEmpty &&
        currentPassword.isNotEmpty &&
        newPassword.isNotEmpty) {
      try {
        await authService.value.changePassword(
          email: email,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

        if (mounted) {
          int count = 0;
          Navigator.popUntil(context, (_) => count++ >= 2);
        }
        _emailController.clear();
        _currentPasswordController.clear();
        _newPasswordController.clear();
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message as String;
        });
        if (mounted) Navigator.pop(context);
      }
    } else {
      await Future.delayed(Durations.long4);
      setState(() {
        errorMessage = "One of the fields is empty";
      });
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
