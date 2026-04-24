import 'package:data_loop/Views/AuthScreens/InscriptionScreen.dart';
import 'package:data_loop/Views/AuthScreens/RecoverPin.dart';
import 'package:data_loop/Views/DashboardScreen.dart';
import 'package:data_loop/ViewsModels/AuthViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../Constantes/Couleurs.dart';

class Connexionscreen extends StatefulWidget {
  const Connexionscreen({super.key});

  @override
  State<Connexionscreen> createState() => _ConnexionscreenState();
}

class _ConnexionscreenState extends State<Connexionscreen> {
  final TextEditingController _controllerPin = TextEditingController();

  String? messageErreur;
  bool erreur = false;

  Future<void> connexion() async {
    final auth = context.read<Authviewmodel>();
    try {
      await auth.seConnecter(_controllerPin.text);
      if (!mounted) {
        return;
      }
      if (auth.errrorMessage == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboardscreen()),
          (route) => false,
        );
      } else {
        if (mounted) {
          setState(() {
            messageErreur = auth.errrorMessage;
            erreur = true;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 125.h, horizontal: 10.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  child: Image.asset(
                    "assets/images/DataLoop3.png",
                    width: 250.w,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Bon retour sur DataLoop",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25.sp,
                  ),
                ),
                Text(
                  "La première plateforme de Crowdsourcing ivoirienne",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.sp,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Text(
                          "Connexion",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.sp,
                          ),
                        ),
                        if (erreur)
                          Text(
                            textAlign: TextAlign.center,
                            "$messageErreur",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Couleurs.emergencyRed,
                            ),
                          ),
                        Text(
                          "Veuillez saisir votre pin à 8 chiffres",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Pinput(
                          length: 8,
                          obscureText: true,
                          obscuringCharacter: "●",
                          keyboardType: TextInputType.number,
                          controller: _controllerPin,
                        ),
                        SizedBox(height: 12.h),
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
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: Text(
                                  "Connexion",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Recoverpin(),
                              ),
                            );
                          },
                          child: Text(
                            "Code PIN oublié ?",
                            style: TextStyle(
                              color: Couleurs.accentOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 0.5),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Pas encore de compte?"),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Inscriptionscreen(),
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
