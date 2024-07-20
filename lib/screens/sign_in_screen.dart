import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oziovariasi/screens/home_screen.dart';
import 'package:oziovariasi/screens/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;

  const SignInScreen({super.key, this.onThemeChanged});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  List<bool> _selection = [false, true];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('OZIOVARIASI',
            style: TextStyle(color: textTheme.headlineSmall?.color)),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 32.0),
            ToggleButtons(
              isSelected: _selection,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < _selection.length; i++) {
                    _selection[i] = i == index;
                  }
                });
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                }
              },
              color: textTheme.labelLarge?.color,
              selectedColor: Colors.white,
              fillColor: Colors.black,
              borderColor: Colors.black,
              selectedBorderColor: Colors.black,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text('Sign Up'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text('Sign In'),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textTheme.headlineSmall?.color,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email*',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password*',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();
                final password = _passwordController.text;

                if (email.isEmpty || !isValidEmail(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid email'),
                    ),
                  );
                  return;
                }

                if (password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your password'),
                    ),
                  );
                  return;
                }

                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen(
                      onThemeChanged: widget.onThemeChanged,
                    )),
                  );
                } on FirebaseAuthException catch (error) {
                  if (error.code == 'user-not-found') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No user found with that email')),
                    );
                  } else if (error.code == 'wrong-password') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wrong password. Please try again.')),
                    );
                  } else {
                    setState(() {
                      _errorMessage = error.message ?? 'An error occurred';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_errorMessage),
                      ),
                    );
                  }
                } catch (error) {
                  setState(() {
                    _errorMessage = error.toString();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_errorMessage),
                    ),
                  );
                }
              },
              child: const Text('Sign In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 200.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    String emailRegex =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }
}
