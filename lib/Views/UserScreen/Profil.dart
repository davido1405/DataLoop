import 'package:data_loop/Constantes/Couleurs.dart';
import 'package:data_loop/Views/AuthScreens/ConnexionScreen.dart';
import 'package:data_loop/ViewsModels/AuthViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  Future<void> seDeconnecter() async {
    final authVM = context.read<Authviewmodel>();
    await authVM.seDeconnecter();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Connexionscreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<Authviewmodel>().session;
    final authVM = context.watch<Authviewmodel>();

    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Couleurs.darkGreen,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 34.r,
                        backgroundColor: Colors.white,
                        child: Icon(
                          CupertinoIcons.person_fill,
                          color: Couleurs.darkGreen,
                          size: 36,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        session?.nomUtilisateur ?? "Utilisateur",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                        ),
                      ),
                      Text(
                        session?.telephone ?? "Numéro indisponible",
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              profileRow(
                icon: CupertinoIcons.mail_solid,
                label: "E-mail",
                value: session?.email ?? "Aucun email",
              ),
              profileRow(
                icon: CupertinoIcons.person_badge_plus,
                label: "Rôle",
                value: session?.role.isNotEmpty == true
                    ? session!.role
                    : "Non défini",
              ),
              profileRow(
                icon: CupertinoIcons.checkmark_seal_fill,
                label: "Statut",
                value: session?.statut ?? "Non défini",
              ),
              profileRow(
                icon: CupertinoIcons.star_fill,
                label: "Score de confiance",
                value: "${session?.score_confiance ?? 0}",
              ),
              profileRow(
                icon: CupertinoIcons.money_dollar_circle_fill,
                label: "Solde virtuel",
                value: "${session?.solde_virtuel ?? 0} FCFA",
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: authVM.chargementEnCour ? null : seDeconnecter,
                      icon: Icon(
                        CupertinoIcons.square_arrow_right,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Se déconnecter",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Couleurs.emergencyRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
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
    );
  }

  Widget profileRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
        ),
        child: ListTile(
          leading: Icon(icon, color: Couleurs.primaryGreen),
          title: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(value),
        ),
      ),
    );
  }
}
