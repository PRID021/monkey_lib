import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monkey_lib/widgets/context_extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/two_text_button.dart';

const k300Duration = Duration(milliseconds: 300);

class CustomImagePicker extends StatefulWidget {
  final bool multipleSelect;
  const CustomImagePicker({
    Key? key,
    this.multipleSelect = false,
  }) : super(key: key);

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final initialExtend = 0.455;
  double extent = 0;
  bool isGetMoreWhenScrollUp = true;
  _DeviceImageBloc _bloc = _DeviceImageBloc();
  bool isPhotoType = true;

  @override
  void initState() {
    super.initState();
    _bloc.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (DraggableScrollableNotification notification) {
        // setState(
        //   () {
        //     extent = notification.extent;
        //     dev.log("Notification extent....${notification.extent}");
        //   },
        // );
        // dev.log("After Load more image from device....51");
        // if (!isGetMoreWhenScrollUp && extent >= initialExtend) {
        //   isGetMoreWhenScrollUp = false;
        //   dev.log("Load more image from device....");
        //   widget.getImage?.call();
        // }
        dev.log("Notification extent....${notification.extent}");
        return false;
      },
      // child: StreamBuilder(
      //   stream: _bloc.streamState,
      //   builder: (context, data) => _buildScrollSheet(context),
      // ),
      child: _buildScrollSheet(context),
    );
  }

  Widget _buildHeaderScrollSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      height: 111,
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              SizedBox(
                width: 6,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Cancel",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF007AFF)),
                ),
              ),
              SizedBox(
                width: 49,
              ),
              SizedBox(
                height: 32,
                child: TwoTextToggleButton(
                  fistContext: "Photos",
                  secondContext: "Albums",
                  isFirstSelected: isPhotoType,
                  onToggle: (value) {
                    setState(
                      () {
                        isPhotoType = value;
                        _bloc = _DeviceImageBloc()..init();
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                width: 49,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, _bloc.getImagesSelected());
                },
                child: Text(
                  "OK",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF007AFF)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 13,
          ),
          SizedBox(
            height: 34,
            child: TextField(
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: Colors.black),
              decoration: InputDecoration(
                  fillColor: const Color(0xFF767680),
                  filled: true,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(style: BorderStyle.solid),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(style: BorderStyle.none),
                  ),
                  errorBorder: InputBorder.none,
                  // errorBorder: InputBorder.none,
                  suffixIcon: const Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.mic_rounded,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  prefixIcon: const Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.search,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  hintText: "Photos, People, Places...",
                  contentPadding: EdgeInsets.symmetric(vertical: 2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollSheet(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.90,
      initialChildSize: 0.90,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              _buildHeaderScrollSheet(context),
              const SizedBox(height: 8),
              Expanded(
                child: isPhotoType
                    ? _PhotosGridView(
                        scrollController: controller,
                        imageStream: _bloc.streamState,
                        getMore: _bloc.getMoreImages,
                        onSelectedChange: _bloc.onSelectedChange,
                        multipleSelect: widget.multipleSelect,
                      )
                    : GalleryGridView(
                        scrollController: ScrollController(),
                        galleryStream: _bloc.streamState,
                        getAlbum: _bloc.getAlbum,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GalleryGridView extends StatefulWidget {
  const GalleryGridView(
      {Key? key,
      required this.scrollController,
      required this.galleryStream,
      required,
      required this.getAlbum})
      : super(key: key);
  final ScrollController scrollController;
  final Stream galleryStream;
  final Function getAlbum;

  @override
  State<GalleryGridView> createState() => _GalleryGridViewState();
}

class _GalleryGridViewState extends State<GalleryGridView> {
  @override
  initState() {
    super.initState();
    widget.getAlbum.call();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.galleryStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        if (snapshot.data is _DevicePathAlbumState) {
          _DevicePathAlbumState data = snapshot.data as _DevicePathAlbumState;
          if (data.isGetting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: data.mapAlbumEntity.keys.length,
            controller: widget.scrollController,
            itemBuilder: (context, index) {
              AssetPathEntity pathEntity =
                  data.mapAlbumEntity.keys.elementAt(index);
              List<AssetEntityImageProvider> _imageProvider =
                  data.thumbnailsProvider[
                      data.mapAlbumEntity.keys.elementAt(index)]!;
              List<File?> files = data.mapAlbumFile[pathEntity]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.mapAlbumEntity.keys.elementAt(index).name,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: GridView.builder(
                      addRepaintBoundaries: true,
                      addAutomaticKeepAlives: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.isTablet ? 5 : 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount:
                          _imageProvider.length < 6 ? _imageProvider.length : 6,
                      itemBuilder: (context, index) {
                        return Stack(children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: _imageProvider.elementAt(index),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            child: AnimatedContainer(
                              duration: k300Duration,
                              color: index == 5 && _imageProvider.length > 6
                                  ? Colors.red.withOpacity(0.3)
                                  : Colors.transparent,
                              child: SizedBox.expand(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Visibility(
                                    visible:
                                        index == 5 && _imageProvider.length > 6,
                                    child: Container(
                                      margin: const EdgeInsets.all(40),
                                      decoration: const BoxDecoration(
                                          color: Colors.lightGreen,
                                          shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      // height: 26,
                                      // width: 26,
                                      child:
                                          Text("+${_imageProvider.length - 6}"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if (index < 5 ||
                                      (index == 5 &&
                                          _imageProvider.length == 6)) {
                                    bool? result =
                                        // await navigateTo(CustomPhotoPreview(
                                        //   imageProvider: FileImage(
                                        //     files[index]!,
                                        //   ),
                                        //   index: index,
                                        // ));
                                        await Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                      return CustomPhotoPreview(
                                        imageProvider: FileImage(
                                          files[index]!,
                                        ),
                                        index: index,
                                      );
                                    }));
                                    if (result == true) {
                                      Navigator.pop(context, [files[index]!]);
                                    }
                                  } else {
                                    File? _file = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return CustomPhotoGallery(
                                          pathEntity: pathEntity,
                                          files: files,
                                          imageProviders: _imageProvider,
                                        );
                                      }),
                                    );
                                    if (_file != null) {
                                      Navigator.pop(context, [_file]);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ]);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _DeviceImageBloc {
  final DeviceImageService _imageService = DeviceImageService();
  final DeviceAlbumService _albumService = DeviceAlbumService();

  //
  final _state = BehaviorSubject<_DeviceAssetState?>.seeded(null);
  _DeviceAssetState? get state => _state.value;
  set state(_DeviceAssetState? value) => _state.sink.add(value);
  Stream<_DeviceAssetState?> get streamState => _state.stream;

  Future<void> init() async {
    state = _DeviceImageState(fileMap: {}, iSelectedPaths: [], isGetting: true);
    await _imageService.init();
    await _imageService.getNextImagePage();
    Map<File, AssetEntityImageProvider> fileMap = _imageService.getMapFiles;
    List<String> paths = [];

    state = _DeviceImageState(
      fileMap: fileMap,
      iSelectedPaths: paths,
      isGetting: false,
    );
  }

  Future getMoreImages() async {
    dev.log(
        "Bloc device image handling getMore process with isOver:${_imageService.isOver}  and  isGetting:${_imageService.isGetting}");
    if (_imageService.isOver || _imageService.isGetting) {
      dev.log("Block getMore...");
      return;
    }
    state = (state as _DeviceImageState?)?.copyWith(isGetting: true);

    await _imageService.getNextImagePage();
    List<String> paths = [];
    Map<File, AssetEntityImageProvider> fileMap = _imageService.getMapFiles;
    if (fileMap.isNotEmpty) {
      state = _DeviceImageState(
        fileMap: fileMap,
        iSelectedPaths: paths,
        isGetting: false,
      );
    }
    dev.log(
        "Bloc device image handling getMore process completed with result ..... ${fileMap.length}");
  }

  void onSelectedChange(String pathValue, bool multipleSelect) {
    if (multipleSelect) {
      _onMultipleSelect(pathValue);
    } else {
      _onSingleSelect(pathValue);
    }
  }

  void _onMultipleSelect(String pathValue) {
    if (state != null) {
      _DeviceImageState _state = (state as _DeviceImageState);
      List<String> _currentSelectedPaths = _state.selectedPaths.toList();
      int indexOfPathValue =
          _currentSelectedPaths.indexWhere((element) => element == pathValue);
      if (indexOfPathValue == -1) {
        _currentSelectedPaths.add(pathValue);
      } else {
        _currentSelectedPaths.removeAt(indexOfPathValue);
      }
      state = (state as _DeviceImageState?)
          ?.copyWith(selectedPaths: _currentSelectedPaths);
    }
    return;
  }

  void _onSingleSelect(String pathValue) {
    if (state != null) {
      _DeviceImageState _state = state as _DeviceImageState;
      List<String> _currentSelectedPaths = _state.selectedPaths.toList();
      int indexOfPathValue =
          _currentSelectedPaths.indexWhere((element) => element == pathValue);
      if (indexOfPathValue != -1) {
        _currentSelectedPaths = [];
      } else {
        _currentSelectedPaths = [pathValue];
      }
      state = (state as _DeviceImageState?)
          ?.copyWith(selectedPaths: _currentSelectedPaths);
    }
    return;
  }

  List<File> getImagesSelected() {
    List<File> selectedFiles = [];
    if (state != null) {
      _DeviceImageState _state = state as _DeviceImageState;
      List<String> selectedPaths = _state.selectedPaths;

      Map<File, AssetEntityImageProvider> fileMap = _state.fileMap;
      List<File> files = fileMap.keys.toList();
      selectedFiles =
          files.where((file) => selectedPaths.contains(file.path)).toList();
    }
    return selectedFiles;
  }

  /// album section
  void getAlbum() async {
    state = _DevicePathAlbumState(
        isGetting: true,
        thumbnailsProvider: {},
        mapAlbumEntity: {},
        mapAlbumFile: {});
    if (!_albumService.initialized) {
      await _albumService.init();
    }

    state = _DevicePathAlbumState(
        isGetting: false,
        thumbnailsProvider: _albumService.mapThumbnailsProvider,
        mapAlbumFile: _albumService.mapAlbumFile,
        mapAlbumEntity: _albumService.mapAlbum);
  }
}

abstract class _DeviceAssetState {}

class _DeviceImageState extends _DeviceAssetState {
  final List<String> selectedPaths;
  final Map<File, AssetEntityImageProvider> fileMap;
  final bool isGetting;
  _DeviceImageState._internal({
    required this.fileMap,
    required this.selectedPaths,
    this.isGetting = false,
  });
  factory _DeviceImageState({
    required Map<File, AssetEntityImageProvider> fileMap,
    required List<String> iSelectedPaths,
    bool isGetting = false,
  }) {
    return _DeviceImageState._internal(
      fileMap: Map.unmodifiable(fileMap),
      selectedPaths: List.unmodifiable(iSelectedPaths),
      isGetting: isGetting,
    );
  }

  _DeviceImageState copyWith({
    final Map<File, AssetEntityImageProvider>? fileMap,
    final List<String>? selectedPaths,
    final bool? isGetting,
  }) {
    Map<File, AssetEntityImageProvider>? _mutableFileMap = Map.of(this.fileMap);
    List<String>? _mutablePaths = this.selectedPaths.toList();
    return _DeviceImageState(
      fileMap: fileMap ?? _mutableFileMap,
      iSelectedPaths: selectedPaths ?? _mutablePaths,
      isGetting: isGetting ?? this.isGetting,
    );
  }
}

class _DevicePathAlbumState extends _DeviceAssetState {
  final Map<AssetPathEntity, List<AssetEntity>> mapAlbumEntity;
  final Map<AssetPathEntity, List<File?>> mapAlbumFile;
  final Map<AssetPathEntity, List<AssetEntityImageProvider>> thumbnailsProvider;
  final bool isGetting;
  _DevicePathAlbumState._internal(this.isGetting, this.mapAlbumFile,
      this.thumbnailsProvider, this.mapAlbumEntity);
  factory _DevicePathAlbumState(
      {required Map<AssetPathEntity, List<AssetEntity>> mapAlbumEntity,
      required Map<AssetPathEntity, List<File?>> mapAlbumFile,
      required Map<AssetPathEntity, List<AssetEntityImageProvider>>
          thumbnailsProvider,
      required bool isGetting}) {
    return _DevicePathAlbumState._internal(
        isGetting, mapAlbumFile, thumbnailsProvider, mapAlbumEntity);
  }
}

class _PhotosGridView extends StatefulWidget {
  final Function? getMore;
  final Function(String path, bool multipleSelect) onSelectedChange;
  final ScrollController scrollController;
  final Stream imageStream;
  final bool multipleSelect;
  const _PhotosGridView({
    Key? key,
    required this.scrollController,
    required this.imageStream,
    required this.getMore,
    required this.onSelectedChange,
    required this.multipleSelect,
  }) : super(key: key);

  @override
  State<_PhotosGridView> createState() => __PhotosGridViewState();
}

class __PhotosGridViewState extends State<_PhotosGridView> {
  late final ScrollController _scrollController = widget.scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(handleWhenScroll);
  }

  void handleWhenScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 80) {
      dev.log("Handle get more when scroll");
      widget.getMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.imageStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data is _DeviceImageState) {
          _DeviceImageState state = (snapshot.data as _DeviceImageState);
          Map<File, AssetEntityImageProvider> fileMap = state.fileMap;

          List<String> imagesChosenPath = state.selectedPaths;
          List<File> images = fileMap.keys.toList();
          bool isGetting = state.isGetting;
          return GridView.builder(
            addRepaintBoundaries: true,
            addAutomaticKeepAlives: true,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isTablet ? 5 : 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: !isGetting ? fileMap.length : fileMap.length + 20,
            itemBuilder: (context, index) {
              if (index < fileMap.length) {
                int indexOfFile = index;
                AssetEntityImageProvider _imageProvider =
                    fileMap[images[index]]!;
                int indexImageChosenPath = imagesChosenPath
                    .indexWhere((path) => path == images[index].path);
                String filePath = images[indexOfFile].path;
                return _buildImageComponent(
                    _imageProvider, indexImageChosenPath, filePath);
              }
              return _buildImageShimmer;
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildImageComponent(AssetEntityImageProvider _imageProvider,
      int indexImageChosenPath, String filePath) {
    return GestureDetector(
      onTap: () {
        widget.onSelectedChange.call(filePath, widget.multipleSelect);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedContainer(
            duration: k300Duration,
            color: indexImageChosenPath != -1
                ? Colors.white.withOpacity(0.3)
                : Colors.transparent,
            child: SizedBox.expand(
              child: Align(
                alignment: Alignment.center,
                child: Visibility(
                  visible: indexImageChosenPath != -1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.multipleSelect
                          ? Colors.lightGreen
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    height: 26,
                    width: 26,
                    child: widget.multipleSelect
                        ? Text(
                            "${indexImageChosenPath + 1}",
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 10,
                            ),
                          )
                        : const Icon(Icons.check),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget get _buildImageShimmer {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    enabled: true,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      height: 26,
      width: 26,
    ),
  );
}

class PressRipple extends StatefulWidget {
  final Widget child;
  final VoidCallback onPress;

  const PressRipple({
    Key? key,
    required this.child,
    required this.onPress,
  }) : super(key: key);

  @override
  _PressRippleState createState() => _PressRippleState();
}

class _PressRippleState extends State<PressRipple> {
  late InteractiveInkFeature _inkFeature;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (d) {
        _inkFeature = InkRipple(
          position: d.localPosition,
          color: Colors.green,
          controller: Material.of(context)!,
          referenceBox: context.findRenderObject() as RenderBox,
          textDirection: TextDirection.ltr,
          containedInkWell: true,
        );
        widget.onPress();
      },
      onTapUp: (d) {
        _inkFeature.dispose();
      },
      child: widget.child,
    );
  }
}

class CustomPhotoGallery extends StatefulWidget {
  final AssetPathEntity pathEntity;
  final List<AssetEntityImageProvider> imageProviders;
  final List<File?> files;

  const CustomPhotoGallery(
      {key,
      required this.pathEntity,
      required this.imageProviders,
      required this.files});

  @override
  State<CustomPhotoGallery> createState() => _CustomPhotoGalleryState();
}

class _CustomPhotoGalleryState extends State<CustomPhotoGallery> {
  final List<String> chosenImage = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      widget.files
                          .firstWhere((e) => chosenImage.contains(e!.path)));
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: GridView.builder(
          addRepaintBoundaries: true,
          addAutomaticKeepAlives: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.isTablet ? 5 : 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: widget.imageProviders.length,
          itemBuilder: (context, index) {
            File? _file = widget.files[index];
            AssetEntityImageProvider _imageProvider =
                widget.imageProviders.elementAt(index);
            int indexImageChosenPath = 0;
            return _buildImageComponent(_imageProvider, _file);
          },
        ));
  }

  Widget _buildImageComponent(
      AssetEntityImageProvider _imageProvider, File? file) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (chosenImage.contains(file?.path)) {
            chosenImage.remove(file?.path);
          } else {
            String path = file!.path;
            chosenImage.add(path);
          }
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedContainer(
            duration: k300Duration,
            color: (file != null ? chosenImage.contains(file.path) : false)
                ? Colors.white.withOpacity(0.3)
                : Colors.transparent,
            child: SizedBox.expand(
              child: Align(
                alignment: Alignment.center,
                child: Visibility(
                  visible:
                      (file != null ? chosenImage.contains(file.path) : false),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    height: 26,
                    width: 26,
                    child: const Icon(Icons.check),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPhotoPreview extends StatefulWidget {
  final ImageProvider imageProvider;
  final int index;

  const CustomPhotoPreview(
      {key, required this.imageProvider, required this.index});

  @override
  State<CustomPhotoPreview> createState() => _CustomPhotoPreviewState();
}

class _CustomPhotoPreviewState extends State<CustomPhotoPreview> {
  late PhotoViewController controller;
  late double? scaleCopy;

  @override
  initState() {
    super.initState();
    controller = PhotoViewController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue value) {
    setState(() {
      scaleCopy = value.scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: PhotoView(
        imageProvider: widget.imageProvider,
        heroAttributes: PhotoViewHeroAttributes(tag: widget.index),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        gaplessPlayback: false,
        customSize: MediaQuery.of(context).size,
        enableRotation: true,
        controller: controller,
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 1.8,
        initialScale: PhotoViewComputedScale.contained,
        basePosition: Alignment.center,
      ),
    );
  }
}

class DeviceAlbumService {
  bool initialized = false;
  bool isOver = false;
  bool isGetting = false;
  bool isGranted = false;
  late List<AssetPathEntity> _pathEntities;
  final Map<AssetPathEntity, List<AssetEntity>> mapAlbum = {};
  final Map<AssetPathEntity, List<File?>> mapAlbumFile = {};
  final Map<AssetPathEntity, List<AssetEntityImageProvider>>
      mapThumbnailsProvider = {};

  Future<void> init() async {
    isGranted = await _PermissionHelper.requestPermission(Permission.photos);
    if (isGranted) {
      _pathEntities =
          await PhotoManager.getAssetPathList(type: RequestType.image);

      for (AssetPathEntity pathEntity in _pathEntities) {
        int countItem = await pathEntity.assetCountAsync;
        List<AssetEntity> assetEntities =
            await pathEntity.getAssetListRange(start: 0, end: countItem);
        mapAlbum[pathEntity] = assetEntities;
        List<File?> files = [];
        List<AssetEntityImageProvider> _thumbnailsProvider = [];
        for (AssetEntity entity in assetEntities) {
          File? file = await entity.file;
          files.add(file);
          AssetEntityImageProvider thumbnailProvider = AssetEntityImageProvider(
            entity,
            isOriginal: false,
            thumbnailSize: const ThumbnailSize.square(200),
          );
          _thumbnailsProvider.add(thumbnailProvider);
        }
        mapAlbumFile[pathEntity] = files;
        mapThumbnailsProvider[pathEntity] = _thumbnailsProvider;
      }
    }
    initialized = true;
  }
}

class DeviceImageService {
  bool isOver = false;
  bool isGetting = false;
  bool isGranted = false;
  late List<AssetPathEntity> _pathEntities;
  final List<File> _imagesFile = [];
  final Map<File, AssetEntityImageProvider> _filesMap = {};

  final int numberAssetPerPage = 20;

  Future<void> init() async {
    isGranted = await _PermissionHelper.requestPermission(Permission.photos);
    if (isGranted) {
      _pathEntities =
          await PhotoManager.getAssetPathList(type: RequestType.image);
    }
  }

  Future<dynamic> getNextImagePage() async {
    if (isGetting || isOver || !isGranted) {
      return;
    }
    isGetting = true;
    List<AssetEntity> newAssetEntities =
        await _pathEntities[0].getAssetListRange(
      start: _imagesFile.length,
      end: _imagesFile.length + numberAssetPerPage,
    );

    if (newAssetEntities.length < numberAssetPerPage - 1) {
      isOver = true;
    }
    for (AssetEntity assetEntity in newAssetEntities) {
      File? file = await assetEntity.file;
      AssetEntityImageProvider thumbnailProvider = AssetEntityImageProvider(
        assetEntity,
        isOriginal: false,
        thumbnailSize: const ThumbnailSize.square(200),
      );

      if (file != null) {
        _imagesFile.add(file);
        _filesMap[file] = thumbnailProvider;
      }
    }
    isGetting = false;
    return;
  }

  void releaseMemory() {
    isOver = false;
    _pathEntities.clear();
    _filesMap.clear();

    PhotoManager.releaseCache();
  }

  List<File> getImageFiles(int indexStart, int indexEnd) {
    return _imagesFile.sublist(indexStart, indexEnd);
  }

  List<File> get getAllFiles => List.unmodifiable(_imagesFile);
  Map<File, AssetEntityImageProvider> get getMapFiles =>
      Map.unmodifiable(_filesMap);
}

class _PermissionHelper {
  _PermissionHelper._internal();
  static Future<bool> requestPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    if (status.isDenied) {
      status = await permission.request();
    }
    return status.isGranted;
  }
}
