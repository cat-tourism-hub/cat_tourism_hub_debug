import 'package:cat_tourism_hub/auth/auth_provider.dart';
import 'package:cat_tourism_hub/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/utils/snackbar_helper.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerDetails extends StatefulWidget {
  const PartnerDetails({super.key});

  @override
  State<PartnerDetails> createState() => _PartnerDetailsState();
}

class _PartnerDetailsState extends State<PartnerDetails> {
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
    return (isMobile)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Labels
              Text(
                AppStrings.name,
                style: Theme.of(context).textTheme.labelMedium,
              ),
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
              const SizedBox(height: 10),

              // Est type label
              Text(
                AppStrings.estType,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.domain_outlined),
                  title: Text(value.establishment!.type!),
                ),
              ),

              const SizedBox(height: 14),
              // About
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.about,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: isEditMode
                          ? TextFormField(
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
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.estStatus,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
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
              const SizedBox(height: 14),
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
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: isEditMode
                            ? TextFormField(
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
                      Text(
                        'Phone: ${value.establishment!.contact!['phone']!}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Email: ${value.establishment!.contact!['email']!}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Social media: ${value.establishment!.contact!['social_link']!}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Website: ${value.establishment!.contact!['website']!}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
                      Text(
                        'Building: ${value.establishment!.location!['bldg']!}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Street: ${value.establishment!.location!['street']!}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Barangay: ${value.establishment!.location!['brgy']!}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Municipality: ${value.establishment!.location!['municipality']!}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
              Text(
                AppStrings.bussPermit,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Card(
                child: Image.network(
                    fit: BoxFit.contain,
                    value.establishment!.legals!['bussPermit']),
              ),
              const SizedBox(height: 10),
              Text(
                AppStrings.sanitPerm,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Card(
                child: Image.network(
                    fit: BoxFit.contain,
                    value.establishment!.legals!['sanitPerm']),
              ),
              const SizedBox(height: 10),
              Text(
                AppStrings.dotCert,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Card(
                child: Image.network(
                    fit: BoxFit.contain,
                    value.establishment!.legals!['dotCert']),
              ),
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.bussPermit,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      AppStrings.sanitPerm,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      AppStrings.dotCert,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Image.network(
                          fit: BoxFit.contain,
                          value.establishment!.legals!['bussPermit']),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Image.network(
                          fit: BoxFit.contain,
                          value.establishment!.legals!['sanitPerm']),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Image.network(
                          fit: BoxFit.contain,
                          value.establishment!.legals!['dotCert']),
                    ),
                  ),
                ],
              )
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
                  Row(
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
                            icon: Icon(
                                isEditMode ? Icons.save : Icons.edit_outlined),
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
                              isEditMode ? 'Save' : 'Edit',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                      ),
                    ],
                  ),

                  // Partner info widget
                  _buildPartnerInfo(value, isMobile),
                  const SizedBox(height: 20),

                  isMobile
                      ? Column(
                          children: [
                            _buildContactInfo(value),
                            const SizedBox(height: 14),
                            _buildLocationInfo(value),
                            const SizedBox(height: 14),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _buildContactInfo(value)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildLocationInfo(value)),
                            const SizedBox(width: 10),
                          ],
                        ),
                  const SizedBox(height: 20),
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
