import 'package:data_loop/Views/DashboardScreen.dart';
import 'package:data_loop/ViewsModels/AuthViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../Constantes/Couleurs.dart';

class Confirmernumeroscreen extends StatefulWidget {
  final String telephone;

  const Confirmernumeroscreen({super.key, required this.telephone});

  @override
  State<Confirmernumeroscreen> createState() => _ConfirmernumeroscreenState();
}

class _ConfirmernumeroscreenState extends State<Confirmernumeroscreen> {
  final TextEditingController _controllerOTP = TextEditingController();
  String? messageErreur;

  Future<void> verifierOtp() async {
    final authVM = context.read<Authviewmodel>();
    await authVM.verifierOtp(widget.telephone, _controllerOTP.text);

    if (!mounted) {
      return;
    }

    if (authVM.errrorMessage == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboardscreen()),
        (route) => false,
      );
    } else {
      setState(() {
        messageErreur = authVM.errrorMessage;
      });
    }
  }

  Future<void> renvoyerCode() async {
    final authVM = context.read<Authviewmodel>();
    await authVM.envoyerOtp(widget.telephone);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            authVM.errrorMessage ?? "Nouveau code OTP envoyé",
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<Authviewmodel>();

    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      appBar: AppBar(
        backgroundColor: Couleurs.darkGreen,
        title: Text(
          "Confirmer votre numéro",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 100.h),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Lottie.asset(
                            "assets/lotties/Number Phone icon.json",
                            width: 500.w,
                            height: 250.h,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Veuillez saisir le code OTP reçu sur ${widget.telephone}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500],
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Pinput(
                          length: 6,
                          obscureText: true,
                          obscuringCharacter: "●",
                          keyboardType: TextInputType.number,
                          controller: _controllerOTP,
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
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed:
                                    authVM.chargementEnCour ? null : verifierOtp,
                                style: TextButton.styleFrom(
                                  backgroundColor: Couleurs.accentOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: Text(
                                  "Confirmer",
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("Code non reçu ?"),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: GestureDetector(
                                    onTap: authVM.chargementEnCour
                                        ? null
                                        : renvoyerCode,
                                    child: Text("Renvoyer un nouveau code"),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
