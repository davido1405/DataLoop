import 'package:data_loop/Constantes/Couleurs.dart';
import 'package:data_loop/Repositories/ApiConfig.dart';
import 'package:data_loop/Views/AuthScreens/ConfirmerNumeroScreen.dart';
import 'package:data_loop/ViewsModels/AuthViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Recoverpin extends StatefulWidget {
  const Recoverpin({super.key});

  @override
  State<Recoverpin> createState() => _RecoverpinState();
}

class _RecoverpinState extends State<Recoverpin> {
  final TextEditingController _telephoneController = TextEditingController();
  String? messageErreur;

  @override
  void dispose() {
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> envoyerOtp() async {
    final telephone = ApiConfig.normaliserTelephone(_telephoneController.text);
    final authVM = context.read<Authviewmodel>();

    await authVM.envoyerOtp(telephone);

    if (!mounted) {
      return;
    }

    if (authVM.errrorMessage == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Confirmernumeroscreen(telephone: telephone),
        ),
      );
    } else {
      setState(() {
        messageErreur = authVM.errrorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<Authviewmodel>();

    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      appBar: AppBar(
        backgroundColor: Couleurs.darkGreen,
        foregroundColor: Colors.white,
        title: Text("Récupérer le code PIN"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        "Recevoir un code OTP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: _telephoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Numéro de téléphone",
                          prefixText: "+225",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      if (messageErreur != null) ...[
                        SizedBox(height: 8.h),
                        Text(
                          messageErreur!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Couleurs.emergencyRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  authVM.chargementEnCour ? null : envoyerOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Couleurs.accentOrange,
                              ),
                              child: Text(
                                "Envoyer le code",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
