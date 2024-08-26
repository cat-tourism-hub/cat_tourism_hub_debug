import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_collage/image_collage.dart';

class PartnerDetails extends StatefulWidget {
  const PartnerDetails({super.key, required this.partner});
  final Establishment partner;

  @override
  State<PartnerDetails> createState() => _PartnerDetailsState();
}

class _PartnerDetailsState extends State<PartnerDetails> {
  double screenHeight = 0;
  double screenWidth = 0;
  List<Img> images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  _loadImages() async {
    if (widget.partner.facilities != null) {
      for (var field in widget.partner.facilities!.entries) {
        String url = await getDownloadUrl(field.value);
        images.add(Img(image: url));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _mobileView() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(appName)),
            body: const SingleChildScrollView(child: Column())));
  }

  Widget _desktopView() {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: screenWidth * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (images.isNotEmpty && !_isLoading)
                      SizedBox(
                        height: 450,
                        width: screenWidth * 0.45,
                        child: ImageCollage(
                          images: images,
                          margin: const EdgeInsets.all(2),
                          onClick: (clickedImg, images) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 300,
                                        childAspectRatio: 1,
                                      ),
                                      itemCount: images.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Image.network(
                                              images[index].image,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    const Gap(30),
                    Text(widget.partner.about ?? '')
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.sizeOf(context).height;
    screenWidth = MediaQuery.sizeOf(context).width;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (screenWidth < 1000) {
          return _mobileView();
        }
        return _desktopView();
      },
    );
  }
}
