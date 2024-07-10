// import 'package:cat_tourism_hub/auth/auth_provider.dart';
// import 'package:cat_tourism_hub/business/components/card.dart';
// import 'package:cat_tourism_hub/business/sections/subsections/add_room.dart';
// import 'package:cat_tourism_hub/providers/hotel_rooms_provider.dart';
// import 'package:cat_tourism_hub/values/strings.dart';
// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:provider/provider.dart';

// class RoomSection extends StatefulWidget {
//   const RoomSection({super.key});

//   @override
//   State<RoomSection> createState() => _RoomSectionState();
// }

// class _RoomSectionState extends State<RoomSection> {
//   bool showAddRoom = false;
//   late String token;
//   late String uid;

//   void toggleAddRoom() {
//     setState(() {
//       showAddRoom = !showAddRoom;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     final provider =
//         Provider.of<AuthenticationProvider>(context, listen: false);
//     final hotelProv = Provider.of<HotelProvider>(context, listen: false);
//     uid = provider.user!.uid;

//     hotelProv.fetchHotels(uid);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double gridItemWidth = MediaQuery.of(context).size.width < 1000 ? 300 : 400;
//     int crossAxisCount =
//         (MediaQuery.of(context).size.width / gridItemWidth).floor();

//     return Consumer<HotelProvider>(
//       builder: (context, value, child) {
//         return showAddRoom
//             ? AddRoom(
//                 toggleAddRoom: toggleAddRoom,
//                 itemTitle: 'Room',
//               )
//             : Stack(
//                 children: [
//                   if (value.isFetching && value.rooms.isEmpty)
//                     Center(
//                         child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(AppStrings.fetchingData),
//                         LoadingAnimationWidget.waveDots(
//                           color: Colors.black,
//                           size: 50,
//                         ),
//                       ],
//                     )),
//                   if (!value.isFetching && value.rooms.isEmpty)
//                     const Center(child: Text(AppStrings.noRooms)),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     itemCount: value.rooms.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: crossAxisCount,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                         childAspectRatio: 4 / 3),
//                     itemBuilder: (BuildContext context, int index) {
//                       final hotel = value.rooms[index];
//                       return BusinessDataCard(data: hotel);
//                     },
//                   ),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: ElevatedButton(
//                       onPressed: () => toggleAddRoom(),
//                       style: ElevatedButton.styleFrom(
//                         shape: const CircleBorder(),
//                         padding: const EdgeInsets.all(20),
//                         backgroundColor: Colors.green,
//                         foregroundColor: Colors.cyan,
//                       ),
//                       child: const Icon(Icons.add, color: Colors.white),
//                     ),
//                   )
//                 ],
//               );
//       },
//     );
//   }
// }
