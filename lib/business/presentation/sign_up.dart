import 'dart:convert';
import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/business/data/photo.dart';
import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/core/utils/snackbar_helper.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  List<Map<String, dynamic>> municipalities = [];
  List<Map<String, dynamic>> barangays = [];

  String selectedMunicipality = '';
  String selectedBarangay = '';

  String? bType;
  bool showLogoError = false;
  bool showBannerError = false;
  bool _isLoading = false;

  TextEditingController name = TextEditingController();
  TextEditingController? about = TextEditingController();
  TextEditingController? bldg = TextEditingController();
  TextEditingController? street = TextEditingController();
  TextEditingController? cName = TextEditingController();
  TextEditingController? email = TextEditingController();
  TextEditingController? pNum = TextEditingController();
  TextEditingController? socMed = TextEditingController();
  TextEditingController? website = TextEditingController();
  TextEditingController? otherTypeController = TextEditingController();

  Uint8List? logoWeb;
  String? logoPath;

  Uint8List? bannerWeb;
  String? bannerPath;

  Uint8List? bussPermWeb;
  String? bussPermPath;

  Uint8List? sanitPermWeb;
  String? sanitPermPath;

  Uint8List? dotCertWeb;
  String? dotCertPath;

  Future _saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Establishment establishment = Establishment(
        name: name.text,
        about: about?.text,
        type: bType!,
        status: AppStrings.pending,
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
        Photo(title: 'logo', image: logoWeb),
        Photo(title: 'banner', image: bannerWeb),
        Photo(title: 'bussPerm', image: bussPermWeb),
        Photo(title: 'sanitPerm', image: sanitPermWeb),
        Photo(title: 'dotCert', image: dotCertWeb),
      ];

      var result = await submitForm(establishment, photos);
      setState(() {
        _isLoading = false;
      });

      SnackbarHelper.showSnackBar(result);
    }
  }

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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            AppStrings.tellUsAboutYourBusiness,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        DropdownButtonFormField<String>(
          items: const [
            DropdownMenuItem(
                value: AppStrings.accommodations,
                child: Tooltip(
                    message: 'Select this if you offer accommodation only',
                    child: Text(AppStrings.accommodations))),
            DropdownMenuItem(
                value: AppStrings.restaurants,
                child: Tooltip(
                    message:
                        'Select this if you offer dining and catering services only',
                    child: Text(AppStrings.restaurants))),
            DropdownMenuItem(
                value: AppStrings.hotelAndResto,
                child: Tooltip(
                    message:
                        'Select this if you offer both accommodation and services.',
                    child: Text(AppStrings.hotelAndResto))),
            DropdownMenuItem(
                value: AppStrings.vehicleRentals,
                child: Tooltip(
                    message: 'Select this if you offer vehicle rentals.',
                    child: Text(AppStrings.vehicleRentals))),
            DropdownMenuItem(
                value: AppStrings.delicacies,
                child: Tooltip(
                    message:
                        'Select this if you offer happy island\'s homemade delicacies.',
                    child: Text(AppStrings.delicacies))),
            DropdownMenuItem(
                value: AppStrings.others, child: Text(AppStrings.others)),
          ],
          onChanged: (value) {
            setState(() {
              bType = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return AppStrings.pleaseSelectBusinessTypePrompt;
            }
            return null;
          },
          hint: const Text(AppStrings.chooseBusinessType),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          ),
        ),
        if (bType == AppStrings.others)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextFormField(
              controller: otherTypeController,
              decoration: const InputDecoration(
                labelText: AppStrings.pleaseSpecify,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              ),
              validator: (value) {
                if (bType == AppStrings.others &&
                    (value == null || value.isEmpty)) {
                  return AppStrings.pleaseSpecifyYourBusinessType;
                }
                return null;
              },
            ),
          ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (bType == AppStrings.others) {
                bType = otherTypeController!.text;
              }
            }
            nextStep();
          },
          child: const Text(AppStrings.next),
        ),
      ],
    );
  }

  Widget _buildNameStep(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                labelText: AppStrings.businessName,
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.isEmpty)
                  ? AppStrings.enterBusinessNamePrompt
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: about,
              decoration: const InputDecoration(
                labelText: AppStrings.about,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => previousStep(),
                  child: const Text(AppStrings.back),
                ),
                ElevatedButton(
                  onPressed: () => nextStep(),
                  child: const Text(AppStrings.next),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(String context) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageBytes = await image.readAsBytes();
    // final imageFile = !kIsWeb ? File(image.path) : null;

    final contextMap = {
      'logo': () {
        setState(() {
          logoWeb = imageBytes;
          logoPath = image.path;
        });
      },
      'banner': () {
        setState(() {
          bannerWeb = imageBytes;
          bannerPath = image.path;
        });
      },
      'bussPerm': () {
        setState(() {
          bussPermWeb = imageBytes;
          bussPermPath = image.name;
        });
      },
      'sanitPerm': () {
        setState(() {
          sanitPermWeb = imageBytes;
          sanitPermPath = image.name;
        });
      },
      'dotCert': () {
        setState(() {
          dotCertWeb = imageBytes;
          dotCertPath = image.name;
        });
      },
    };

    contextMap[context]?.call();
  }

  Widget _buildLogoStep(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            AppStrings.uploadBusinessLogo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        GestureDetector(
          onTap: () => pickImage('logo'),
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: logoWeb != null
                  ? Image.memory(
                      logoWeb!,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    )
                  : const Icon(
                      Icons.add_a_photo,
                      size: 50,
                    ),
            ),
          ),
        ),
        if (showLogoError)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              AppStrings.uploadImagePrompt,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => previousStep(),
              child: const Text(AppStrings.back),
            ),
            ElevatedButton(
              onPressed: () {
                if ((kIsWeb && logoWeb == null) || (logoPath == null)) {
                  setState(() {
                    showLogoError = true;
                  });
                  return;
                }

                nextStep();
              },
              child: const Text(AppStrings.next),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildBannerStep(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Upload your business banner',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        GestureDetector(
          onTap: () => pickImage('banner'),
          child: Container(
            height: 300,
            width: 500,
            decoration: BoxDecoration(
              color: bannerWeb == null ? Colors.grey[300] : null,
            ),
            child: bannerWeb != null
                ? Image.memory(
                    bannerWeb!,
                    fit: BoxFit.contain,
                  )
                : const Icon(
                    Icons.add_a_photo,
                    size: 50,
                  ),
          ),
        ),
        if (showBannerError)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Please upload an image',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => previousStep(),
              child: const Text(AppStrings.back),
            ),
            ElevatedButton(
              onPressed: () {
                if ((kIsWeb && bannerWeb == null) || (bannerPath == null)) {
                  setState(() {
                    showBannerError = true;
                  });
                  return;
                }
                nextStep();
              },
              child: const Text(AppStrings.next),
            ),
          ],
        )
      ],
    );
  }

  Future<void> fetchMunicipalities() async {
    try {
      final response = await http.get(Uri.parse(AppStrings.municipalitUrl));
      if (response.statusCode == 200) {
        setState(() {
          municipalities = List<Map<String, dynamic>>.from(
            (json.decode(response.body) as List<dynamic>)
                .map((x) => Map<String, dynamic>.from(x)),
          );
        });
      }
    } catch (e) {
      debugPrint('Error occured: $e');
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
      debugPrint('Error occured: $e');
    }
  }

  Widget _buildLocationStep(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Where can guests find you?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
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
              style: Theme.of(context).textTheme.bodyMedium,
              items: municipalities.map((location) {
                return DropdownMenuItem(
                  value: location['code'].toString(),
                  child: Text(location['name'].toString()),
                );
              }).toList(),
              hint: Text(
                'Municipality',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onChanged: (value) {
                setState(() {
                  selectedMunicipality = municipalities.firstWhere(
                      (location) => location['code'] == value)['name'];
                  fetchBarangays(value.toString());
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) {
                if (municipalities
                        .where(
                            (location) => location['code'].toString() == value)
                        .length !=
                    1) {
                  return 'Please select a municipality';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              items: barangays.map((location) {
                return DropdownMenuItem(
                  value: location['code'].toString(),
                  child: Text(location['name'].toString()),
                );
              }).toList(),
              hint: Text(
                'Barangay',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onChanged: (value) {
                setState(() {
                  selectedBarangay = barangays.firstWhere(
                      (location) => location['code'] == value)['name'];
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) {
                if (barangays
                        .where(
                            (location) => location['code'].toString() == value)
                        .length !=
                    1) {
                  return 'Please select a barangay';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => previousStep(),
                  child: const Text(AppStrings.back),
                ),
                ElevatedButton(
                  onPressed: () => nextStep(),
                  child: const Text(AppStrings.next),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPermitsStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              'Legal Documents',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
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
              child: const Text(AppStrings.back),
            ),
            ElevatedButton(
              onPressed: () => nextStep(),
              child: const Text(AppStrings.next),
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
              child: const Text(AppStrings.back),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveData,
              child: _isLoading
                  ? LoadingAnimationWidget.horizontalRotatingDots(
                      color: Colors.blue,
                      size: 30,
                    )
                  : const Text('Submit'),
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
              padding:
                  const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 5.0, 0.0),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text('Be part of Catanduanes Tourism Hub',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: _buildStepContent(context))),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
