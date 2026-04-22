import 'package:data_loop/Views/DashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

import '../../Constantes/Couleurs.dart';

class Confirmernumeroscreen extends StatefulWidget {
  const Confirmernumeroscreen({super.key});

  @override
  State<Confirmernumeroscreen> createState() => _ConfirmernumeroscreenState();
}

class _ConfirmernumeroscreenState extends State<Confirmernumeroscreen> {
  final TextEditingController _controllerOTP = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                          "Veuillez saisir le code OTP reçu",
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
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Dashboardscreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
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
                                  child: Text("Renvoyer un nouveau code"),
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
