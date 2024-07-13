// import 'package:cat_tourism_hub/providers/establishment_provider.dart';
// import 'package:cat_tourism_hub/values/strings.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PartnerDetails extends StatefulWidget {
//   const PartnerDetails({super.key});

//   @override
//   State<PartnerDetails> createState() => _PartnerDetailsState();
// }

// class _PartnerDetailsState extends State<PartnerDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<EstablishmentProvider>(
//       builder: (context, value, child) => SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               bool isMobile = constraints.maxWidth < 600;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Partner Header
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           AppStrings.partnerHeader,
//                           style: Theme.of(context).textTheme.headlineLarge,
//                         ),
//                       ),
//                       Card(
//                         child: TextButton.icon(
//                             icon: const Icon(Icons.edit_outlined),
//                             onPressed: () {},
//                             label: Text(
//                               'Edit',
//                               style: Theme.of(context).textTheme.bodyMedium,
//                             )),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 14),
//                   // Establishment Label
//                   if (!isMobile)
//                     Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             AppStrings.name,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             AppStrings.estType,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                       ],
//                     ),

//                   // Establishment details
//                   (!isMobile)
//                       ? Row(
//                           children: [
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.apartment_outlined),
//                                   title: Text(
//                                     value.establishment!.name!,
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.domain_outlined),
//                                   title: Text(value.establishment!.type!),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppStrings.name,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.apartment_outlined),
//                                 title: Text(
//                                   value.establishment!.name!,
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               AppStrings.estType,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.domain_outlined),
//                                 title: Text(value.establishment!.type!),
//                               ),
//                             ),
//                           ],
//                         ),
//                   const SizedBox(height: 14),
//                   // About label
//                   if (!isMobile)
//                     Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             AppStrings.about,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             AppStrings.estStatus,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                       ],
//                     ),

//                   // About details
//                   (!isMobile)
//                       ? Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.info_outline),
//                                   title: Text(
//                                     value.establishment!.about!,
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.pending_outlined),
//                                   title: Text(
//                                     value.establishment!.status!,
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppStrings.about,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.info_outline),
//                                 title: Text(
//                                   value.establishment!.about!,
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               AppStrings.estStatus,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.pending_outlined),
//                                 title: Text(
//                                   value.establishment!.status!,
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                   const SizedBox(height: 20),
//                   const Divider(thickness: 1.5),
//                   const SizedBox(height: 20),
//                   // Contact Header
//                   Text(
//                     AppStrings.contactInfo,
//                     style: Theme.of(context).textTheme.headlineLarge,
//                   ),
//                   const SizedBox(height: 14),
//                   // Contact label
//                   if (!isMobile)
//                     Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             AppStrings.phone,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             AppStrings.email,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                       ],
//                     ),

