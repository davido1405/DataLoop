import 'package:data_loop/Constantes/Couleurs.dart';
import 'package:data_loop/Models/Transactions.dart';
import 'package:data_loop/ViewsModels/WalletViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Historiquegains extends StatefulWidget {
  const Historiquegains({super.key});

  @override
  State<Historiquegains> createState() => _HistoriquegainsState();
}

class _HistoriquegainsState extends State<Historiquegains> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<Walletviewmodel>().recupererTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletVM = context.watch<Walletviewmodel>();
    final transactions = walletVM.transactions;

    return Scaffold(
      backgroundColor: Couleurs.lightGreen,
      appBar: AppBar(
        title: Text("Historique des gains"),
        backgroundColor: Couleurs.darkGreen,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: walletVM.chargementEnCours && transactions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : transactions.isEmpty
                ? emptyState(walletVM.errorMessage)
                : ListView.separated(
                    padding: EdgeInsets.all(12.w),
                    itemBuilder: (context, index) {
                      return transactionCard(transactions[index]);
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                    itemCount: transactions.length,
                  ),
      ),
    );
  }

  Widget transactionCard(Transactions transaction) {
    final isGain = transaction.typeTransaction == "gain";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isGain ? Couleurs.primaryGreen : Couleurs.lightOrange,
          child: Icon(
            isGain
                ? CupertinoIcons.arrow_down_circle_fill
                : CupertinoIcons.arrow_up_circle_fill,
            color: isGain ? Colors.white : Couleurs.accentOrange,
          ),
        ),
        title: Text(
          transaction.libelleTransaction,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          [
            if (transaction.referenceTache.isNotEmpty)
              transaction.referenceTache,
            if (transaction.dateTransaction.isNotEmpty)
              transaction.dateTransaction,
          ].join(" - "),
        ),
        trailing: Text(
          "${isGain ? '+' : '-'}${transaction.montantTransaction} FCFA",
          style: TextStyle(
            color: isGain ? Couleurs.primaryGreen : Couleurs.emergencyRed,
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }

  Widget emptyState(String? message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.tray,
                  color: Colors.grey[600],
                  size: 42,
                ),
                SizedBox(height: 8.h),
                Text(
                  message ?? "Aucune transaction disponible",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
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
