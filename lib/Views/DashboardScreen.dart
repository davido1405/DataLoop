import 'package:data_loop/Views/UserScreen/Accueil.dart';
import 'package:data_loop/Views/UserScreen/Profil.dart';
import 'package:data_loop/Views/UserScreen/TachesScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constantes/Couleurs.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {

  int index = 0;
  void changerIndex(int nouvelIndex){
    setState(() {
      index=nouvelIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [Accueil(), Tachesscreen(), Profil()];
    return Scaffold(
      backgroundColor: Couleurs.primaryGreen,
      appBar: AppBar(title: Text("DataLoop",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,fontSize: 25
      ),),automaticallyImplyLeading: false,backgroundColor: Couleurs.darkGreen,),
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Couleurs.darkGreen,
        onTap: changerIndex,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_alt,color: Couleurs.primaryGreen,size: 25,),
            activeIcon: Icon(CupertinoIcons.house_alt_fill,color: Colors.white,size: 28,),
            label: "Accueil"
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list,color: Couleurs.primaryGreen,size: 25,),
            activeIcon: Icon(CupertinoIcons.square_list_fill,color: Colors.white,size: 28,),
            label: "Tâches"
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_circle,color: Couleurs.primaryGreen,size: 25,),
              activeIcon: Icon(CupertinoIcons.person_circle_fill,color: Colors.white,size: 28,),
              label: "Profil",
          ),
        ],
      ),
    );
  }
}
