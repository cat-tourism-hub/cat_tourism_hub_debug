// import 'dart:io';
// import 'package:cat_tourism_hub/auth/auth_provider.dart';
// import 'package:cat_tourism_hub/business/components/price_field.dart';
// import 'package:cat_tourism_hub/models/hotel_room.dart';
// import 'package:cat_tourism_hub/models/photo.dart';
// import 'package:cat_tourism_hub/providers/establishment_provider.dart';
// import 'package:cat_tourism_hub/providers/hotel_rooms_provider.dart';
// import 'package:cat_tourism_hub/utils/snackbar_helper.dart';
// import 'package:cat_tourism_hub/values/strings.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:simple_chips_input/simple_chips_input.dart';

// class AddRoom extends StatefulWidget {
//   const AddRoom({super.key, required this.toggleAddRoom, this.itemTitle});
//   final VoidCallback toggleAddRoom;
//   final String? itemTitle;

//   @override
//   State<AddRoom> createState() => _AddRoomState();
// }

// class _AddRoomState extends State<AddRoom> {
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController desController = TextEditingController();
//   final Map<String, TextEditingController> _controllers = {};
//   final ImagePicker _picker = ImagePicker();
//   List<Photo> _imageFiles = [];
//   String output = '';
//   String? deletedChip, deletedChipIndex;
//   List<String> amenities = [];
//   List<Map<String, String>> otherServices = [];
//   String amount = '';
//   String duration = '';
//   bool _isLoading = false;

//   void disposeControllers() {
//     nameController.dispose();
//     desController.dispose();
//   }

//   // Function for processing images
//   Future<void> _pickImages() async {
//     final List<XFile> pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles.isNotEmpty) {
//       if (kIsWeb) {
//         List<Photo> imageBytes = [];
//         for (var file in pickedFiles) {
//           Uint8List bytes = await file.readAsBytes();
//           imageBytes
//               .add(Photo(path: file.path, webImage: bytes, title: file.name));
//         }
//         setState(() {
//           _imageFiles = imageBytes;
//         });
//       } else {
//         setState(() {
//           _imageFiles = pickedFiles.map((file) {
//             return Photo(
//                 path: file.path, image: File(file.path), title: file.name);
//           }).toList();
//         });
//       }
//     }
//   }

//   // Value handler for price and duration widgets.
//   void _onCustomFieldChanged(String newAmount, String newDuration) {
//     setState(() {
//       amount = newAmount;
//       duration = newDuration;
//     });
//   }

//   @override
//   void dispose() {
//     disposeControllers();
//     super.dispose();
//   }

//   Future _submitRoomData() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final value1 = Provider.of<EstablishmentProvider>(context, listen: false);
//       final value3 =
//           Provider.of<AuthenticationProvider>(context, listen: false);
//       final value2 = Provider.of<HotelProvider>(context, listen: false);
//       HotelRoom room = HotelRoom(
//         name: nameController.text,
//         price: double.tryParse(amount) ?? 0,
//         desc: desController.text,
//         pricePer: duration,
//         photos: _imageFiles,
//         amenities: amenities,
//         otherServices: {
//           for (var field in otherServices)
//             _controllers['${field['key']}_name']?.text ?? '':
//                 _controllers['${field['key']}_value']?.text ?? ''
//         },
//       );
//       await value2.uploadNewRoom(
//           value3.token ?? '', value3.user!.uid, value1.establishment!, room);

//       SnackbarHelper.showSnackBar('${nameController.text} added succesfully');
//     } catch (e) {
//       SnackbarHelper.showSnackBar('Failed to upload room: ${e.toString()}');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     return SingleChildScrollView(
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         width: screenWidth,
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextButton.icon(
//                   onPressed: widget.toggleAddRoom,
//                   label: const Text(AppStrings.labelReturn),
//                   icon: const Icon(Icons.arrow_back)),
//               const SizedBox(height: 32),
//               Text('Add ${widget.itemTitle}',
//                   style: Theme.of(context).textTheme.headlineLarge),
//               GestureDetector(
//                 onTap: _pickImages,
//                 child: SizedBox(
//                   width: screenWidth,
//                   height: screenHeight * 0.3,
//                   child: _imageFiles.isNotEmpty
//                       ? Container(
//                           decoration: BoxDecoration(
//                               border: Border.all(color: Colors.black),
//                               borderRadius: BorderRadius.circular(10)),
//                           child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: _imageFiles.length,
//                               itemBuilder: (context, index) => kIsWeb
//                                   ? Container(
//                                       margin: const EdgeInsets.all(10),
//                                       child: Image.memory(
//                                           _imageFiles[index].webImage!,
//                                           fit: BoxFit.fill),
//                                     )
//                                   : Image.file(_imageFiles[index].image!,
//                                       fit: BoxFit.contain)),
//                         )
//                       : DottedBorder(
//                           borderType: BorderType.RRect,
//                           radius: const Radius.circular(10),
//                           dashPattern: const [6, 3],
//                           color: Colors.grey,
//                           child: const Center(
//                             child: Text(
//                               AppStrings.addThumbnail,
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: nameController,
//                       decoration: const InputDecoration(
//                           labelText: AppStrings.roomType,
//                           border: OutlineInputBorder()),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter the name';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               CustomTextFormField(onChanged: _onCustomFieldChanged),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: desController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                     labelText: AppStrings.description,
//                     border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 20),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   AppStrings.amenitiesIncluded,
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//               ),
//               SimpleChipsInput(
//                 separatorCharacter: ',',
//                 createCharacter: ',',
//                 onChipDeleted: (p0, p1) {
//                   setState(() {
//                     amenities.removeAt(p1);
//                   });
//                 },
//                 onChipAdded: (p0) {
//                   setState(() {
//                     amenities.add(p0);
//                   });
//                 },
//                 chipTextStyle: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                 ),
//                 deleteIcon: const Padding(
//                   padding: EdgeInsets.only(left: 8.0),
//                   child: Icon(
//                     Icons.remove_circle_outline_outlined,
//                     size: 14.0,
//                     color: Colors.red,
//                   ),
//                 ),
//                 widgetContainerDecoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 chipContainerDecoration: BoxDecoration(
//                   color: Colors.blue[100],
//                   border: Border.all(color: Colors.black, width: 1.5),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 placeChipsSectionAbove: false,
//               ),
//               const SizedBox(height: 20),
//               ...otherServices.map((field) {
//                 return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5.0),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: _controllers['${field['key']}_name'] =
//                                 TextEditingController(),
//                             decoration: const InputDecoration(
//                                 labelText: 'Name',
//                                 border: OutlineInputBorder()),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter a custom field name';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: TextFormField(
//                             controller: _controllers['${field['key']}_value'] =
//                                 TextEditingController(),
//                             decoration: const InputDecoration(
//                                 labelText: 'Value',
//                                 border: OutlineInputBorder()),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter a custom field value';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ));
//               }),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       otherServices.add({'key': UniqueKey().toString()});
//                     });
//                   },
//                   child: Text(AppStrings.addOtherServices,
//                       style: Theme.of(context).textTheme.bodyMedium),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                         ),
//                         onPressed: () {
//                           if (formKey.currentState?.validate() ?? false) {
//                             _submitRoomData();
//                           }
//                         },
//                         child: Text(AppStrings.save,
//                             style: Theme.of(context).textTheme.bodyMedium),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