//                   // Contact details
//                   (!isMobile)
//                       ? Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.phone_outlined),
//                                   title: Text(
//                                     value.establishment!.contact!['phone'],
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.email_outlined),
//                                   title: Text(
//                                     value.establishment!.contact!['email'],
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppStrings.phone,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.phone_outlined),
//                                 title: Text(
//                                   value.establishment!.contact!['phone'],
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               AppStrings.email,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.email_outlined),
//                                 title: Text(
//                                   value.establishment!.contact!['email'],
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                   const SizedBox(height: 14),
//                   // Socmed label
//                   if (!isMobile)
//                     Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             AppStrings.socmed,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             AppStrings.website,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                       ],
//                     ),
//                   // Socmed details
//                   (!isMobile)
//                       ? Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.facebook_outlined),
//                                   title: Text(
//                                     value
//                                         .establishment!.contact!['social_link'],
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.public_outlined),
//                                   title: Text(
//                                     value.establishment!.contact!['website'],
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppStrings.socmed,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.facebook_outlined),
//                                 title: Text(
//                                   value.establishment!.contact!['social_link'],
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               AppStrings.website,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.public_outlined),
//                                 title: Text(
//                                   value.establishment!.contact!['website'],
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                   const SizedBox(height: 20),
//                   const Divider(thickness: 1.5),
//                   const SizedBox(height: 20),
//                   // Location Header
//                   Text(
//                     AppStrings.locInfo,
//                     style: Theme.of(context).textTheme.headlineLarge,
//                   ),
//                   const SizedBox(height: 14),
//                   // Building label
//                   if (!isMobile)
//                     Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             AppStrings.building,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             AppStrings.street,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                       ],
//                     ),
//                   // Building details
//                   (!isMobile)
//                       ? Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.apartment_outlined),
//                                   title: Text(
//                                     value.establishment!.location!['bldg'],
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading:
//                                       const Icon(Icons.navigation_outlined),
//                                   title: Text(
//                                     value.establishment!.location!['street'],
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppStrings.building,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.apartment_outlined),
//                                 title: Text(
//                                   value.establishment!.location!['bldg'],
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               AppStrings.street,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.navigation_outlined),
//                                 title: Text(
//                                   value.establishment!.location!['street'],
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                   const SizedBox(height: 14),
//                   // Barangay label
//                   if (!isMobile)
//                     Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             AppStrings.barangay,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             AppStrings.municipality,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                       ],
//                     ),
//                   // Barangay details
//                   (!isMobile)
//                       ? Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.explore_outlined),
//                                   title: Text(
//                                     value.establishment!.location!['brgy'],
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Card(
//                                 child: ListTile(
//                                   leading: const Icon(Icons.map_outlined),
//                                   title: Text(
//                                     value.establishment!
//                                         .location!['municipality'],
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppStrings.barangay,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.explore),
//                                 title: Text(
//                                   value.establishment!.location!['brgy'],
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               AppStrings.municipality,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: ListTile(
//                                 leading: const Icon(Icons.map),
//                                 title: Text(
//                                   value
//                                       .establishment!.location!['municipality'],
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                   const SizedBox(height: 20),
//                   const Divider(thickness: 1.5),
//                   const SizedBox(height: 20),
//                   // Legalities
//                   Text(
//                     AppStrings.legalities,
//                     style: Theme.of(context).textTheme.headlineLarge,
//                   ),
//                   const SizedBox(height: 14),
//                   if (!isMobile)
//                     Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             AppStrings.bussPermit,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             AppStrings.sanitPerm,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             AppStrings.dotCert,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                       ],
//                     ),
//                   (!isMobile)
//                       ? Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Flexible(
//                               child: Card(
//                                 child: Image.network(
//                                     value.establishment!.legals!['bussPermit']),
//                               ),
//                             ),
//                             Flexible(
//                               child: Card(
//                                 child: Image.network(
//                                     value.establishment!.legals!['sanitPerm']),
//                               ),
//                             ),
//                             Flexible(
//                               child: Card(
//                                 child: Image.network(
//                                     value.establishment!.legals!['dotCert']),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppStrings.bussPermit,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: Image.network(
//                                   value.establishment!.legals!['bussPermit']),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               AppStrings.sanitPerm,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: Image.network(
//                                   value.establishment!.legals!['sanitPerm']),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               AppStrings.dotCert,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             Card(
//                               child: Image.network(
//                                   value.establishment!.legals!['dotCert']),
//                             ),
//                           ],
//                         ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  bool isEditMode = false;
  late TextEditingController nameController;
  late TextEditingController aboutController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController socialLinkController;
  late TextEditingController websiteController;
  late TextEditingController buildingController;
  late TextEditingController streetController;
  late TextEditingController barangayController;
  late TextEditingController municipalityController;

  @override
  void initState() {
    super.initState();
    final establishment =
        Provider.of<EstablishmentProvider>(context, listen: false)
            .establishment!;
    nameController = TextEditingController(text: establishment.name);
    aboutController = TextEditingController(text: establishment.about);
    phoneController =
        TextEditingController(text: establishment.contact!['phone']);
    emailController =
        TextEditingController(text: establishment.contact!['email']);
    socialLinkController =
        TextEditingController(text: establishment.contact!['social_link']);
    websiteController =
        TextEditingController(text: establishment.contact!['website']);
    buildingController =
        TextEditingController(text: establishment.location!['bldg']);
    streetController =
        TextEditingController(text: establishment.location!['street']);
    barangayController =
        TextEditingController(text: establishment.location!['brgy']);
    municipalityController =
        TextEditingController(text: establishment.location!['municipality']);
  }

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    phoneController.dispose();
    emailController.dispose();
    socialLinkController.dispose();
    websiteController.dispose();
    buildingController.dispose();
    streetController.dispose();
    barangayController.dispose();
    municipalityController.dispose();
    super.dispose();
  }

  void saveChanges() async {
    final establishmentProvider =
        Provider.of<EstablishmentProvider>(context, listen: false);
    final establishment = establishmentProvider.establishment!;
    establishment.name = nameController.text;
    establishment.about = aboutController.text;
    establishment.contact!['phone'] = phoneController.text;
    establishment.contact!['email'] = emailController.text;
    establishment.contact!['social_link'] = socialLinkController.text;
    establishment.contact!['website'] = websiteController.text;
    establishment.location!['bldg'] = buildingController.text;
    establishment.location!['street'] = streetController.text;
    establishment.location!['brgy'] = barangayController.text;
    establishment.location!['municipality'] = municipalityController.text;

    print(establishment);

    setState(() {
      isEditMode = false;
    });
    // final response = await http.post(
    //   Uri.parse('http://your-flask-backend-url/endpoint'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     'name': establishment.name,
    //     'type': establishment.type,
    //     'about': establishment.about,
    //     'status': establishment.status,
    //     'contact': establishment.contact,
    //     'location': establishment.location,
    //   }),
    // );

    // if (response.statusCode == 200) {
    //   // If the server did return a 200 OK response,
    //   // then parse the JSON.
    //   setState(() {
    //     isEditMode = false;
    //   });
    // } else {
    //   // If the server did not return a 200 OK response,
    //   // then throw an exception.
    //   throw Exception('Failed to save changes');
    // }
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
                          controller: nameController,
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
                              controller: aboutController,
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
                                controller: nameController,
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
                                controller: aboutController,
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
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Phone',
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email address',
                        ),
                      ),
                      TextFormField(
                        controller: socialLinkController,
                        decoration: const InputDecoration(
                          hintText: 'Social media',
                        ),
                      ),
                      TextFormField(
                        controller: websiteController,
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
                        controller: buildingController,
                        decoration: const InputDecoration(
                          hintText: 'Building',
                        ),
                      ),
                      TextFormField(
                        controller: streetController,
                        decoration: const InputDecoration(
                          hintText: 'Street',
                        ),
                      ),
                      TextFormField(
                        controller: barangayController,
                        decoration: const InputDecoration(
                          hintText: 'Barangay',
                        ),
                      ),
                      TextFormField(
                        controller: municipalityController,
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
                  const SizedBox(height: 14),
                  // Partner info widget
                  _buildPartnerInfo(value, isMobile),
                  const SizedBox(height: 14),

                  isMobile
                      ? Column(
                          children: [
                            _buildContactInfo(value),
                            const SizedBox(height: 14),
                            _buildLocationInfo(value)
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _buildContactInfo(value)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildLocationInfo(value))
                          ],
                        )

                  // _buildContactInfo(value, isMobile),
                  // Location details
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
