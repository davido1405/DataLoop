import 'package:flutter/material.dart';

class Historiquegains extends StatefulWidget {
  const Historiquegains({super.key});

  @override
  State<Historiquegains> createState() => _HistoriquegainsState();
}

class _HistoriquegainsState extends State<Historiquegains> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historique des gains"),),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          child: Column(children: []),
        ),
      ),
    );
  }
}
