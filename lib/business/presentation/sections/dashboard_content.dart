import 'package:cat_tourism_hub/business/presentation/components/info_card.dart';
import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerAcctProvider>(
      builder: (context, value, child) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                    child: InfoCard(
                  headingData: 'Bookings/Orders',
                  subData: '200',
                )),
                Flexible(
                    child: InfoCard(
                        headingData: 'Available Products', subData: '100')),
                Flexible(
                    child:
                        InfoCard(headingData: 'Monthly Sales', subData: '1500'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
