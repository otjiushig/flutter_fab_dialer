part of fab_dialer;

class FabDialer extends StatefulWidget {
  const FabDialer(this._fabMiniMenuItemList, this._fabColor, this._fabIcon,
      [this._closeFabIcon, this.onLongPress, this._animationDuration, Key key])
      : super(key: key);

  final List<FabMiniMenuItem> _fabMiniMenuItemList;
  final Color _fabColor;
  final Icon _fabIcon;
  final Icon _closeFabIcon;
  final int _animationDuration;
  final VoidCallback onLongPress;


  @override
  FabDialerState createState() => FabDialerState();
}

class FabDialerState extends State<FabDialer> with TickerProviderStateMixin {
  bool _isRotated = false;
  List<FabMenuMiniItemWidget> _fabMenuItems = [];

  AnimationController _controller;

  @override
  void initState() {
    final int animationDuration = widget._animationDuration == null
        ? 180
        : widget._animationDuration;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
    );

    _controller.reverse();

    super.initState();
  }

  void setFabMenu(List<FabMiniMenuItem> fabMenuList) {
    _fabMenuItems.clear();
    for (int i = 0; i < widget._fabMiniMenuItemList.length; i++) {
      _fabMenuItems.add(FabMenuMiniItemWidget(
        tooltip: widget._fabMiniMenuItemList[i].tooltip,
        text: widget._fabMiniMenuItemList[i].text,
        elevation: widget._fabMiniMenuItemList[i].elevation,
        icon: widget._fabMiniMenuItemList[i].icon,
        index: i,
        onPressed: widget._fabMiniMenuItemList[i].onPressed,
        textColor: widget._fabMiniMenuItemList[i].textColor,
        fabColor: widget._fabMiniMenuItemList[i].fabColor,
        chipColor: widget._fabMiniMenuItemList[i].chipColor,
        controller: _controller,
      ));
    }
  }

  void _rotate() {
    if (_isRotated) {
      _isRotated = false;
      _controller.reverse();
    } else {
      _isRotated = true;
      _controller.forward();
    }
  }

  void close() {
    if (_isRotated) {
      _isRotated = false;
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Icon closeIcon = widget._closeFabIcon == null
        ? Icon(Icons.close)
        : widget._closeFabIcon;

    setFabMenu(widget._fabMiniMenuItemList);

    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _fabMenuItems,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext _, Widget child) {
                    return GestureDetector(
                      child: FloatingActionButton(
                          child: Transform(
                            transform: Matrix4.rotationZ(
                                (2 * Math.pi) * _controller.value),
                            alignment: Alignment.center,
                            child: _controller.value >= 0.5
                                ? closeIcon
                                : widget._fabIcon,
                          ),
                          backgroundColor: widget._fabColor,
                          onPressed: _rotate),
                      onLongPress: widget.onLongPress,
                    );
                  },
                )
              ],
            ),
          ],
        ));
  }
}
