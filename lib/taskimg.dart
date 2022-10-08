import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class Taskimg extends StatefulWidget {
  String img;
   Taskimg({Key? key,required this.img}) : super(key: key);

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
    return Positioned.fill(
        child: PhotoView(
        imageProvider: NetworkImage(widget.img),
    scaleStateController: scaleStateController,
    ));
  }
}
