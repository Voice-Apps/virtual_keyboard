part of virtual_keyboard;

const int _KEY_CENTER = 23;
const int _KEY_HAMBURGER = 82;
const int _KEY_FAST_FORWARD = 90;
const int _KEY_REWIND = 89;
const int _KEY_PLAY_PAUSE = 85;

/// The default keyboard height. Can we overriden by passing
///  `height` argument to `VirtualKeyboard` widget.
const double _virtualKeyboardDefaultHeight = 300;
const double _virtualKeyboardDefaultWidth = 300;

const int _virtualKeyboardBackspaceEventPerioud = 250;

/// Virtual Keyboard widget.
class VirtualKeyboard extends StatefulWidget {
  /// Keyboard Type: Should be inited in creation time.
  final VirtualKeyboardType type;

  /// Callback for Key press event. Called with pressed `Key` object.
  final Function onKeyPress;
  final Function onDone;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Virtual keyboard width. Default is 300
  final double width;

  /// Color for key texts and icons.
  final Color textColor;

  /// Font size for keyboard keys.
  final double fontSize;

  /// The builder function will be called for each Key object.
  final Widget Function(BuildContext context, VirtualKeyboardKey key) builder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  /// Virtual keyboard title.
  final String title;

  /// Virtual keyboard starting value
  final String text;

  /// Virtual keyboard hint text
  final String hintText;

  VirtualKeyboard(
      {Key key,
      @required this.type,
      @required this.onKeyPress,
      @required this.onDone,
      this.builder,
      this.height = _virtualKeyboardDefaultHeight,
      this.width = _virtualKeyboardDefaultWidth,
      this.textColor = Colors.black,
      this.fontSize = 14,
      this.alwaysCaps = false,
      this.title = 'Enter Text',
      this.text = '',
      this.hintText = ''})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VirtualKeyboardState();
  }
}

/// Holds the state for Virtual Keyboard class.
class _VirtualKeyboardState extends State<VirtualKeyboard> {
  VirtualKeyboardType type;
  // The builder function will be called for each Key object.
  Widget Function(BuildContext context, VirtualKeyboardKey key) builder;
  double height;
  double width;
  Color textColor;
  double fontSize;
  bool alwaysCaps;
  String title;
  String text;
  String hintText;

  // Text Style for keys.
  TextStyle textStyle;

  // True if shift is enabled.
  bool isShiftEnabled = false;

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      type = widget.type;
      height = widget.height;
      width = widget.width;
      textColor = widget.textColor;
      fontSize = widget.fontSize;
      alwaysCaps = widget.alwaysCaps;
      title = widget.title;
      text = widget.text;
      hintText = widget.hintText;

      // Init the Text Style for keys.
      textStyle = TextStyle(
        fontSize: fontSize,
        color: textColor,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    type = widget.type;
    height = widget.height;
    width = widget.width;
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    alwaysCaps = widget.alwaysCaps;
    title = widget.title;
    text = widget.text;
    hintText = widget.hintText;

    // Init the Text Style for keys.
    textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
  }

  void onKeyPress(VirtualKeyboardKey key) {
    print('key pressed: $key');

    if (key.action == VirtualKeyboardKeyAction.Shift) {
      this.setState(() {
        alwaysCaps = !alwaysCaps;
      });
    } else if (key.action == VirtualKeyboardKeyAction.Backspace) {
      if (this.text.length > 0) {
        this.setState(() {
          this.text = this.text.substring(0, this.text.length - 1);
        });
      }
    } else if (key.action == VirtualKeyboardKeyAction.Space) {
      this.setState(() {
        this.text += ' ';
      });
    } else if (key.action == VirtualKeyboardKeyAction.Done) {
      if (widget.onDone != null) {
        widget.onDone(this.text);
      }
    } else {
      this.setState(() {
        this.text += alwaysCaps ? key.capsText : key.text;
      });
    }

    if (widget.onKeyPress != null) {
      widget.onKeyPress(key);
    }
  }

