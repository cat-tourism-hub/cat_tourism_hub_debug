import 'package:cat_tourism_hub/providers/establishment_provider.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerDetails extends StatefulWidget {
  const PartnerDetails({super.key});

  @override
  State<PartnerDetails> createState() => _PartnerDetailsState();
}

class _PartnerDetailsState extends State<PartnerDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EstablishmentProvider>(
      builder: (context, value, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Partner Header
                  Text(
                    AppStrings.partnerHeader,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 14),
                  // Establishment Label
                  if (!isMobile)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.name,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.estType,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),

                  // Establishment details
                  (!isMobile)
                      ? Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.apartment),
                                  title: Text(
                                    value.establishment!.name!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.domain),
                                  title: Text(value.establishment!.type!),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.name,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.apartment),
                                title: Text(
                                  value.establishment!.name!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppStrings.estType,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.domain),
                                title: Text(value.establishment!.type!),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 14),
                  // About label
                  if (!isMobile)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.about,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.estStatus,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),

                  // About details
                  (!isMobile)
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.info),
                                  title: Text(
                                    value.establishment!.about!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.pending),
                                  title: Text(
                                    value.establishment!.status!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.about,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.info),
                                title: Text(
                                  value.establishment!.about!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppStrings.estStatus,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.pending),
                                title: Text(
                                  value.establishment!.status!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 20),
                  // Contact Header
                  Text(
                    AppStrings.contactInfo,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 14),
                  // Contact label
                  if (!isMobile)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.phone,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.email,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),

                  // Contact details
                  (!isMobile)
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.phone),
                                  title: Text(
                                    value.establishment!.contact!['phone'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.email),
                                  title: Text(
                                    value.establishment!.contact!['email'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.phone,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.phone),
                                title: Text(
                                  value.establishment!.contact!['phone'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppStrings.email,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.email),
                                title: Text(
                                  value.establishment!.contact!['email'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 14),
                  // Socmed label
                  if (!isMobile)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.socmed,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.website,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  // Socmed details
                  (!isMobile)
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.facebook),
                                  title: Text(
                                    value
                                        .establishment!.contact!['social_link'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.public),
                                  title: Text(
                                    value.establishment!.contact!['website'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.socmed,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.facebook),
                                title: Text(
                                  value.establishment!.contact!['social_link'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppStrings.website,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.public),
                                title: Text(
                                  value.establishment!.contact!['website'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 20),
                  // Location Header
                  Text(
                    AppStrings.locInfo,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 14),
                  // Building label
                  if (!isMobile)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.building,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.street,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  // Building details
                  (!isMobile)
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.apartment),
                                  title: Text(
                                    value.establishment!.location!['bldg'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.navigation),
                                  title: Text(
                                    value.establishment!.location!['street'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.building,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.apartment),
                                title: Text(
                                  value.establishment!.location!['bldg'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppStrings.street,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.navigation),
                                title: Text(
                                  value.establishment!.location!['street'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 14),
                  // Barangay label
                  if (!isMobile)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.barangay,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.municipality,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  // Barangay details
                  (!isMobile)
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.explore),
                                  title: Text(
                                    value.establishment!.location!['brgy'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.map),
                                  title: Text(
                                    value.establishment!
                                        .location!['municipality'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.barangay,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.explore),
                                title: Text(
                                  value.establishment!.location!['brgy'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppStrings.municipality,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.map),
                                title: Text(
                                  value
                                      .establishment!.location!['municipality'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 20),
                  // Legalities
                  Text(
                    AppStrings.legalities,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 14),
                  if (!isMobile)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.bussPermit,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.sanitPerm,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.dotCert,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  (!isMobile)
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: Card(
                                child: Image.network(
                                    value.establishment!.legals!['bussPermit']),
                              ),
                            ),
                            Flexible(
                              child: Card(
                                child: Image.network(
                                    value.establishment!.legals!['sanitPerm']),
                              ),
                            ),
                            Flexible(
                              child: Card(
                                child: Image.network(
                                    value.establishment!.legals!['dotCert']),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.bussPermit,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: Image.network(
                                  value.establishment!.legals!['bussPermit']),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppStrings.sanitPerm,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: Image.network(
                                  value.establishment!.legals!['sanitPerm']),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppStrings.dotCert,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Card(
                              child: Image.network(
                                  value.establishment!.legals!['dotCert']),
                            ),
                          ],
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
