import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/partner_details/partner_details_item.dart';
import 'package:cat_tourism_hub/core/utils/auth_provider.dart';
import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/core/utils/cached_image.dart';
import 'package:cat_tourism_hub/core/utils/snackbar_helper.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class PartnerInfo extends StatefulWidget {
  const PartnerInfo({super.key});

  @override
  State<PartnerInfo> createState() => _PartnerInfoState();
}

class _PartnerInfoState extends State<PartnerInfo> {
  bool isEditMode = false;
  late Map<String, TextEditingController> controllers;
  late Map<String, String> initialValues;

  @override
  void initState() {
    super.initState();
    final establishment =
        Provider.of<PartnerAcctProvider>(context, listen: false).establishment!;
    initialValues = {
      'name': establishment.name!,
      'about': establishment.about ?? '',
      'phone': establishment.contact!['phone']!,
      'email': establishment.contact!['email']!,
      'social_link': establishment.contact!['social_link']!,
      'website': establishment.contact!['website']!,
      'bldg': establishment.location!['bldg']!,
      'street': establishment.location!['street']!,
      'brgy': establishment.location!['brgy']!,
      'municipality': establishment.location!['municipality']!,
    };

    controllers = {
      'name': TextEditingController(text: initialValues['name']),
      'type': TextEditingController(text: initialValues['type']),
      'about': TextEditingController(text: initialValues['about']),
      'status': TextEditingController(text: initialValues['status']),
      'phone': TextEditingController(text: initialValues['phone']),
      'email': TextEditingController(text: initialValues['email']),
      'social_link': TextEditingController(text: initialValues['social_link']),
      'website': TextEditingController(text: initialValues['website']),
      'bldg': TextEditingController(text: initialValues['bldg']),
      'street': TextEditingController(text: initialValues['street']),
      'brgy': TextEditingController(text: initialValues['brgy']),
      'municipality':
          TextEditingController(text: initialValues['municipality']),
    };
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  bool hasChanges() {
    for (var key in initialValues.keys) {
      if (controllers[key]!.text != initialValues[key]) {
        return true;
      }
    }
    return false;
  }

  void saveChanges() async {
    if (!hasChanges()) {
      setState(() {
        isEditMode = false;
      });
      return;
    }

    final establishmentProvider =
        Provider.of<PartnerAcctProvider>(context, listen: false);
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final establishment = establishmentProvider.establishment!;
    establishment.name = controllers['name']!.text;
    establishment.about = controllers['about']?.text;
    establishment.contact?['phone'] = controllers['phone']?.text;
    establishment.contact?['email'] = controllers['email']?.text;
    establishment.contact?['social_link'] = controllers['social_link']?.text;
    establishment.contact?['website'] = controllers['website']?.text;
    establishment.location?['bldg'] = controllers['bldg']?.text;
    establishment.location?['street'] = controllers['street']?.text;
    establishment.location?['brgy'] = controllers['brgy']?.text;
    establishment.location?['municipality'] = controllers['municipality']?.text;

    String result = await establishmentProvider.savePartnerDetails(
        authProvider.user!.uid, establishment);
    setState(() {
      isEditMode = false;
    });
    SnackbarHelper.showSnackBar(result);
  }

  Widget _buildPartnerInfo(dynamic value, bool isMobile) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Labels
              infoCardLabel(context, AppStrings.name),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.apartment_outlined),
                  title: isEditMode
                      ? TextFormField(
                          controller: controllers['name'],
                          decoration: const InputDecoration(
                            hintText: AppStrings.name,
                          ),
                        )
                      : Text(
                          value.establishment!.name!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                ),
              ),
              const Gap(10),
              // Est type label
              infoCardLabel(context, AppStrings.estType),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.domain_outlined),
                  title: Text(value.establishment!.type!),
                ),
              ),

              const Gap(14),
              // About
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoCardLabel(context, AppStrings.about),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: isEditMode
                          ? TextFormField(
                              maxLines: 10,
                              controller: controllers['about'],
                              decoration: const InputDecoration(
                                hintText: 'About',
                              ),
                            )
                          : Text(
                              value.establishment!.about!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    ),
                  ),
                  const Gap(10),
                  infoCardLabel(context, AppStrings.estStatus),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.pending_outlined),
                      title: Text(
                        value.establishment!.status!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: infoCardLabel(context, AppStrings.name),
                  ),
                  Expanded(
                    child: infoCardLabel(context, AppStrings.estType),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.apartment_outlined),
                        title: isEditMode
                            ? TextFormField(
                                controller: controllers['name'],
                                decoration: const InputDecoration(
                                  hintText: 'Name',
                                ),
                              )
                            : Text(
                                value.establishment!.name!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.domain_outlined),
                        title: Text(value.establishment!.type!),
                      ),
                    ),
                  ),
                ],
              ),

              // About
              const Gap(14),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: infoCardLabel(context, AppStrings.about),
                  ),
                  Expanded(
                    child: infoCardLabel(context, AppStrings.estStatus),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: isEditMode
                            ? TextFormField(
                                maxLines: 10,
                                controller: controllers['about'],
                                decoration: const InputDecoration(
                                  hintText: 'About',
                                ),
                              )
                            : Text(
                                value.establishment!.about!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.pending_outlined),
                        title: Text(
                          value.establishment!.status!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
  }

  Widget _buildContactInfo(dynamic value) {
    return Column(
      children: [
        Text(
          AppStrings.contactInfo,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.contact_mail_outlined),
            title: isEditMode
                ? Column(
                    children: [
                      TextFormField(
                        controller: controllers['phone'],
                        decoration: const InputDecoration(
                          hintText: 'Phone',
                        ),
                      ),
                      TextFormField(
                        controller: controllers['email'],
                        decoration: const InputDecoration(
                          hintText: 'Email address',
                        ),
                      ),
                      TextFormField(
                        controller: controllers['social_link'],
                        decoration: const InputDecoration(
                          hintText: 'Social media',
                        ),
                      ),
                      TextFormField(
                        controller: controllers['website'],
                        decoration: const InputDecoration(
                          hintText: 'Website',
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cardLabel(context,
                          'Phone: ${value.establishment!.contact!['phone']!}'),
                      const Gap(5),
                      cardLabel(context,
                          'Email: ${value.establishment!.contact!['email']!}'),
                      const Gap(5),
                      cardLabel(context,
                          'Social media: ${value.establishment!.contact!['social_link']!}'),
                      const Gap(5),
                      cardLabel(context,
                          'Website: ${value.establishment!.contact!['website']!}'),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(dynamic value) {
    return Column(
      children: [
        Text(
          AppStrings.locInfo,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: isEditMode
                ? Column(
                    children: [
                      TextFormField(
                        controller: controllers['bldg'],
                        decoration: const InputDecoration(
                          hintText: 'Building',
                        ),
                      ),
                      TextFormField(
                        controller: controllers['street'],
                        decoration: const InputDecoration(
                          hintText: 'Street',
                        ),
                      ),
                      TextFormField(
                        controller: controllers['brgy'],
                        decoration: const InputDecoration(
                          hintText: 'Barangay',
                        ),
                      ),
                      TextFormField(
                        controller: controllers['municipality'],
                        decoration: const InputDecoration(
                          hintText: 'Municipality',
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cardLabel(context,
                          'Building: ${value.establishment!.location!['bldg']!}'),
                      const Gap(5),
                      cardLabel(context,
                          'Street: ${value.establishment!.location!['street']!}'),
                      const Gap(5),
                      cardLabel(context,
                          'Barangay: ${value.establishment!.location!['brgy']!}'),
                      const Gap(5),
                      cardLabel(context,
                          'Municipality: ${value.establishment!.location!['municipality']!}'),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegalities(dynamic value, bool isMobile) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              legalitiesLabel(context, AppStrings.bussPermit),
              Card(
                child: CachedImage(
                  imageUrl: value.establishment!.legals!['bussPermit'],
                  imageFit: BoxFit.contain,
                ),
              ),
              const Gap(10),
              legalitiesLabel(context, AppStrings.sanitPerm),
              Card(
                child: CachedImage(
                  imageUrl: value.establishment!.legals!['sanitPerm'],
                  imageFit: BoxFit.contain,
                ),
              ),
              const Gap(10),
              legalitiesLabel(context, AppStrings.dotCert),
              Card(
                child: CachedImage(
                    imageFit: BoxFit.contain,
                    imageUrl: value.establishment!.legals!['dotCert']),
              ),
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: legalitiesLabel(context, AppStrings.bussPermit),
                  ),
                  Expanded(
                    child: legalitiesLabel(context, AppStrings.sanitPerm),
                  ),
                  Expanded(
                    child: legalitiesLabel(context, AppStrings.dotCert),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: CachedImage(
                          imageFit: BoxFit.contain,
                          imageUrl: value.establishment!.legals!['bussPermit']),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: CachedImage(
                          imageFit: BoxFit.contain,
                          imageUrl: value.establishment!.legals!['sanitPerm']),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: CachedImage(
                          imageFit: BoxFit.contain,
                          imageUrl: value.establishment!.legals!['dotCert']),
                    ),
                  ),
                ],
              )
            ],
          );
  }

  Widget partnerHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Text(
            AppStrings.partnerHeader,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          child: TextButton.icon(
              icon: Icon(isEditMode ? Icons.save : Icons.edit_outlined),
              onPressed: () {
                if (isEditMode) {
                  saveChanges();
                } else {
                  setState(() {
                    isEditMode = true;
                  });
                }
              },
              label: Text(
                isEditMode ? AppStrings.save : AppStrings.edit,
                style: Theme.of(context).textTheme.bodyMedium,
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerAcctProvider>(
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
                  partnerHeader(),

                  // Partner info widget
                  _buildPartnerInfo(value, isMobile),
                  const Gap(20),

                  isMobile
                      ? Column(
                          children: [
                            _buildContactInfo(value),
                            const Gap(14),
                            _buildLocationInfo(value),
                            const Gap(14),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _buildContactInfo(value)),
                            const Gap(10),
                            Expanded(child: _buildLocationInfo(value)),
                            const Gap(10),
                          ],
                        ),
                  const Gap(20),
                  _buildLegalities(value, isMobile)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
