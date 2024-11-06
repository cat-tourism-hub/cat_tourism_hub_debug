import 'package:cat_tourism_hub/business/presentation/components/info_card.dart';
import 'package:cat_tourism_hub/business/presentation/components/rating_chart.dart';
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
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Cards Row
            const Row(
              children: [
                Flexible(
                  child: InfoCard(
                    label: 'Bookings/Orders',
                    value: '200',
                    sideColor: Colors.blue,
                  ),
                ),
                Flexible(
                  child: InfoCard(
                    label: 'Available Products',
                    value: '100',
                    sideColor: Colors.green,
                  ),
                ),
                Flexible(
                  child: InfoCard(
                    label: 'Monthly Sales',
                    value: '1500',
                    sideColor: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Row to place the Rating Chart on the left side
            Row(
              children: [
                // Rating chart with label on the left half of the screen
                Flexible(
                  flex: 1,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rating',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const SizedBox(
                            height:
                                200, // You can adjust the height to make it smaller
                            child: RatingChart(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // You can add more content on the right half if needed
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
