import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/business/presentation/sections/products_services/components/card.dart';
import 'package:cat_tourism_hub/business/providers/product_provider.dart';
import 'package:cat_tourism_hub/core/components/loading_widget.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
import 'package:cat_tourism_hub/users/presentation/components/image_collage.dart';
import 'package:cat_tourism_hub/users/presentation/components/topbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_collage/image_collage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PartnerDetails extends StatefulWidget {
  const PartnerDetails({super.key, required this.partner});
  final Establishment partner;

  @override
  State<PartnerDetails> createState() => _PartnerDetailsState();
}

class _PartnerDetailsState extends State<PartnerDetails> {
  double _screenWidth = 0;
  final List<Img> _images = [];
  final List<String> _captions = [];
  bool _isLoading = true;
  DateTimeRange? _selectedDateRange;
  int _adults = 1;
  int _children = 0;
  bool _travelingWithPets = false;
  bool _guestSet = false;
  late ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _loadImages();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.fetchProducts(widget.partner.id ?? '');
  }

  Future<void> _loadImages() async {
    if (widget.partner.facilities != null) {
      for (var field in widget.partner.facilities!.entries) {
        String url = await getDownloadUrl(field.value);
        setState(() {
          _images.add(Img(image: url));
          _captions.add(field.key);
        });
      }
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

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

  Widget _imageBuilder() {
    if (_isLoading) {
      return LoadingWidget(screenWidth: _screenWidth);
    }
    return ImageCollageWidget(
      images: _images,
      captions: _captions,
    );
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

  Widget _mobileView(ProductProvider value) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(appName)),
            body: const SingleChildScrollView(child: Column())));
  }

  Widget _desktopView(ProductProvider value) {
    String dateRangeText = AppStrings.selectDateRange;
    if (_selectedDateRange != null) {
      dateRangeText =
          '${DateFormat('EEE, MMM d').format(_selectedDateRange!.start)} — ${DateFormat('EEE, MMM d').format(_selectedDateRange!.end)}';
    }
    return SafeArea(
        child: Scaffold(
      appBar: const Topbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: SizedBox(
              width:
                  _screenWidth < 1200 ? _screenWidth * 0.8 : _screenWidth * 0.7,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.partner.name ?? '',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const Gap(10),
                    ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        iconColor: Theme.of(context).indicatorColor,
                        title: Text(
                          widget.partner.locationString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(flex: 3, child: _imageBuilder()),
                        const Gap(10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Reviews Panel
                              SizedBox(
                                height: 130,
                                child: Container(
                                    color: Colors.grey,
                                    child: const Text('Reviews Panel')),
                              ),
                              const Gap(10),
                              // Google Maps API Panel
                              SizedBox(
                                height: 310,
                                child: Container(
                                    color: Colors.grey,
                                    child: const Text('Google Maps API')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Gap(30),
                    SizedBox(
                        width: _screenWidth < 1200
                            ? _screenWidth * 0.6
                            : _screenWidth * 0.4,
                        child: Text(widget.partner.about ?? '')),
                    const Gap(30),
                    const Divider(thickness: 2),
                    Text(AppStrings.availability,
                        style: Theme.of(context).textTheme.headlineLarge),
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
                    const Gap(10),
                    GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        shrinkWrap: true,
                        itemCount: value.products.length,
                        itemBuilder: (context, index) {
                          return BusinessDataCard(data: value.products[index]);
                        })
                  ]),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.sizeOf(context).width;
    return Consumer<ProductProvider>(
        builder: (context, value, widget) =>
            _screenWidth < 800 ? _mobileView(value) : _desktopView(value));
  }
}
