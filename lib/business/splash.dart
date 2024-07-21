import 'package:cat_tourism_hub/business/index.dart';
import 'package:cat_tourism_hub/auth/auth_provider.dart';
import 'package:cat_tourism_hub/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class BusinessDashboard extends StatelessWidget {
  const BusinessDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    String userUid = provider.user!.uid;
    final estbProvider =
        Provider.of<PartnerAcctProvider>(context, listen: false);
    estbProvider.getEstablishmentDetails(userUid);
    return Consumer<PartnerAcctProvider>(
      builder: (context, value, child) {
        if (value.establishment == null) {
          return Scaffold(
            body: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(AppStrings.fetching),
                LoadingAnimationWidget.prograssiveDots(
                  color: Colors.black,
                  size: 50,
                ),
              ],
            )),
          );
        }

        return Index(establishment: value.establishment);
      },
    );
  }
}

// class BusinessDashboard extends StatefulWidget {
//   const BusinessDashboard({super.key});

//   @override
//   State<BusinessDashboard> createState() => _BusinessDashboardState();
// }

// class _BusinessDashboardState extends State<BusinessDashboard> {
//   @override
//   void initState() {
    
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
   
//   }
// }
