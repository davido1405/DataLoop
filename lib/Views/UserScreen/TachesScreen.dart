import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constantes/Couleurs.dart';

class Tachesscreen extends StatefulWidget {
  const Tachesscreen({super.key});

  @override
  State<Tachesscreen> createState() => _TachesscreenState();
}

class _TachesscreenState extends State<Tachesscreen> {
  String? response;
  List<String> propositionsReponse = [
    "Foutou banane",
    "Gbaka",
    "Commerce",
    "Panneau",
    "Rue",
    "Jolie go",
    "Attiéké",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Intitulé de l'écran
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenu(e) dans la section Annotation",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "Effectuez des tâches pour augmenter vos gains",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            //Image à annoter
            Padding(
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                child: Image.network(
                  "url de l'image à  afficher",
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: 300,
                  errorBuilder: (context, error, stackTrace) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.grey[300],
                          ),
                          height: 300,
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.photo_fill,
                                size: 100,
                                color: Colors.grey[500],
                              ),
                              Text("[Photo]: description_image"),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                "Que voyez-vous sur cette image ?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            //Proposition de reponse
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              response = propositionsReponse[index];
                            });
                          }
                        },
                        child: Chip(
                          backgroundColor:
                              response == propositionsReponse[index]
                              ? Couleurs.primaryGreen
                              : Colors.grey,
                          avatar: response == propositionsReponse[index]
                              ? Icon(
                                  CupertinoIcons.checkmark_alt,
                                  color: Colors.white,
                                )
                              : null,
                          label: Text(
                            propositionsReponse[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: response == propositionsReponse[index]
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: propositionsReponse.length,
                ),
              ),
            ),
            //Boutons de validation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Bouton annuler reponse
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            print("Reponse annulée");
                            if (mounted) {
                              setState(() {
                                response = null;
                              });
                            }
                          },
                          label: FittedBox(
                            child: Text(
                              "Annuler ma reponse",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          icon: Icon(
                            CupertinoIcons.refresh_bold,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Couleurs.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Bouton envoyer reponse
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            print("Reponse envoyée");
                          },
                          label: FittedBox(
                            child: Text(
                              "Valider ma reponse",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          icon: Icon(
                            CupertinoIcons.paperplane_fill,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Couleurs.accentOrange,
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
          ],
        ),
      ),
    );
  }
}
