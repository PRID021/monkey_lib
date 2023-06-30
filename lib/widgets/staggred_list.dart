import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'dart:async';
import 'dart:collection';

mixin StaggeredMethod {
  void onRemove(Widget child);
  void onAdd(Widget child);
  void onUndo(Widget child);
  void onUpdate(Widget oldWidget, Widget newWidget);
}

enum _StaggeredType {
  onAdd,
  onRemove,
  onUndo,
  onUpdate,
}

class Scheduler {
  bool _scheduled = false;

  final Queue<Future Function()> _queue = Queue<Future Function()>();

  void schedule(Future Function() task) {
    _queue.add(task);
    if (!_scheduled) {
      _scheduled = true;
      Timer(const Duration(seconds: 0), _execute);
    }
  }

  Future _execute() async {
    while (true) {
      if (_queue.isEmpty) {
        _scheduled = false;
        return;
      }
      var first = _queue.removeFirst();
      await first();
    }
  }
}

class StaggeredListController extends ChangeNotifier with StaggeredMethod {
  _StaggeredType? eventType;
  Widget? child;
  Widget? updateChild;
  @override
  void onAdd(Widget child) {
    eventType = _StaggeredType.onAdd;
    this.child = child;
    notifyListeners();
  }

  @override
  void onRemove(Widget child) {
    eventType = _StaggeredType.onRemove;
    this.child = child;
    notifyListeners();
  }

  @override
  void onUndo(Widget child) {
    eventType = _StaggeredType.onUndo;
    this.child = child;
    notifyListeners();
  }

  @override
  void onUpdate(Widget oldWidget, Widget newWidget) {
    eventType = _StaggeredType.onUpdate;
    child = oldWidget;
    updateChild = newWidget;
    notifyListeners();
  }
}

class StaggeredList extends StatefulWidget {
  final List<Widget> children;
  final StaggeredListController? controller;
  final PageStorageKey<String>? storageKey;

  const StaggeredList({
    Key? key,
    required this.children,
    this.controller,
    this.storageKey,
  }) : super(key: key);

  @override
  State<StaggeredList> createState() {
    // dev.log("Create ..... _StaggeredListState");
    return _StaggeredListState();
  }
}

