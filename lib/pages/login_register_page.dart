import 'package:dreamy_tales/pages/my_home_page.dart';
import 'package:dreamy_tales/pages/profiling_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dreamy_tales/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChildProfilePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }


  Widget _logo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Image.asset(
        'assets/logo_login.jpeg',
        height: 130, // Aumentato del 20%
      ),
    );
  }


  Widget _entryField(
      String title,
      TextEditingController controller,
      {bool isPassword = false}
      ) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return TextField(
              controller: controller,
              obscureText: isPassword,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: title,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.5), // Colore scuro di sfondo
                suffixIcon: isPassword ? IconButton(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPassword = !isPassword;
                    });
                  },
                ) : null,
              ),
            );
          }
        );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Warning ? $errorMessage',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.5), // Colore scuro di sfondo
      ),
      child: Text(
        isLogin ? 'Login' : 'Register',
        style: const TextStyle(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.5)
      ),
      child: Text(
        isLogin ? 'Register instead' : 'Login instead',
        style: const TextStyle(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sfondo_login.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _logo(),
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassword, isPassword: true),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
