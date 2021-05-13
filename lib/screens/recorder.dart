import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/auth.dart';

import 'package:pocket/models/http_exception.dart';
import 'package:pocket/style/colors.dart';

class VideoRecorder extends StatefulWidget {
  
  @override
  _VideoRecorderState createState() => new _VideoRecorderState ();

}

class _VideoRecorderState extends State <VideoRecorder> {

  CameraController controller;
  String videoPath;
  List<String> photos;

  List <CameraDescription> cameras;
  int selectedCameraIdx;

  final GlobalKey <ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();

  bool _recording = false;
  bool _waiting = false;
  int _duration = 3;

  int _start;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    // Get the listonNewCameraSelected of available cameras.
    // Then set the first camera as selected.
    availableCameras()
        .then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 1;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    })
        .catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future <bool> _onWillPop() async {
    if (this._waiting || this._recording) return new Future.value(false);
    return new Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return new WillPopScope(
      onWillPop: this._onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: mainBlue,
          title: Provider.of<Auth>(context, listen: false).isRegister ? const Text('Face ID Register') : const Text('Face ID Auth'),
        ),
        body: this._waiting ? 
          Container (
            child: Center (
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(mainBlue),
                  ),

                  new SizedBox(height: 20),

                  new Text('Processing...', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          )

          :

          Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Center(
                          child: _cameraPreviewWidget(),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: controller != null && controller.value.isRecordingVideo
                              ? Colors.redAccent
                              : Colors.grey,
                          width: 3.0,
                        ),
                      ),
                    ),

                    this._recording ? Center(
                      child: new Text('${this._start}', style: TextStyle(color: Colors.white, fontSize: 48)),
                    ) : Container ()
                  ],
                )
              ),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _cameraTogglesRowWidget(),
                    _captureControlRowWidget(),
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    // return AspectRatio(
    //   aspectRatio: controller.value.aspectRatio,
    //   child: CameraPreview(controller),
    // );

    return RotatedBox(
      quarterTurns: 1,
      child: Transform.scale(
        scale: controller.value.aspectRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras == null) {
      return Row();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: this._recording ? null : _onSwitchCamera,
            icon: Icon(
              _getCameraLensIcon(lensDirection)
            ),
            label: Text("${lensDirection.toString()
                .substring(lensDirection.toString().indexOf('.')+1)}")
        ),
      ),
    );
  }

  /// Display the control bar with buttons to record videos.
  Widget _captureControlRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.videocam),
              color: mainBlue,
              onPressed: controller != null && controller.value.isInitialized && !controller.value.isRecordingVideo && !this._recording
                ? _onRecordButtonPressed
                : null,
            ),
            // IconButton(
            //   icon: const Icon(Icons.stop),
            //   color: Colors.red,
            //   onPressed: controller != null &&
            //     controller.value.isInitialized &&
            //     controller.value.isRecordingVideo
            //     ? _onStopButtonPressed
            //     : null,
            // )
          ],
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
          msg: 'Camera error ${controller.value.errorDescription}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white
        );
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx < cameras.length - 1
        ? selectedCameraIdx + 1
        : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onRecordButtonPressed() {
    this._startPhotosTaking().then((_) {
      // for (var p in this.photos) {
      //   print(p);
      // }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Error', 
          style: const TextStyle(color: mainRed, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text (
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            )
          ],
        )
      )
    );
  }

  Future <void> _faceIDRegister() async {

    try {
      this.setState(() {
        this._waiting = true;
      });

      await Provider.of<Auth>(context, listen: false).face_id_register(
        this.photos
      );

      // Navigator.of(context).pop();
    } on HttpException catch (error) {
      print(error);
      // var jsonError = json.decode(error.toString());

      _showErrorDialog('Failed to register the new face!');
    }

    finally {
      this.setState(() {
        this._waiting = false;
      });
    }

  }

  Future <void> _faceIDAuth() async {
    var auth = Provider.of<Auth>(context, listen: false);

    bool failed = false;
    try {
      this.setState(() {
        this._waiting = true;
      });

      await auth.face_id_auth(
        this.photos
      );

    } on HttpException catch (error) {
      print(error);
      // var jsonError = json.decode(error.toString());

      _showErrorDialog('Failed to unlock using Face ID. Faces do not match!');
      failed = true;
    }

    if (!failed) {
      bool done = false;
      try {
        done = true;
        Navigator.of(context).pop();

      } on HttpException catch (error) {
        print(error);
      }

      finally {
        if (!done) {
          this.setState(() {
            this._waiting = false;
          });
        }
      }
    }

    else {
      this.setState(() {
        this._waiting = false;
      });
    }

  }

  void _onStopButtonPressed() {
    setState(() {
      this._recording = false;
    });

    // print(videoPath);
    print("Sending to server...");

    if (Provider.of<Auth>(context, listen: false).isRegister) {
      this._faceIDRegister();
    }

    else this._faceIDAuth();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start <= 0) {
            timer.cancel();
            // this._onStopButtonPressed();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  Future <void> _startPhotosTaking() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(msg: 'Please wait',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey,
        textColor: Colors.white
      );
      return null;
    }

    // List<String> photos = new List();
    this.photos = new List ();

    final Directory appDirectory = await getTemporaryDirectory();
    final String photosDirectory = '${appDirectory.path}/Photos';
    await Directory (photosDirectory).create (recursive: true);

    this._start = this._duration;
    this.startTimer ();

    setState(() {
      this._recording = true;
    });

    print("Start recording");
    for (int i = 0; i < 20; i++) {
      // final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      // if(controller.value.isTakingPicture) {
      //   print("UPS");
      //   return null;
      // }
      // final String filePath = '$photosDirectory/$currentTime.jpg';

      try {
        XFile file =  await controller.takePicture();
        photos.add(file.path);
      }
      
      on CameraException catch (e) {
        this.setState(() {
          _recording = false;
        });

        _showCameraException (e);
        return null;
      }

      
      Timer(Duration(milliseconds: 150), () {});
    }

    this._onStopButtonPressed();

    // setState(() {
    //   this.photosPath = photos;
    // });
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    Fluttertoast.showToast(
      msg: 'Error: ${e.code}\n${e.description}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white
    );
  }
}