class _StaggeredListState extends State<StaggeredList>
    with TickerProviderStateMixin {
  late final StaggeredListController? _staggeredListController;
  late AnimationController _listController;
  final List<AnimationController> _itemControllers = [];
  final List<AnimationController> _itemUpdateControllers = [];
  final List<Interval> _itemSlideInterval = [];
  late List<Widget> _menuTitle;
  int? indexRecentRemove;

  static const _initialDelay = Duration(milliseconds: 100);
  static const _itemSlide = Duration(milliseconds: 300);
  static const _staggered = Duration(milliseconds: 50);
  static const _addRemoveItemDuration = Duration(milliseconds: 300);
  static const _updatedItemDuration = Duration(milliseconds: 500);
  static final Scheduler _scheduler = Scheduler();
  late Duration _animationTotal;
  void _createAnimations() {
    for (int i = 0; i < _menuTitle.length; i++) {
      final startTime = _initialDelay + (_staggered * i);
      final endTime = startTime + _itemSlide;

      _itemSlideInterval.add(
        Interval(startTime.inMilliseconds / _animationTotal.inMilliseconds,
            endTime.inMilliseconds / _animationTotal.inMilliseconds),
      );
      _itemControllers.add(AnimationController(
          vsync: this, duration: _addRemoveItemDuration, value: 1.0));
      _itemUpdateControllers.add(AnimationController(
          vsync: this, duration: _updatedItemDuration, value: 0.0));
    }
  }

  @override
  void initState() {
    super.initState();
    _staggeredListController = widget.controller;
    _staggeredListController?.addListener(() {
      StaggeredListController staggeredListController =
          _staggeredListController!;
      Widget child = staggeredListController.child!;
      Widget? newWidget = staggeredListController.updateChild;
      if (staggeredListController.eventType == _StaggeredType.onAdd) {
        _scheduler.schedule(() async {
          await _onAdd(child);
          return;
        });
      }
      if (staggeredListController.eventType == _StaggeredType.onRemove) {
        _scheduler.schedule(() async {
          await _onRemove.call(child);
          return;
        });
      }
      if (staggeredListController.eventType == _StaggeredType.onUndo) {
        _scheduler.schedule(() async {
          await _onUndo.call(child);
          return;
        });
      }
      if (staggeredListController.eventType == _StaggeredType.onUpdate) {
        assert(newWidget != null);
        _scheduler.schedule(() async {
          await _onUpdate.call(child, newWidget!);
          return;
        });
      }
    });
    _menuTitle = widget.children;

    _animationTotal =
        _initialDelay + _itemSlide + _staggered * _menuTitle.length;
    _createAnimations();
    _listController =
        AnimationController(vsync: this, duration: _animationTotal)..forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    _itemControllers.clear();
    for (var controller in _itemUpdateControllers) {
      controller.dispose();
    }
    _itemUpdateControllers.clear();
    super.dispose();
  }

  Widget _buildMenuTitle(Widget rWidget, AnimationController iAnimation,
      AnimationController uAnimation, Interval iInterval,
      {Widget? nWidget}) {
    Interval iUAnimation = const Interval(0.0, 0.8, curve: Curves.elasticInOut);
    Interval oUAnimation = const Interval(0.2, 1, curve: Curves.easeOut);
    return AnimatedBuilder(
      animation: uAnimation,
      builder: (BuildContext context, Widget? child) {
        final percentAnimation = CurvedAnimation(
          parent: uAnimation,
          curve: iUAnimation,
          reverseCurve: oUAnimation,
        ).drive(Tween<double>(begin: 1.0, end: 0.0));

        return Transform.scale(
          scale: percentAnimation.value,
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: iAnimation,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: CurvedAnimation(
                parent: iAnimation, curve: const Interval(0.5, 1.0)),
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                  parent: iAnimation, curve: const Interval(0.0, 1.0)),
              axisAlignment: 0.0,
              child: AnimatedBuilder(
                animation: _listController,
                builder: (context, child) {
                  final animationPercent = Curves.easeOut.transform(
                      ((iInterval.transform(_listController.value))
                          .clamp(0.0, 1.0)));
                  final _opacity = Tween<double>(begin: 0.0, end: 1.0)
                      .transform(animationPercent);
                  final _slideDistance = (1.0 - animationPercent) *
                      MediaQuery.of(context).size.width;
                  return Opacity(
                    opacity: _opacity,
                    child: Transform.translate(
                      offset: Offset(_slideDistance, 0),
                      child: child,
                    ),
                  );
                },
                child: child,
              ),
            ),
          );
        },
        child: rWidget,
      ),
    );
  }

  List<Widget> _buildMenu() {
    List<Widget> menu = [];
    for (int i = 0; i < _menuTitle.length; i++) {
      menu.add(
        _buildMenuTitle(
          _menuTitle[i],
          _itemControllers[i],
          _itemUpdateControllers[i],
          _itemSlideInterval[i],
        ),
      );
    }
    return menu;
  }

  @override
  Widget build(BuildContext context) {
    dev.log("has been running...");
    return SingleChildScrollView(
      key: widget.storageKey,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildMenu(),
      ),
    );
  }

  Future _onUpdate(Widget oldWidget, Widget newWidget) async {
    if (!mounted) return;
    setState(() {
      int updateControllerIndex = _menuTitle.indexOf(oldWidget);
      if (updateControllerIndex < 0) return;

      _itemUpdateControllers[updateControllerIndex].forward().then((value) {
        setState(() {
          _menuTitle[updateControllerIndex] = newWidget;
        });
        _itemUpdateControllers[updateControllerIndex].reverse();
      });
    });
  }

  Future _onRemove(Widget child) async {
    if (!mounted) return;
    int controlIndex = _menuTitle.indexOf(child);
    if (controlIndex < 0) return;
    await _itemControllers[controlIndex].reverse();
    // setState(() {
    indexRecentRemove = controlIndex;
    _menuTitle.remove(child);
    _itemControllers[controlIndex].dispose();
    _itemUpdateControllers[controlIndex].dispose();
    _itemUpdateControllers.removeAt(controlIndex);
    _itemControllers.removeAt(controlIndex);
    // });
  }

  Future _onAdd(Widget child) async {
    if (!mounted) return;
    setState(
      () {
        _menuTitle.add(child);
        final startTime = _initialDelay + (_staggered * _menuTitle.length);
        final endTime = startTime + _itemSlide;
        _itemSlideInterval.add(
          Interval(startTime.inMilliseconds / _animationTotal.inMilliseconds,
              endTime.inMilliseconds / _animationTotal.inMilliseconds),
        );
        AnimationController itemAnimateController = AnimationController(
            vsync: this, duration: _addRemoveItemDuration, value: 0.0);
        _itemControllers.add(itemAnimateController);
        _itemUpdateControllers.add(AnimationController(
            vsync: this, duration: _updatedItemDuration, value: 0.0));

        itemAnimateController.forward();
      },
    );
  }

  Future _onUndo(Widget child) async {
    if (!mounted) return;
    if (indexRecentRemove != null) {
      int _indexRecentRemove = indexRecentRemove!;
      AnimationController itemAnimateController = AnimationController(
          vsync: this, duration: _addRemoveItemDuration, value: 0);
      if (_menuTitle.isNotEmpty) {
        _menuTitle.insert(_indexRecentRemove, child);

        _itemControllers.insert(_indexRecentRemove, itemAnimateController);
      } else {
        _menuTitle.add(child);
        _itemControllers.add(itemAnimateController);
      }
      indexRecentRemove = null;

      final startTime = _initialDelay + (_staggered * _menuTitle.length);
      final endTime = startTime + _itemSlide;
      _itemSlideInterval.add(
        Interval(startTime.inMilliseconds / _animationTotal.inMilliseconds,
            endTime.inMilliseconds / _animationTotal.inMilliseconds),
      );

      itemAnimateController.forward();
    }
  }
}
