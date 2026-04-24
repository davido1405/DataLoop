import 'package:data_loop/Models/Taches.dart';
import 'package:data_loop/ViewsModels/AnnotationViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Constantes/Couleurs.dart';

class Tachesscreen extends StatefulWidget {
  const Tachesscreen({super.key});

  @override
  State<Tachesscreen> createState() => _TachesscreenState();
}

class _TachesscreenState extends State<Tachesscreen> {
  String? response;
  late final TextEditingController _reponseAnnotation = TextEditingController();

  Taches? taches;

  Future<void> fetchTachess() async {
    final tacheVM = context.read<Annotationviewmodel>();

    await tacheVM.init();

    if (tacheVM.errorMessage == null) {
      if (mounted) {
        setState(() {
          taches = tacheVM.tache!;
        });
      }
    }
  }

  //Passer tache
  Future<void> passerTache() async {
    final tacheVm = context.read<Annotationviewmodel>();
    bool chargement = tacheVm.chargementEnCours;
    if (mounted && chargement) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: CircularProgressIndicator());
        },
      );
    }
    await tacheVm.passerTache(taches!.id);

    if (mounted) {
      Navigator.of(context).pop();
    }
    await fetchTachess();
  }

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
              padding: EdgeInsets.only(left: 10.w, top: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenu(e) dans la section Annotation",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
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
            taches != null ? annotationImage(taches!) : emptyStateAnnotation(),

            //Boutons de validation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                                fontSize: 20.sp,
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
                              borderRadius: BorderRadius.circular(8.r),
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
                            if (mounted) {
                              setState(() {
                                response = _reponseAnnotation.text;
                              });
                            }

                            print("Reponse envoyée");
                          },
                          label: FittedBox(
                            child: Text(
                              "Valider ma reponse",
                              style: TextStyle(
                                fontSize: 20.sp,
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

  Widget annotationImage(Taches tache) {
    return Column(
      children: [
        //Image à annoter
        if (tache.type_tache == "")
          Padding(
            padding: EdgeInsets.all(15.w),
            child: ClipRRect(
              child: Image.network(
                "${tache.image['url_stockage']}",
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: 300,
                errorBuilder: (context, error, stackTrace) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          color: Colors.grey[300],
                        ),
                        height: 300.h,
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
                            Text("[Photo]: ${tache.image['categorie']}"),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        SizedBox(height: 5.h),
        Center(
          child: Text(
            tache.question,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
        //Proposition de reponse
        tache.options_reponse!.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SizedBox(
                  height: 50.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      // Les propositions de la tâche actuelle
                      final propositions = tache.options_reponse;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                response = propositions[index];
                              });
                            }
                          },
                          child: Chip(
                            backgroundColor: response == propositions![index]
                                ? Couleurs.primaryGreen
                                : Colors.grey,
                            avatar: response == propositions[index]
                                ? Icon(
                                    CupertinoIcons.checkmark_alt,
                                    color: Colors.white,
                                  )
                                : null,
                            label: Text(
                              propositions[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: response == propositions[index]
                                    ? FontWeight.bold
                                    : null,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(12.r),
                            ),
                          ),
                        ),
                      );
                    },
                    // Nombre de propositions de la tâche actuelle
                    itemCount: tache.options_reponse?.length,
                  ),
                ),
              )
            : TextField(
                controller: _reponseAnnotation,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Veuillez saisir votre reponse",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
      ],
    );
  }

  Widget emptyStateAnnotation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(children: [
        Center(child: Icon(CupertinoIcons.clear_circled_solid))
      ]),
    );
  }
}
