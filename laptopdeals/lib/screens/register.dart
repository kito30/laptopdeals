import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopdeals/services/auth/authresult.dart';
import 'package:laptopdeals/provider/authprovider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
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
            "Register To Laptop Deal",
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
              controller: _passwordController,
              obscureText: togglePassword,
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
              AuthResult result = await authUser.registerUser(email, password);
              if (!context.mounted) return;
              if (result.user != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Register Successfully')),
                );
                Navigator.pushNamed(context, "/main");
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Register Unsuccessfully')),
                );
              }
            },
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}
