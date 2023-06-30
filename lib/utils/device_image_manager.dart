import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import "dart:developer" as dev;

class DeviceImageService {
  bool isOver = false;
  bool isGetting = false;
  bool isGranted = false;
  late List<AssetPathEntity> _pathEntities;
  final List<File> _imagesFile = [];
  List<File> _lastestFiles = [];
  final int numberAssetPerPage = 10;

  Future<void> init() async {
    isGranted = await PermissionHelper.requestPermission(Permission.photos);
    if (isGranted) {
      _pathEntities = await PhotoManager.getAssetPathList(type: RequestType.image);
    }
  }

  Future<dynamic> getNextImagePage() async {
    if (isGetting || isOver) {
      return;
    }
    isGetting = true;
    List<AssetEntity> newAssetEntities = await _pathEntities[0].getAssetListRange(
      start: _imagesFile.length,
      end: _imagesFile.length + numberAssetPerPage,
    );
    dev.log("Get more ${newAssetEntities.length} assets entities");

    isGetting = false;
    if (newAssetEntities.length < numberAssetPerPage - 1) {
      isOver = true;
    }
    _lastestFiles = [];
    for (AssetEntity assetEntity in newAssetEntities) {
      File? file = await assetEntity.file;
      if (file != null) {
        _imagesFile.add(file);
        _lastestFiles.add(file);
      }
    }
    return;
  }

  void releaseMemory() {
    isOver = false;
    _pathEntities.clear();
    PhotoManager.releaseCache();
  }

  List<File> getImageFiles(int indexStart, int indexEnd) {
    return _imagesFile.sublist(indexStart, indexEnd);
  }

  List<File> get getLastestPageFiles => _imagesFile;
}

class PermissionHelper {
  PermissionHelper._internal();
  static final PermissionHelper _instance = PermissionHelper._internal();
  static PermissionHelper get instance => _instance;
  static Future<bool> requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status == PermissionStatus.denied) {
      status = await permission.request();
    }
    return status.isGranted;
  }
}
