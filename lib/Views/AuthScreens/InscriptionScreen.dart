import 'package:data_loop/Constantes/Couleurs.dart';
import 'package:data_loop/Models/TempData.dart';
import 'package:data_loop/Views/AuthScreens/ConfirmerNumeroScreen.dart';
import 'package:data_loop/Views/AuthScreens/ConnexionScreen.dart';
import 'package:data_loop/Views/AuthScreens/DefinirPinScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Inscriptionscreen extends StatefulWidget {
  const Inscriptionscreen({super.key});

  @override
  State<Inscriptionscreen> createState() => _InscriptionscreenState();
}

class _InscriptionscreenState extends State<Inscriptionscreen> {
  final TextEditingController _nomPrenom = TextEditingController();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _telephone = TextEditingController();

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
                  "Bienvenu(e) sur DataLoop",
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
                          "Inscription",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TextField(
                          controller: _nomPrenom,
                          keyboardType: TextInputType.text,
                          scrollPhysics: ScrollPhysics(),
                          decoration: InputDecoration(
                            hintText: 'Nom & prénoms',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          scrollPhysics: ScrollPhysics(),
                          decoration: InputDecoration(
                            hintText: 'E-mail',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TextField(
                          controller: _telephone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Numéro de télépghone',
                            prefixText: '+225',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 0.5.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  Tempdata tempData = Tempdata(
                                    nomPrenom: _nomPrenom.text,
                                    email: _email.text,
                                    telephone: _telephone.text,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Definirpinscreen(tempData: tempData),
                                    ),
                                  );
                                },
                                label: Text(
                                  "Continuer",
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: Icon(
                                  CupertinoIcons.arrow_right,
                                  color: Colors.white,
                                ),
                                iconAlignment: IconAlignment.end,
                                style: TextButton.styleFrom(
                                  backgroundColor: Couleurs.darkGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                          Center(
                            child: Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Déjà un compte?"),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Connexionscreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Se connecter",
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
