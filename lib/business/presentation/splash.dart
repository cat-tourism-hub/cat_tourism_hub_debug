import 'package:cat_tourism_hub/business/presentation/index.dart';
import 'package:cat_tourism_hub/core/auth/auth_provider.dart';
import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({super.key});

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {
  late String uid;
  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    uid = provider.user!.uid;
    final estbProvider =
        Provider.of<PartnerAcctProvider>(context, listen: false);
    estbProvider.getEstablishmentDetails(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerAcctProvider>(
      builder: (context, value, child) {
        if (value.establishment == null || value.isLoading) {
          return Scaffold(
            body: Center(
              child: value.isLoading
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppStrings.fetching),
                        const Gap(10),
                        LoadingAnimationWidget.inkDrop(
                          color: Theme.of(context).indicatorColor,
                          size: 30,
                        ),
                      ],
                    )
                  : value.error != null && value.error!.isNotEmpty
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(AppStrings.error2),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  value.getEstablishmentDetails(uid);
                                });
                              },
                              child: const Text(AppStrings.tryAgain),
                            )
                          ],
                        )
                      : const SizedBox
                          .shrink(), // This handles the case where there's no loading and no error
            ),
          );
        }

        return Index(establishment: value.establishment);
      },
    );
  }
}
