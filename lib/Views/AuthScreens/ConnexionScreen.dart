import 'package:data_loop/Views/AuthScreens/InscriptionScreen.dart';
import 'package:data_loop/Views/AuthScreens/RecoverPin.dart';
import 'package:data_loop/Views/DashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../Constantes/Couleurs.dart';

class Connexionscreen extends StatefulWidget {
  const Connexionscreen({super.key});

  @override
  State<Connexionscreen> createState() => _ConnexionscreenState();
}

class _ConnexionscreenState extends State<Connexionscreen> {
  final TextEditingController _controllerPin = TextEditingController();

  Future<void> connexion() async {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboardscreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:125,horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(child: Image.asset("assets/images/DataLoop3.png",width: 250,),),
                SizedBox(height: 20,),
                Text(
                  "Bon retour sur DataLoop",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                ),
                Text(
                  "La première plateforme de Crowdsourcing ivoirienne",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Connexion",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          "Veuillez saisir votre pin à 6 chiffres",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 10),
                        Pinput(
                          length: 6,
                          obscureText: true,
                          obscuringCharacter: "●",
                          keyboardType: TextInputType.number,
                          controller: _controllerPin,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  await connexion();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Couleurs.accentOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Connexion",style: TextStyle(
                                  color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18
                                ),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 0.5),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Pas encore de compte?"),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Inscriptionscreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "S'inscrire",
                                      style: TextStyle(
                                        color: Couleurs.accentOrange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
