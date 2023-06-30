import 'package:flutter/material.dart';

import '../utils/pretty_json.dart';

class CustomImagePicker extends StatefulWidget {
  final Function? getImage;
  final Stream imageStreamState;

  const CustomImagePicker({
    Key? key,
    this.getImage,
    required this.imageStreamState,
  }) : super(key: key);

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double minChildSize = 0.45, initialExtend = 0.455, maxChildSize = 0.9;
  double extent = 0;
  bool isGetMoreWhenScrollDown = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (DraggableScrollableNotification notification) {
        Logger.w(notification.toString());
        setState(
          () {
            extent = notification.extent;
          },
        );
        if (isGetMoreWhenScrollDown && extent >= initialExtend) {
          isGetMoreWhenScrollDown = false;
          widget.getImage?.call();
        }
        return false;
      },
      child: StreamBuilder(
        stream: widget.imageStreamState,
        builder: (context, data) => Stack(
          children: [],
        ),
      ),
    );
  }

  Widget _buildScrollSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.455,
      maxChildSize: maxChildSize,
      minChildSize: minChildSize,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              color: Colors.transparent,
                              child: Icon(
                                Icons.accessibility,
                                size: 50,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "Strings.allImage.i18n",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "{imagesChoosen.length}/6",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              color: Colors.transparent,
                              child: Icon(
                                Icons.check_circle_outlined,
                                size: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: PhotosGridView(
                  scrollController: controller,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PhotosGridView extends StatefulWidget {
  final ScrollController scrollController;
  const PhotosGridView({required this.scrollController});

  @override
  State<PhotosGridView> createState() => _PhotosGridViewState();
}

class _PhotosGridViewState extends State<PhotosGridView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