  void onKeyPressInt(int keyCode) {
    if (keyCode == _KEY_HAMBURGER) {
      this.setState(() {
        alwaysCaps = !alwaysCaps;
      });
    } else if (keyCode == _KEY_REWIND) {
      if (this.text.length > 0) {
        this.setState(() {
          this.text = this.text.substring(0, this.text.length - 1);
        });
      }
    } else if (keyCode == _KEY_FAST_FORWARD) {
      this.setState(() {
        this.text += ' ';
      });
    } else if (keyCode == _KEY_PLAY_PAUSE) {
      if (widget.onDone != null) {
        widget.onDone(this.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[700].withOpacity(.9),
            width: 1,
          ),
          color: Colors.grey[900],
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4, right: 4, bottom: 5),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.white,
                  ),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Stack(
                      children: <Widget>[
                        text == ''
                            ? Text(hintText,
                                style: TextStyle(color: Colors.grey[600]))
                            : Text(''),
                        BlinkWidget(
                          children: <Widget>[
                            Container(
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: Colors.white, width: 1)),
                              ),
                            ),
                            Container(
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: Colors.transparent, width: 1)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            type == VirtualKeyboardType.Numeric ? _numeric() : _alphanumeric(),
          ],
        ),
      ),
    );
  }

  Widget _alphanumeric() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  Widget _numeric() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  /// Returns the rows for keyboard.
  List<Widget> _rows() {
    // Get the keyboard Rows
    List<List<VirtualKeyboardKey>> keyboardRows =
        type == VirtualKeyboardType.Numeric
            ? _getKeyboardRowsNumeric()
            : _getKeyboardRows();

    // Generate keyboard row.
    List<Widget> rows = List.generate(keyboardRows.length, (int rowNum) {
      return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          // Generate keboard keys
          children: List.generate(
            keyboardRows[rowNum].length,
            (int keyNum) {
              // Get the VirtualKeyboardKey object.
              VirtualKeyboardKey virtualKeyboardKey =
                  keyboardRows[rowNum][keyNum];

              Widget keyWidget;

              // Check if builder is specified.
              // Call builder function if specified or use default
              //  Key widgets if not.
              if (builder == null) {
                // Check the key type.
                switch (virtualKeyboardKey.keyType) {
                  case VirtualKeyboardKeyType.String:
                    // Draw String key.
                    keyWidget = _KeyboardDefaultKey(virtualKeyboardKey,
                        onKeyPress, onKeyPressInt, alwaysCaps);
                    break;
                  case VirtualKeyboardKeyType.Action:
                    // Draw action key.
                    keyWidget = _KeyboardDefaultActionKey(
                        virtualKeyboardKey, onKeyPress, onKeyPressInt);
                    break;
                }
              } else {
                // Call the builder function, so the user can specify custom UI for keys.
                keyWidget = builder(context, virtualKeyboardKey);

                if (keyWidget == null) {
                  throw 'builder function must return Widget';
                }
              }

              return keyWidget;
            },
          ),
        ),
      );
    });

    return rows;
  }
}

/// Creates default UI element for keyboard Key.
class _KeyboardDefaultKey extends StatefulWidget {
  final VirtualKeyboardKey currentKey;
  final onKeyPress;
  final onKeyPressInt;
  final bool isUppercase;

  _KeyboardDefaultKey(
      this.currentKey, this.onKeyPress, this.onKeyPressInt, this.isUppercase);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardDefaultKeyState();
  }
}

class _KeyboardDefaultKeyState extends State<_KeyboardDefaultKey> {
  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Focus(
      onFocusChange: (hasFocus) {
        // if (hasFocus) {
        //   print('got focus: ${widget.currentKey.text}');
        // } else {
        //   print('lost focus: ${widget.currentKey.text}');
        // }
        this.setState(() {
          isSelected = hasFocus;
        });
      },
      onKey: (fn, event) {
        //focusNode = fn;
        //print('move made');
        if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
          RawKeyDownEvent rawKeyDownEvent = event;
          RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data;
          var key = rawKeyEventDataAndroid.keyCode;
          print(key.toString());
          if (key == _KEY_CENTER) {
            widget.onKeyPress(widget.currentKey);
            return true;
          } else if (key == _KEY_HAMBURGER ||
              key == _KEY_FAST_FORWARD ||
              key == _KEY_REWIND ||
              key == _KEY_PLAY_PAUSE) {
            widget.onKeyPressInt(key);
            return true;
          }
        }
        return false;
      },
      child: Container(
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Color.fromRGBO(50, 50, 50, 1.0),
          borderRadius: BorderRadius.circular(1),
        ),
        height: 40,
        child: Center(
          child: Text(
            widget.isUppercase
                ? widget.currentKey.capsText
                : widget.currentKey.text,

            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
            ),
            // alwaysCaps
            //     ? widget.key.capsText
            //     : (isShiftEnabled ? widget.key.capsText : widget.key.text),
            // style: widget.textStyle,
          ),
        ),
      ),
    ));
  }
}

