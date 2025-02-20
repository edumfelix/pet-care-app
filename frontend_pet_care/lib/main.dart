import 'package:flutter/material.dart';
import 'package:frontend_pet_care/pages/classificarImagemPage.dart';
import 'package:frontend_pet_care/pages/loggedIn.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/horarioConsultaPage.dart';
import 'pages/consultaPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
      routes: {
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/loggedin': (context) => const LoggedInPage(),
        '/horario-consulta': (context) =>  const HorarioConsultaPage(),
        '/consulta': (context) => const ConsultaPage(),
        '/classificar-imagem': (context) => const ClassificarImagemPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/pet_logo.png',
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Welcome to Pet Care!',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.brown, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildButton('Sign Up', '/signup'),
              const SizedBox(height: 20),
              _buildButton('Login', '/login'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, String route) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [Colors.brown.shade300, Colors.brown.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18), backgroundColor: Colors.transparent, disabledForegroundColor: Colors.transparent.withOpacity(0.38), disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ), // Transparent background
        ),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
