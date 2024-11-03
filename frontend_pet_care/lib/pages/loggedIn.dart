import 'package:flutter/material.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key});

  @override
  _LoggedInPageState createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  bool _isLoggedIn = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    // Simula a verificação de login
    // Aqui você pode substituir pela lógica real de verificação de login
    setState(() {
      _isLoggedIn = true; // Defina como falso para simular usuário não logado
    });

    if (!_isLoggedIn) {
      _redirectToLogin();
    }
  }

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    });
  }

  Widget _buildLoggedIn() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logged In"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Você está logado!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  backgroundColor: Colors.purple,
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? _buildLoggedIn() : Scaffold();
  }
}