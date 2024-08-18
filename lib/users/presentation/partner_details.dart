import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/users/models/partner.dart';
import 'package:flutter/material.dart';

class PartnerDetails extends StatefulWidget {
  const PartnerDetails({super.key, required this.partner});
  final Partner partner;

  @override
  State<PartnerDetails> createState() => _PartnerDetailsState();
}

class _PartnerDetailsState extends State<PartnerDetails> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _mobileView() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(appName)),
            body: const SingleChildScrollView(child: Column())));
  }

  Widget _desktopView() {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: SizedBox(
              width: screenWidth * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(widget.partner.name ?? '',
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      iconColor: Theme.of(context).indicatorColor,
                      title: Text(
                        widget.partner.locationString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.sizeOf(context).height;
    screenWidth = MediaQuery.sizeOf(context).width;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (screenWidth < 1000) {
          return _mobileView();
        }
        return _desktopView();
      },
    );
  }
}
