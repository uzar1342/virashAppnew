import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class Taskimg extends StatefulWidget {
  const Taskimg({Key? key}) : super(key: key);

  @override
  State<Taskimg> createState() => _TaskimgState();
}

class _TaskimgState extends State<Taskimg> {
  PhotoViewScaleStateController? scaleStateController;
  @override
  void dispose() {

    super.dispose();
    scaleStateController?.dispose();
  }
  @override
  void initState() {
    super.initState();
    scaleStateController?.scaleState = PhotoViewScaleState.originalSize;
  }
  @override
  Widget build(BuildContext context) {
    return PhotoView(
                                imageProvider: NetworkImage("http://training.virash.in/media/in_image/id_1665118356.png"),
                                scaleStateController: scaleStateController,
                              );
  }
}
