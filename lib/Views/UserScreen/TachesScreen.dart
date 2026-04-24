import 'package:data_loop/Models/Taches.dart';
import 'package:data_loop/Repositories/ApiConfig.dart';
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
  final TextEditingController _reponseAnnotation = TextEditingController();

  Taches? taches;
  DateTime? _debutTache;

  @override
  void initState() {
    super.initState();
    Future.microtask(fetchTachess);
  }

  @override
  void dispose() {
    _reponseAnnotation.dispose();
    super.dispose();
  }

  Future<void> fetchTachess() async {
    final tacheVM = context.read<Annotationviewmodel>();

    await tacheVM.init();

    if (!mounted) {
      return;
    }

    setState(() {
      taches = tacheVM.tache;
      response = null;
      _reponseAnnotation.clear();
      _debutTache = taches == null ? null : DateTime.now();
    });
  }

  Future<void> validerReponse() async {
    final tache = taches;
    final reponse = (response ?? _reponseAnnotation.text).trim();

    if (tache == null || reponse.isEmpty) {
      _afficherMessage("Veuillez choisir ou saisir une réponse");
      return;
    }

    final tacheVm = context.read<Annotationviewmodel>();
    final tempsExecutionMs = _debutTache == null
        ? 0
        : DateTime.now().difference(_debutTache!).inMilliseconds;

    await tacheVm.envoyerReponse(
      tache.id,
      reponse,
      tempsExecutionMs: tempsExecutionMs,
    );

    if (!mounted) {
      return;
    }

    if (tacheVm.errorMessage == null) {
      _afficherMessage("Réponse enregistrée");
      await fetchTachess();
    } else {
      _afficherMessage(tacheVm.errorMessage!);
    }
  }

  Future<void> passerTache() async {
    final tache = taches;
    if (tache == null) {
      return;
    }

    final tacheVm = context.read<Annotationviewmodel>();
    await tacheVm.passerTache(tache.id);

    if (!mounted) {
      return;
    }

    if (tacheVm.errorMessage == null) {
      _afficherMessage("Tâche passée");
      await fetchTachess();
    } else {
      _afficherMessage(tacheVm.errorMessage!);
    }
  }

  void _afficherMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String? _imageUrl(Taches tache) {
    final imageUrl = tache.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(imageUrl);
    if (uri != null && uri.hasScheme) {
      return imageUrl;
    }

    final path = imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl;
    return "${ApiConfig.baseUrl}/storage/$path";
  }

  @override
  Widget build(BuildContext context) {
    final tacheVM = context.watch<Annotationviewmodel>();

    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w, top: 10.h, right: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenue dans la section Annotation",
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
              if (tacheVM.chargementEnCours && taches == null)
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (taches != null)
                annotationImage(taches!)
              else
                emptyStateAnnotation(
                  tacheVM.errorMessage,
                  onRetry: tacheVM.chargementEnCours ? null : fetchTachess,
                ),
              if (taches != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: tacheVM.chargementEnCours
                                  ? null
                                  : () {
                                      setState(() {
                                        response = null;
                                        _reponseAnnotation.clear();
                                      });
                                    },
                              label: FittedBox(
                                child: Text(
                                  "Annuler ma réponse",
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
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: tacheVM.chargementEnCours
                                  ? null
                                  : passerTache,
                              label: FittedBox(
                                child: Text(
                                  "Passer cette tâche",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              icon: Icon(
                                CupertinoIcons.forward_fill,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Couleurs.darkGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: tacheVM.chargementEnCours
                                  ? null
                                  : validerReponse,
                              label: FittedBox(
                                child: Text(
                                  "Valider ma réponse",
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
                                  borderRadius: BorderRadius.circular(8.r),
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
      ),
    );
  }

  Widget annotationImage(Taches tache) {
    final imageUrl = _imageUrl(tache);

    return Column(
      children: [
        if (imageUrl != null)
          Padding(
            padding: EdgeInsets.all(15.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: 300.h,
                errorBuilder: (context, error, stackTrace) {
                  return imagePlaceholder(tache);
                },
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.all(15.w),
            child: imagePlaceholder(tache),
          ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            tache.question,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10.h),
        if (tache.options_reponse.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: SizedBox(
              height: 50.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  final propositions = tache.options_reponse;
                  final proposition = propositions[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          response = proposition;
                          _reponseAnnotation.clear();
                        });
                      },
                      child: Chip(
                        backgroundColor: response == proposition
                            ? Couleurs.primaryGreen
                            : Colors.grey,
                        avatar: response == proposition
                            ? Icon(
                                CupertinoIcons.checkmark_alt,
                                color: Colors.white,
                              )
                            : null,
                        label: Text(
                          proposition,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: response == proposition
                                ? FontWeight.bold
                                : null,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: tache.options_reponse.length,
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: TextField(
              controller: _reponseAnnotation,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Veuillez saisir votre réponse",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget imagePlaceholder(Taches tache) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.grey[300],
      ),
      height: 300.h,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.photo_fill,
            size: 100,
            color: Colors.grey[500],
          ),
          Text("[Photo]: ${tache.categorieImage}"),
        ],
      ),
    );
  }

  Widget emptyStateAnnotation(String? message, {VoidCallback? onRetry}) {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Icon(
                CupertinoIcons.clear_circled_solid,
                color: Colors.grey[600],
                size: 42,
              ),
              SizedBox(height: 8.h),
              Text(
                message ?? "Aucune tâche disponible",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 14.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(CupertinoIcons.refresh_bold),
                label: Text("Réessayer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Couleurs.darkGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
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
