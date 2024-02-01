import 'package:dreamy_tales/pages/my_home_page.dart';
import 'package:dreamy_tales/pages/profiling_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dreamy_tales/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
      String? userFriendlyMessage;
      switch (e.code) {
        case 'too-many-request':
          userFriendlyMessage =
              'Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.';
          break;
        case 'user-not-found':
          userFriendlyMessage = 'Nessun utente trovato per quella email.';
          break;
        case 'weak-password':
          userFriendlyMessage = 'Password should be at least 6 characters.';
          break;
        case 'email-already-in-use':
          userFriendlyMessage =
              'The email address is already in use by another account';
          break;
        case 'invalid-email':
          userFriendlyMessage = 'The email address is badly formatted.';
          break;
        case 'INVALID_LOGIN_CREDENTIALS':
          userFriendlyMessage = 'invalid login credentials.';
          break;
        default:
          if (e.message != null) {
            userFriendlyMessage = e.message;
          } else {
            userFriendlyMessage = 'Unknown error';
          }
      }
      setState(() {
        errorMessage = userFriendlyMessage;
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
        MaterialPageRoute(builder: (context) => const ChildProfilePage()),
      );
    } on FirebaseAuthException catch (e) {
      String? userFriendlyMessage;

      switch (e.code) {
        case 'too-many-request':
          userFriendlyMessage =
              'Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.';
          break;
        case 'user-not-found':
          userFriendlyMessage = 'No account found with this email.';
          break;
        case 'weak-password':
          userFriendlyMessage = 'Password should be at least 6 characters.';
          break;
        case 'email-already-in-use':
          userFriendlyMessage =
              'The email address is already in use by another account';
          break;
        case 'invalid-email':
          userFriendlyMessage = 'The email address is badly formatted.';
          break;
        case 'INVALID_LOGIN_CREDENTIALS':
          userFriendlyMessage = 'invalid login credentials.';
          break;
        default:
          if (e.message != null) {
            userFriendlyMessage = e.message;
          } else {
            userFriendlyMessage = 'Unknown error';
          }
      }
      setState(() {
        errorMessage = userFriendlyMessage;
      });
    }
  }

  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Reset Password email sent',
            style: TextStyle(color: Colors.white), // Colore del testo
          ),
          backgroundColor: Colors.red, // Colore dello SnackBar
          duration: Duration(milliseconds: 2000), // Durata in millisecondi
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error, Please insert email correctly and try again',
            style: TextStyle(color: Colors.white), // Colore del testo
          ),
          backgroundColor: Colors.red, // Colore dello SnackBar
          duration: Duration(milliseconds: 2000), // Durata in millisecondi
        ),
      );
    }
  }

  Widget _forgotPasswordButton({required Key key}) {
    return TextButton(
      key: key,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController emailController = TextEditingController();
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width *
                      0.8, // Usa il 80% della larghezza dello schermo
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter your email',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          _resetPassword(emailController.text);
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: 'Password reset email sent',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: const Text(
        'Forgot Password',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
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

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false, required Key key}) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return TextField(
        key: key,
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
          fillColor: Colors.black.withOpacity(0.5),
          // Colore scuro di sfondo
          suffixIcon: isPassword
              ? IconButton(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPassword = !isPassword;
                    });
                  },
                )
              : null,
        ),
      );
    });
  }

  Widget _errorMessage({required Key key}) {
    return Center(
      child: Text(
        key : key,
        errorMessage == '' ? '' : '$errorMessage',
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),

        textAlign: TextAlign.center, // Align text at the center
      ),
    );
  }

  Widget _submitButton({required Key key}) {
    return ElevatedButton(

      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.black.withOpacity(0.5), // Colore scuro di sfondo
      ),
      child: Text(

        key: key,
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
      style:
          TextButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.5)),
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
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _logo(),
              _entryField('email', _controllerEmail, key: const Key('mail')),
              _entryField('password', _controllerPassword, isPassword: true, key: const Key('password')),
              _errorMessage(key : const Key('errorMessage')),
              _forgotPasswordButton(key : const Key('forgotPassword')),
              _submitButton(key: const Key('login/register')),
              _loginOrRegisterButton(),
            ],
          ),
        ]),
      ),
    );
  }
}