/// Creates default UI element for keyboard Key.
class _KeyboardDefaultActionKey extends StatefulWidget {
  final VirtualKeyboardKey currentKey;
  final onKeyPress;
  final onKeyPressInt;

  _KeyboardDefaultActionKey(
      this.currentKey, this.onKeyPress, this.onKeyPressInt);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardDefaultActionKeyState();
  }
}

/// Creates default UI element for keyboard Action Key.
class _KeyboardDefaultActionKeyState extends State<_KeyboardDefaultActionKey> {
  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    // Holds the action key widget.
    Widget actionKey;

    // Switch the action type to build action Key widget.
    switch (widget.currentKey.action) {
      case VirtualKeyboardKeyAction.Backspace:
        actionKey = Container(
          margin: EdgeInsets.all(3),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Color.fromRGBO(50, 50, 50, 1.0),
          ),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 20,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.white,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fast_rewind,
                    size: 14,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
                Text(" Delete",
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                    ))
              ],
            ),
          ),
        );
        break;
      case VirtualKeyboardKeyAction.Shift:
        actionKey = Container(
          margin: EdgeInsets.all(3),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
              color:
                  isSelected ? Colors.white : Color.fromRGBO(50, 50, 50, 1.0)),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 20,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.white,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu,
                    size: 14,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
                Text(" aA",
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                    ))
              ],
            ),
          ),
        );
        break;
      case VirtualKeyboardKeyAction.Space:
        actionKey = Container(
          margin: EdgeInsets.all(3),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
              color:
                  isSelected ? Colors.white : Color.fromRGBO(50, 50, 50, 1.0)),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 20,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.white,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fast_forward,
                    size: 14,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
                Text(" Space",
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                    ))
              ],
            ),
          ),
        );
        break;
      case VirtualKeyboardKeyAction.Return:
        actionKey = Container(
            margin: EdgeInsets.all(3),
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Color.fromRGBO(50, 50, 50, 1.0)),
            child: Icon(
              Icons.keyboard_return,
              color: isSelected ? Colors.black : Colors.white,
            ));
        break;
      case VirtualKeyboardKeyAction.Done:
        actionKey = Container(
          margin: EdgeInsets.all(3),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
              color:
                  isSelected ? Colors.white : Color.fromRGBO(50, 50, 50, 1.0)),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 20,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.white,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 14,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
                Text(" Done",
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                    ))
              ],
            ),
          ),
        );
        break;
    }

    return Expanded(
      child: Focus(
        onFocusChange: (hasFocus) {
          // if (hasFocus) {
          //   print('got focus: ${widget.currentKey.text}');
          // } else {
          //   print('lost focus: ${widget.currentKey.text}');
          // }
          this.setState(() {
            isSelected = hasFocus;
          });
        },
        onKey: (fn, event) {
          //focusNode = fn;
          //print('move made');
          if (event is RawKeyDownEvent &&
              event.data is RawKeyEventDataAndroid) {
            RawKeyDownEvent rawKeyDownEvent = event;
            RawKeyEventDataAndroid rawKeyEventDataAndroid =
                rawKeyDownEvent.data;

            var key = rawKeyEventDataAndroid.keyCode;
            print(key.toString());
            if (key == _KEY_CENTER) {
              widget.onKeyPress(widget.currentKey);
              return true;
            } else if (key == _KEY_HAMBURGER ||
                key == _KEY_FAST_FORWARD ||
                key == _KEY_REWIND ||
                key == _KEY_PLAY_PAUSE) {
              widget.onKeyPressInt(key);
              return true;
            }
          }
          return false;
        },
        child: Container(
          alignment: Alignment.center,
          //height: height / _keyRows.length,
          child: actionKey,
        ),
      ),
    );
  }
}
