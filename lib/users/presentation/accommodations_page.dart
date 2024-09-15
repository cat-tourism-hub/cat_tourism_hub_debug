import 'dart:isolate';

import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/business/data/product.dart';
import 'package:cat_tourism_hub/business/providers/product_provider.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
import 'package:cat_tourism_hub/users/presentation/components/product_card.dart';
import 'package:cat_tourism_hub/users/presentation/components/product_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/icon_pack.dart';
import 'package:flutter_iconpicker/Serialization/icondata_serialization.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AccommodationsPage extends StatefulWidget {
  const AccommodationsPage({super.key, required this.partner});

  final Establishment partner;

  @override
  State<AccommodationsPage> createState() => _AccommodationsPageState();
}

class _AccommodationsPageState extends State<AccommodationsPage> {
  String dateRangeText = AppStrings.selectDateRange;
  DateTimeRange? _selectedDateRange;
  int _adults = 1;
  int _children = 0;
  bool _travelingWithPets = false;
  bool _guestSet = false;

  ButtonStyle _elevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      textStyle:
          Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
      iconColor: Theme.of(context).indicatorColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  _guestCounterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(AppStrings.guests,
                  style: Theme.of(context).textTheme.headlineSmall),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _guestSet = true;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(AppStrings.done),
                ),
              ],
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Adults'),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => setStateDialog(() {
                                if (_adults > 1) _adults--;
                              }),
                              icon: const Icon(Icons.remove),
                            ),
                            Text(_adults.toString()),
                            IconButton(
                              onPressed: () => setStateDialog(() => _adults++),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Children Counter
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(child: Text('Children')),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => setStateDialog(() {
                                if (_children > 0) _children--;
                              }),
                              icon: const Icon(Icons.remove),
                            ),
                            Text(_children.toString()),
                            IconButton(
                              onPressed: () =>
                                  setStateDialog(() => _children++),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(10),
                    // Travelling with pets
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(child: Text('Traveling with pets?')),
                        Switch(
                          value: _travelingWithPets,
                          onChanged: (value) {
                            setStateDialog(() {
                              _travelingWithPets = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAmenities(amenities, {BoxConstraints? boxConstraints}) {
    return Wrap(
      spacing: 20, // Space between the items horizontally
      runSpacing: 10.0, // Space between the items vertically
      children: amenities.map<Widget>((amenity) {
        return ConstrainedBox(
          constraints: boxConstraints ??
              BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width /
                      3), // Adjust width for 3 columns
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main heading with an icon for the category
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    deserializeIcon(
                          amenity['icon'],
                          iconPack: IconPack.allMaterial,
                        ) ??
                        Icons.check,
                    size: 24,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      amenity['heading'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              // Sub-items under the heading
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (amenity['subFields'] as List<dynamic>)
                      .map<Widget>((subField) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            deserializeIcon(
                                  subField['icon'],
                                  iconPack: IconPack.allMaterial,
                                ) ??
                                Icons.check,
                            size: 18,
                          ),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              subField['text'],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts(widget.partner.id ?? '');
  }

  double getHeight(double scaledValue) {
    if (scaledValue < 12) {
      return 430;
    } else if (scaledValue > 11 && scaledValue < 16.5) {
      return 480;
    } else if (scaledValue > 16.5 && scaledValue < 25) {
      return 600;
    } else {
      return 680;
    }
  }

  double getWidth(double scaledValue) {
    if (scaledValue < 12) {
      return 380;
    } else if (scaledValue > 12 && scaledValue < 16) {
      return 380;
    } else {
      return 480;
    }
  }

  _showProductPopup(Product product) async {
    List<String> images = [];

    for (String path in product.photos ?? []) {
      images.add(await getDownloadUrl(path));
    }

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(child: ProductInfo(product: product, images: images));
        });
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final boxConstraints = screenWidth < 1000
        ? BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 3)
        : BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 3 - 150);

    if (_selectedDateRange != null) {
      dateRangeText =
          '${DateFormat('EEE, MMM d').format(_selectedDateRange!.start)} — ${DateFormat('EEE, MMM d').format(_selectedDateRange!.end)}';
    }
    return Consumer<ProductProvider>(
      builder: (context, value, child) => SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Gap(20),
          Text(AppStrings.availability,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
          const Gap(20),
          // Date Range ang Guest count
          Row(
            children: [
              Flexible(
                child: ElevatedButton(
                  style: _elevatedButtonStyle(context),
                  onPressed: () => _selectDateRange(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined),
                      const Gap(8),
                      Flexible(
                        child: Text(
                          dateRangeText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Gap(5),
              Flexible(
                child: ElevatedButton(
                  style: _elevatedButtonStyle(context),
                  onPressed: () => setState(() {
                    _guestCounterDialog(context);
                  }),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_outline),
                      const Gap(8),
                      _guestSet
                          ? Text(
                              '$_adults adults, $_children ${_children > 1 ? 'children' : 'child'}${_travelingWithPets ? ', with pets' : ''}')
                          : const Text(AppStrings.guests)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(30),
          SizedBox(
            height: getHeight(textScale.scale(14)),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.products.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _showProductPopup(value.products[index]),
                  child: Container(
                    width: getWidth(textScale.scale(14)),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProductCard(
                        establishment: widget.partner,
                        product: value.products[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(20),
          const Divider(thickness: 1),
          const Gap(20),
          Text(AppStrings.amenities,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
          const Gap(20),
          _buildAmenities(widget.partner.amenities ?? [],
              boxConstraints: boxConstraints)
        ]),
      ),
    );
  }
}
