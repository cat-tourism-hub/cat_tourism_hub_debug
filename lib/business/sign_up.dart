import 'dart:convert';
import 'dart:io';
import 'package:cat_tourism_hub/models/establishment.dart';
import 'package:cat_tourism_hub/models/photo.dart';
import 'package:cat_tourism_hub/queries/sql_query.dart';

import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final String municipalityUrl =
      'https://psgc.gitlab.io/api/provinces/052000000/municipalities/';
  List<Map<String, dynamic>> municipalities = [];
  List<Map<String, dynamic>> barangays = [];

  String selectedMunicipality = '';
  String selectedBarangay = '';

  String? bType;

  TextEditingController name = TextEditingController();
  TextEditingController? about = TextEditingController();
  TextEditingController? bldg = TextEditingController();
  TextEditingController? street = TextEditingController();
  TextEditingController? cName = TextEditingController();
  TextEditingController? email = TextEditingController();
  TextEditingController? pNum = TextEditingController();
  TextEditingController? socMed = TextEditingController();
  TextEditingController? website = TextEditingController();

  File? logo;
  Uint8List? logoWeb;
  String? logoPath;

  File? banner;
  Uint8List? bannerWeb;
  String? bannerPath;

  File? bussPerm;
  Uint8List? bussPermWeb;
  String? bussPermPath;

  File? sanitPerm;
  Uint8List? sanitPermWeb;
  String? sanitPermPath;

  File? dotCert;
  Uint8List? dotCertWeb;
  String? dotCertPath;

  Widget _buildStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _buildTypeStep(context);
      case 1:
        return _buildNameStep(context);
      case 2:
        return _buildLogoStep(context);
      case 3:
        return _buildBannerStep(context);
      case 4:
        return _buildLocationStep(context);
      case 5:
        return _buildPermitsStep(context);
      case 6:
        return _buildContactStep(context);
      default:
        return Container();
    }
  }

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  Widget _buildTypeStep(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Tell us about your business',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 20.0),
          ),
        ),
        DropdownButtonFormField<String>(
          items: const [
            DropdownMenuItem(
                value: AppStrings.accommodations,
                child: Text(AppStrings.accommodations)),
            DropdownMenuItem(
                value: AppStrings.restaurants,
                child: Text(AppStrings.restaurants)),
            DropdownMenuItem(
                value: AppStrings.hotelAndResto,
                child: Text(AppStrings.hotelAndResto)),
            DropdownMenuItem(
                value: AppStrings.vehicleRentals,
                child: Text(AppStrings.vehicleRentals)),
            DropdownMenuItem(
                value: AppStrings.delicacies,
                child: Text(AppStrings.delicacies)),
          ],
          onChanged: (value) {
            bType = value;
          },
          validator: (value) {
            if (value == null) {
              return 'Please select business type';
            }
            return null;
          },
          hint: const Text('Choose a Business Type'),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => nextStep(),
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildNameStep(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: name,
          decoration: const InputDecoration(
            labelText: 'Business Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) => (value == null || value.isEmpty)
              ? 'Please enter business name.'
              : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: about,
          decoration: const InputDecoration(
            labelText: 'About/Tagline',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => previousStep(),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () => nextStep(),
              child: const Text('Next'),
            ),
          ],
        )
      ],
    );
  }

  Future pickImage(String context) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (kIsWeb) {
      if (image != null) {
        var selected = await image.readAsBytes();

        if (context == 'logo') {
          setState(() {
            logoWeb = selected;
            logoPath = image.path;
          });
        } else if (context == 'banner') {
          setState(() {
            bannerWeb = selected;
            bannerPath = image.path;
          });
        } else if (context == 'bussPerm') {
          setState(() {
            bussPermWeb = selected;
            bussPermPath = image.path;
          });
        } else if (context == 'sanitPerm') {
          setState(() {
            sanitPermWeb = selected;
            sanitPermPath = image.path;
          });
        } else if (context == 'dotCert') {
          setState(() {
            dotCertWeb = selected;
            dotCertPath = image.path;
          });
        }
      }
    } else {
      if (image != null) {
        var selected = File(image.path);
        if (context == 'logo') {
          setState(() {
            logo = selected;
          });
        } else if (context == 'banner') {
          setState(() {
            banner = selected;
          });
        } else if (context == 'bussPerm') {
          setState(() {
            bussPerm = selected;
            bussPermPath = image.path;
          });
        } else if (context == 'sanitPerm') {
          setState(() {
            sanitPerm = selected;
            sanitPermPath = image.path;
          });
        } else if (context == 'dotCert') {
          setState(() {
            dotCert = selected;
            dotCertPath = image.path;
          });
        }
      }
    }
  }

  Widget _buildLogoStep(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Upload your business logo',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 20.0),
          ),
        ),
        GestureDetector(
          onTap: () => pickImage('logo'),
          child: CircleAvatar(
            radius: 100,
            child: logoWeb != null
                ? Image.memory(
                    logoWeb!,
                    fit: BoxFit.contain,
                  )
                : logo != null
                    ? Image.file(
                        logo!,
                        fit: BoxFit.contain,
                      )
                    : const Icon(
                        Icons.add_a_photo,
                        size: 50,
                      ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => previousStep(),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () => nextStep(),
              child: const Text('Next'),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildBannerStep(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Upload your business banner',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 20.0),
          ),
        ),
        GestureDetector(
          onTap: () => pickImage('banner'),
          child: Container(
            height: 300,
            width: 500,
            color: Colors.grey[300],
            child: bannerWeb != null
                ? Image.memory(
                    bannerWeb!,
                    fit: BoxFit.contain,
                  )
                : banner != null
                    ? Image.file(
                        banner!,
                        fit: BoxFit.contain,
                      )
                    : const Icon(
                        Icons.add_a_photo,
                        size: 50,
                      ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => previousStep(),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () => nextStep(),
              child: const Text('Next'),
            ),
          ],
        )
      ],
    );
  }

  Future<void> fetchMunicipalities() async {
    try {
      final response = await http.get(Uri.parse(municipalityUrl));
      if (response.statusCode == 200) {
        setState(() {
          municipalities = List<Map<String, dynamic>>.from(
            (json.decode(response.body) as List<dynamic>)
                .map((x) => Map<String, dynamic>.from(x)),
          );
        });
      }
    } catch (e) {
      print('Error occured: $e');
    }
  }

  Future<void> fetchBarangays(String selectedCode) async {
    try {
      final response = await http.get(Uri.parse(
          'https://psgc.gitlab.io/api/municipalities/$selectedCode/barangays/'));

      if (response.statusCode == 200) {
        setState(() {
          barangays = List<Map<String, dynamic>>.from(
            (json.decode(response.body) as List<dynamic>)
                .map((x) => Map<String, dynamic>.from(x)),
          );
        });
      }
    } catch (e) {
      print('Error occured: $e');
    }
  }

  Widget _buildLocationStep(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Where can guests find you?',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 20.0),
          ),
        ),
        TextFormField(
          controller: bldg,
          decoration: const InputDecoration(
            labelText: 'Building',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: street,
          decoration: const InputDecoration(
            labelText: 'Street',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField(
          items: municipalities.map((location) {
            return DropdownMenuItem(
              value: location['code'].toString(),
              child: Text(location['name'].toString()),
            );
          }).toList(),
          hint: const Text('Municipality'),
          onChanged: (value) {
            setState(() {
              selectedMunicipality = value.toString();
              fetchBarangays(selectedMunicipality);
            });
          },
          decoration: const InputDecoration(border: OutlineInputBorder()),
          validator: (value) {
            if (municipalities
                    .where((location) => location['code'].toString() == value)
                    .length !=
                1) {
              return 'Please select a municipality';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        // DropdownButtonFormField(
        //   items: barangays.map((location) {
        //     return DropdownMenuItem(
        //       value: location['code'].toString(),
        //       child: Text(location['name'].toString()),
        //     );
        //   }).toList(),
        //   hint: const Text('Barangay'),
        //   onChanged: (value) {
        //     setState(() {
        //       selectedBarangay = value.toString();
        //     });
        //   },
        //   decoration: const InputDecoration(border: OutlineInputBorder()),
        //   validator: (value) {
        //     if (barangays
        //             .where((location) => location['code'].toString() == value)
        //             .length !=
        //         1) {
        //       return 'Please select a barangay';
        //     }
        //     return null;
        //   },
        // ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => previousStep(),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () => nextStep(),
              child: const Text('Next'),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPermitsStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              'Legal Documents',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: 20.0),
            ),
          ),
        ),
        Text('Business Permit', style: Theme.of(context).textTheme.bodyMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () => pickImage('bussPerm'),
                child: const Text('Upload Image')),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey)),
                  child: Text(bussPermPath ?? '')),
            )
          ],
        ),
        const SizedBox(height: 20),
        Text('Sanitation Permit',
            style: Theme.of(context).textTheme.bodyMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () => pickImage('sanitPerm'),
                child: const Text('Upload Image')),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey)),
                  child: Text(sanitPermPath ?? '')),
            )
          ],
        ),
        const SizedBox(height: 20),
        Text('DOT Accredited Certification',
            style: Theme.of(context).textTheme.bodyMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () => pickImage('dotCert'),
                child: const Text('Upload Image')),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey)),
                  child: Text(dotCertPath ?? '')),
            )
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => previousStep(),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () => nextStep(),
              child: const Text('Next'),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildContactStep(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: cName,
          decoration: const InputDecoration(
            labelText: 'Person to contact',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter name.' : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: email,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter email.' : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: pNum,
          decoration: const InputDecoration(
            labelText: 'Contact Number',
            border: OutlineInputBorder(),
          ),
          validator: (value) => (value == null || value.isEmpty)
              ? 'Please enter contact number.'
              : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: socMed,
          decoration: const InputDecoration(
            labelText: 'Social media link',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: website,
          decoration: const InputDecoration(
            labelText: 'Website',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => previousStep(),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Establishment establishment = Establishment(
                    name: name.text,
                    about: about?.text,
                    type: bType!,
                    status: 'PENDING',
                    location: {
                      'bldg': bldg?.text,
                      'street': street?.text,
                      'municipality': selectedMunicipality,
                      'barangay': selectedBarangay,
                    },
                    contact: {
                      'name': cName?.text,
                      'email': email?.text,
                      'phone': pNum?.text,
                      'socmed': socMed?.text,
                      'website': website?.text,
                    },
                  );

                  List<Photo> photos = [
                    Photo(title: 'logo', image: logo, webImage: logoWeb),
                    Photo(title: 'banner', image: banner, webImage: bannerWeb),
                    Photo(
                        title: 'bussPerm',
                        image: bussPerm,
                        webImage: bussPermWeb),
                    Photo(
                        title: 'sanitPerm',
                        image: sanitPerm,
                        webImage: sanitPermWeb),
                    Photo(
                        title: 'dotCert', image: dotCert, webImage: dotCertWeb),
                  ];

                  await submitForm(establishment, photos);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    fetchMunicipalities();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    about?.dispose();
    bldg?.dispose();
    street?.dispose();
    cName?.dispose();
    email?.dispose();
    pNum?.dispose();
    socMed?.dispose();
    website?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(mainAxisSize: MainAxisSize.max, children: [
      if (MediaQuery.sizeOf(context).width > 600.0)
        Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 5.0, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SvgPicture.asset(
                'assets/images/undraw_building.svg',
                width: MediaQuery.sizeOf(context).width * 0.4,
                height: MediaQuery.sizeOf(context).height * 0.5,
                fit: BoxFit.contain,
                alignment: const Alignment(0.0, -1.0),
              ),
            ),
          ),
        ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'Be part of Catanduanes Tourism Hub',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(child: _buildStepContent(context)),
              ],
            ),
          ),
        ),
      ),
    ]));
  }
}
