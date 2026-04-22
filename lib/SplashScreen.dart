import 'package:data_loop/Views/AuthScreens/InscriptionScreen.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            ClipRRect(child: Image.asset("assets/images/DataLoop3.png",width: 250,),),
            Container(child: Column(
              children: [
                ElevatedButton(onPressed: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Inscriptionscreen()), (route)=>false);}, child: Text("Page connexoion")),
                Center(child: CircularProgressIndicator())
              ],
            ),)
          ],
        ),
      ),
    ),);
  }
}
