import 'package:data_loop/Models/TempData.dart';
import 'package:data_loop/ViewsModels/AuthViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../Constantes/Couleurs.dart';
import '../DashboardScreen.dart';

class Definirpinscreen extends StatefulWidget {
  final Tempdata tempData;
  const Definirpinscreen({super.key, required this.tempData});

  @override
  State<Definirpinscreen> createState() => _DefinirpinscreenState();
}

class _DefinirpinscreenState extends State<Definirpinscreen> {

  final TextEditingController _controllerPin =TextEditingController();

  bool erreur=false;

Future<void>inscription(String password)async{
  final authVm=context.read<Authviewmodel>();

  await authVm.sinscrir(widget.tempData.nomPrenom, widget.tempData.email??'', widget.tempData.telephone, password);

  if(authVm.errrorMessage==null){
    print(authVm.session.toString());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Dashboardscreen()), (route)=>false);
  }else{
    print(authVm.errrorMessage);
    if(mounted){
      setState(() {
        erreur=true;
      });
    }
  }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      appBar: AppBar(
        backgroundColor: Couleurs.darkGreen,
        title: Text(
          "Definir un code pin",
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
                            "assets/lotties/Mobile Security.json",
                            width: 500.w,
                            height: 250.h,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Veuillez saisir votre code pin",
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
                          controller: _controllerPin,
                        ),
                        if(erreur)...[
                          SizedBox(height: 5.h,),
                          Text("Oups! Une erreur s'est produite. Veuillez réessayer",style: TextStyle(
                            fontSize: 18.sp,
                            color: Couleurs.emergencyRed,
                            fontWeight: FontWeight.w500
                          ),),
                        ],

                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () async{
                                  await inscription(_controllerPin.text);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Couleurs.accentOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: Text(
                                  "M'inscrire",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
