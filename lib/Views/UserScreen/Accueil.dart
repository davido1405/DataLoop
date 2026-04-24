import 'package:data_loop/Views/UserScreen/HistoriqueGains.dart';
import 'package:data_loop/ViewsModels/AnnotationViewModel.dart';
import 'package:data_loop/ViewsModels/AuthViewModel.dart';
import 'package:data_loop/ViewsModels/WalletViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Constantes/Couleurs.dart';
import '../../Models/Taches.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await chargerAccueil();
    });
  }

  List<Taches> listeTaches = [];

  String? soldeWallet = "0";

  Future<void> chargerAccueil() async {
    final walletVM = context.read<Walletviewmodel>();
    final annotationVM = context.read<Annotationviewmodel>();

    await Future.wait([
      walletVM.init(),
      annotationVM.recupererHistoriqueTaches(),
    ]);

    if (mounted) {
      setState(() {
        soldeWallet = walletVM.portefeuille?.solde ?? "0";
        listeTaches = annotationVM.historiqueTaches;
      });
    }
  }

  Future<void> demanderRetrait() async {
    final montantController = TextEditingController();
    String methodePaiement = "mobile_money_orange";

    final confirmer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Retirer mes gains"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: montantController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Montant",
                  suffixText: "FCFA",
                ),
              ),
              SizedBox(height: 12.h),
              DropdownButtonFormField<String>(
                value: methodePaiement,
                decoration: InputDecoration(labelText: "Méthode de paiement"),
                items: [
                  DropdownMenuItem(
                    value: "mobile_money_orange",
                    child: Text("Orange Money"),
                  ),
                  DropdownMenuItem(
                    value: "mobile_money_mtn",
                    child: Text("MTN Mobile Money"),
                  ),
                  DropdownMenuItem(
                    value: "mobile_money_moov",
                    child: Text("Moov Money"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    methodePaiement = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text("Confirmer"),
            ),
          ],
        );
      },
    );

    final montant = montantController.text.trim();
    montantController.dispose();

    if (confirmer != true || montant.isEmpty || !mounted) {
      return;
    }

    final walletVM = context.read<Walletviewmodel>();
    await walletVM.retrait(montant, methodePaiement);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            walletVM.errorMessage ?? "Demande de retrait enregistrée",
          ),
        ),
      );

    if (walletVM.errorMessage == null) {
      await chargerAccueil();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<Authviewmodel>().session;
    final objectifProgression = 25;
    final tachesRealisees = listeTaches.length;
    final progression = tachesRealisees > objectifProgression
        ? objectifProgression
        : tachesRealisees;

    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Bienvenue"),
                  Text("Bonjour ${session?.nomUtilisateur ?? 'Utilisateur'}")
                ],
              ),
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
                          "$soldeWallet FCFA",
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
                                onPressed: demanderRetrait,
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
                                "$tachesRealisees tâche${tachesRealisees > 1 ? 's' : ''}",
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
                        value: progression / objectifProgression,
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
                            "$progression/$objectifProgression",
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
                padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Icon(
                          CupertinoIcons.lightbulb_fill,
                          color: Couleurs.accentOrange,
                          size: 25,
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
                      "Rendez-vous dans 'Tâches' sur la barre de navigation pour démarrer une nouvelle tâche 😉",
                      style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Liste des Tâches déjà réalisées",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        fontSize: 18.sp,
                      ),
                    ),
                    listeTaches.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 5.w),
                            child: Center(child: emptyTacheCard()),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  cardTache(listeTaches[index]),
                                  if (index < listeTaches.length - 1)
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
            padding: EdgeInsets.all(8.0.w),
            child: Icon(CupertinoIcons.ticket_fill, color: Colors.white),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(tache.question),
            subtitle: Text(
              [
                if (tache.type_tache.isNotEmpty) tache.type_tache,
                if (tache.statut.isNotEmpty) tache.statut,
              ].join(" - "),
            ),
          ),
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
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.8)]),
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
              child: Icon(
                CupertinoIcons.clear_circled,
                color: Colors.grey[600],
                size: 30,
              ),
            ),
          ),
          Text(
            "Oups! Aucune tâche réalisée",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontSize: 18.sp,
            ),
          ),
          Text(
            "Veuillez commencez une tâche à l'écran 'Tâches' sur la barre de navigation",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              fontSize: 19.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
