import 'package:data_loop/Views/AuthScreens/ConnexionScreen.dart';
import 'package:data_loop/Views/AuthScreens/InscriptionScreen.dart';
import 'package:data_loop/Views/DashboardScreen.dart';
import 'package:data_loop/ViewsModels/AuthViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await initialisationConnexion();
    });
  }

  //initialiser l'authentification
  Future<void> initialisationConnexion() async {
    final auth = context.read<Authviewmodel>();

    await auth.init();
    if (auth.estConnecte) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboardscreen()),
          (route) => false,
        );
      }
    } else {
      if (auth.numeroSauvegarder != null) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Connexionscreen()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Inscriptionscreen()),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              ClipRRect(
                child: Image.asset("assets/images/DataLoop3.png", width: 250),
              ),
              Container(
                child: Column(
                  children: [Center(child: CircularProgressIndicator())],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
