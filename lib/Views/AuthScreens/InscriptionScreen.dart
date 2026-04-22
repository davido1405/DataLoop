import 'package:data_loop/Constantes/Couleurs.dart';
import 'package:data_loop/Views/AuthScreens/ConfirmerNumeroScreen.dart';
import 'package:data_loop/Views/AuthScreens/ConnexionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Inscriptionscreen extends StatefulWidget {
  const Inscriptionscreen({super.key});

  @override
  State<Inscriptionscreen> createState() => _InscriptionscreenState();
}

class _InscriptionscreenState extends State<Inscriptionscreen> {
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
                  "Bienvenu(e) sur DataLoop",
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
                        Text("Inscription",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),),
                        SizedBox(height: 10),
                        TextField(
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
                        ),SizedBox(height: 10,),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Numéro de télépghone',
                            prefixText: '+225',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Confirmernumeroscreen(),
                                    ),
                                  );
                                },
                                label: Text("Continuer",style: TextStyle(
                                  color: Colors.white
                                ),),icon:Icon(CupertinoIcons.arrow_right,color: Colors.white,),iconAlignment:IconAlignment.end,style: TextButton.styleFrom(
                                backgroundColor: Couleurs.darkGreen,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                              ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
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
                                  Text("Déjà un compte?"),
                                  SizedBox(width: 10,),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Connexionscreen(),
                                        ),
                                      );
                                    },
                                    child: Text("Se connecter",style: TextStyle(
                                      color: Couleurs.accentOrange,fontWeight: FontWeight.bold
                                    ),),
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
