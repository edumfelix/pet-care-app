import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key});

  @override
  _LoggedInPageState createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  bool _isLoggedIn = false;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    try {
      String? token = await _secureStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) {
        _redirectToLogin();
      } else {
        setState(() {
          _isLoggedIn = true;
        });
      }
    } catch (e) {
      // Tratar erro na leitura do storage
      print('Erro ao ler token: $e');
      _showSnackBar('Erro ao verificar login.');
      _redirectToLogin(); // Redireciona para o login em caso de erro
    }
  }

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    });
  }

  void _logout() async {
    try {
      await _secureStorage.delete(key: 'jwt_token');
      _showSnackBar('Logout realizado com sucesso!'); // Feedback ao usuário
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // Redireciona para /login
    } catch (e) {
      print('Erro durante o logout: $e');
      _showSnackBar('Erro durante o logout.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildLoggedIn() {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(200, 50), // Define o tamanho fixo
      shape: const StadiumBorder(),
      backgroundColor: Colors.brown,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );

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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/consulta');
                },
                style: buttonStyle,
                child: const Text(
                  "Agendar Consulta",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/classificar-imagem');
                },
                style: buttonStyle,
                child: const Text(
                  "Classificar Imagem",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _logout();
                },
                style: buttonStyle,
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
    return _isLoggedIn
        ? _buildLoggedIn()
        : const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
  }
}