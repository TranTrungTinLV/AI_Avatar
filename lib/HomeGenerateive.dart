import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:generative_img_ai/api/description.dart';
import 'package:generative_img_ai/api/get_img.dart';
import 'package:generative_img_ai/utils/cropper_img.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomeGenerateive extends StatefulWidget {
  HomeGenerateive({super.key});

  @override
  State<HomeGenerateive> createState() => _HomeGenerateiveState();
}

class _HomeGenerateiveState extends State<HomeGenerateive> {
  Uint8List? _image;
  File? selectedImage;
  late FaceDetector faceDetector;
  // List<String> descriptions = [];
  TextEditingController promptController = TextEditingController();
  ImageCropperService _imgCropperService = ImageCropperService();
  bool noFaceDetected = false;
  Future _pickImageFromGallery() async {
    // final returnImg =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);
    final XFile? croppedFile = await _imgCropperService.pickCropImage(
        cropAspectRatio: CropAspectRatio(ratioX: 3.0, ratioY: 2.0),
        imageSource: ImageSource.gallery);
    if (croppedFile == null) return;
    setState(() {
      selectedImage = File(croppedFile.path);
      _image = File(croppedFile.path).readAsBytesSync();
      deFaceDetection();
    });
    Navigator.of(context).pop();
  }

  Future _pickImageFromCamera() async {
    final XFile? returnImg = await _imgCropperService.pickCropImage(
        cropAspectRatio: CropAspectRatio(ratioX: 3.0, ratioY: 2.0),
        imageSource: ImageSource.camera);
    if (returnImg == null) return;
    setState(() {
      selectedImage = File(returnImg.path);
      _image = File(returnImg.path).readAsBytesSync();
      deFaceDetection();
    });
    Navigator.of(context).pop();
  }

  deFaceDetection() async {
    if (selectedImage == null) return;

    InputImage inputImage = InputImage.fromFile(selectedImage!);
    final List<Face> faces = await faceDetector.processImage(inputImage);
    setState(() {
      noFaceDetected = faces.isEmpty;
    });

    if (noFaceDetected) {
      print("No faces detected");
    }
    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      print("Rect = ${boundingBox.toString()}");
    }
  }

  void getData() async {
    try {
      var data = await ApiData().getData();
      setState(() {
        // descriptions = data;
        promptController.text = data;
        // print(descriptions);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final options =
        FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);
  }

  void showImagePickerOption() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Color(0xff040F24),
        // elevation: 0,
        barrierColor: Colors.transparent,
        builder: (builder) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickImageFromGallery,
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                            size: 70,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Thư viện ảnh",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: _pickImageFromCamera,
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera,
                            size: 70,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Chụp Ảnh",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          noFaceDetected
              ? Container(
                  height: 250.0,
                  decoration: BoxDecoration(
                    color: Color(0xff06255B),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: showImagePickerOption,
                          child: Icon(Icons.add, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20),
                            backgroundColor:
                                Color(0xff001C53), // <-- Button color
                          ),
                        ),
                      ),
                      Container(
                          width: 200,
                          //   child: Column(
                          // // mainAxisAlignment: MainAxisAlignment.start,
                          // children: [
                          child: Text(
                            "Không tìm Thấy Khuôn mặt của bạn",

                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 19, color: Colors.red),
                            //   ),
                            // ],
                          )),
                    ],
                  ),
                )
              : _image != null
                  ? Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.greenAccent,
                        image: DecorationImage(
                            image: MemoryImage(_image!), fit: BoxFit.cover),
                      ))
                  : Container(
                      height: 250.0,
                      decoration: BoxDecoration(
                        color: Color(0xff06255B),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              onPressed: showImagePickerOption,
                              child: Icon(Icons.add, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(20),
                                backgroundColor:
                                    Color(0xff001C53), // <-- Button color
                              ),
                            ),
                          ),
                          Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Chọn ảnh từ thư viện ",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 19, color: Colors.white),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: 300,
            // color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    "Prompt",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // color: Color(0xff0B234D),
                // elevation: 0.0,
                // margin: EdgeInsets.only(bottom: 3),
                TextField(
                  controller: promptController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xff09275E),
                      hintText: 'Enter your idea',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: GradientOutlineInputBorder(
                          gradient: LinearGradient(colors: [
                        Color(0xffDC52D1),
                        Color(0xffAD67DE),
                        Color(0xff018BE4),
                        Color(0xff00786C),
                        Color(0xff009D7D),
                        Color(0xff8DD673)
                      ]))),
                  // scrollPadding: EdgeInsets.only(top: 30, right: 30),
                  style: TextStyle(color: Colors.white),
                ),

                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // SizedBox(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff0B234D)),
                        onPressed: () {
                          setState(() {
                            getData();
                          });
                        },
                        child: Container(
                          width: 70,
                          height: 35,
                          child: Center(
                            child: Text(
                              "Random Text",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ))
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                ),
                ElevatedButton(
                    onPressed: () async {
                      String prompt = promptController.text;
                      await ApiImageData().postImgData(selectedImage, prompt);
                    },
                    style: ElevatedButton.styleFrom(
                        // foregroundColor: Color(0xff5865F1),
                        overlayColor: Color(0xff5865F1),
                        backgroundColor: Color(0xff0E306E)),
                    child: Container(
                      width: 300,
                      child: Center(
                          child: Text(
                        "Tạo",
                        style:
                            TextStyle(fontSize: 18.0, color: Color(0xffffffff)),
                      )),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
