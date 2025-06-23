import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopdeals/services/auth/authresult.dart';
import 'package:laptopdeals/provider/authprovider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool togglePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authCheckProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Log In To Laptop Deal",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter Your Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: TextField(
              obscureText: togglePassword,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter Your Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      togglePassword = !togglePassword;
                    });
                  },
                  icon: Icon(
                    togglePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();
              AuthResult result = await authUser.loginUser(email, password);
              if (!context.mounted) return;
              if (result.user != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Successfully')),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/homepage',
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login unsuccessfully')),
                );
              }
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
