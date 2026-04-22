import 'package:data_loop/Views/UserScreen/HistoriqueGains.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constantes/Couleurs.dart';
import '../../Models/Taches.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<Taches> listeTaches = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Carte du solde
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Couleurs.primaryGreen, Couleurs.darkGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 0.5),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Solde",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "Montant disponible actuellement",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "2 350.0 FCFA",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  print("Retrait de gain en cours...");
                                },
                                label: Text(
                                  "Retirer mes gains",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                icon: Icon(
                                  CupertinoIcons.square_arrow_down_fill,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Couleurs.accentOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Historiquegains(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(
                                    "Historique des gains",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Consulter l'historique de tout vos gains",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  trailing: Icon(
                                    CupertinoIcons.arrow_right,
                                    color: Colors.white,
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
              ),
              SizedBox(height: 15.h),
              //Résumé tâches
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Couleurs.primaryGreen,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 0.5),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tâches réalisées",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "47 tâches",
                                style: TextStyle(
                                  fontSize: 35.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Depuis votre inscription",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w400,
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
              SizedBox(height: 15.h),
              //Progression des tâches
              Padding(
                padding: EdgeInsets.all(8.0.w),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: 60 / 100, //A dynamiser
                        color: Couleurs.accentOrange,
                        backgroundColor: Colors.grey[400],
                        borderRadius: BorderRadius.circular(12.r),
                        minHeight: 15,
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Progression vers le prochain niveau",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "10/25",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              //CTA commencer une tâche
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Couleurs.darkGreen,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 0.5),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Icon(
                          CupertinoIcons.lightbulb_fill,
                          color: Couleurs.accentOrange,size: 25,
                        ),
                      ),
                    ),
                    title: Text(
                      "Astuce",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "Rendez-vous dans 'Tâches' sur la barre de navigation pour démarrer une nouvelle tâche 😉",style: TextStyle(
                      color: Colors.grey[200],fontSize: 18.sp,fontWeight: FontWeight.w500
                    ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(8.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Liste des Tâches déjà réalisées",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        fontSize: 18.sp,
                      ),),
                    listeTaches.isEmpty
                        ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 5.w),
                          child: Center(child: emptyTacheCard()),
                        )
                        : ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            cardTache(listeTaches[index]),
                            if (index < listeTaches.length)
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.grey,
                              ),
                          ],
                        );
                      },
                      itemCount: listeTaches.length,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget cardTache(Taches tache) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[500],
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding:  EdgeInsets.all(8.0.w),
            child: Icon(CupertinoIcons.ticket_fill, color: Colors.white),
          ),
        ),
        ListTile(
          title: Text("${tache} - ${tache}"),
          subtitle: Text("${tache} - ${tache}"),
        ),
      ],
    ),
  );
}

Widget emptyTacheCard() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18.r),
      boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 0.8)]
    ),
    child: Padding(
      padding: EdgeInsets.all(25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(18.w),
              child: Icon(CupertinoIcons.clear_circled, color: Colors.grey[600],size: 30,),
            ),
          ),
          Text("Oups! Aucune tâche réalisée",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontSize: 18.sp,
            ),),
          Text("Veuillez commencez une tâche à l'écran 'Tâches' sur la barre de navigation",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              fontSize: 19.sp,
            ),textAlign: TextAlign.center,),
        ],
      ),
    ),
  );
}
