import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ProfilePage extends StatefulWidget {

  final double sizes;
  final Function(File?) setImage;
  const ProfilePage({Key? key, required this.sizes,required this.setImage}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _imageBytes;

  Future<void> getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        File file = File(result.files.single.path!);
        _imageBytes = file.readAsBytesSync();
        widget.setImage(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: getImage,
        child: Container(
          width: widget.sizes,
          height: widget.sizes,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: _imageBytes == null ?
          Icon(
            Icons.account_circle,
            size: widget.sizes,
            color: Colors.grey[600],
          )
          : ClipOval(
            child: Image.memory(
              _imageBytes!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
