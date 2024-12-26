import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _selectedFile;
  String _uploadStatus = '';

  // Function to pick an image file
  Future<void> pickImageFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Restricting to image files only
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      } else {
        // User canceled the picker
        setState(() {
          _uploadStatus = "No image selected";
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = "Error picking file: $e";
      });
    }
  }

  // Function to upload the image file to API
  Future<void> uploadImage(String skillId) async {
    if (_selectedFile == null) {
      setState(() {
        _uploadStatus = "Please select an image first";
      });
      return;
    }

    // Converting the file to base64
    String base64Image = base64Encode(_selectedFile!.readAsBytesSync());

    // Prepare the data to send
    final data = {
      'certificate': base64Image,
      'fileName': _selectedFile!.path.split('/').last, // Extract file name
    };

    final response = await http.post(
      Uri.parse(''), // Your API endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      setState(() {
        _uploadStatus = "Image uploaded successfully";
      });
    } else {
      setState(() {
        _uploadStatus = "Failed to upload image";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickImageFile, // File picker for images
              child: Text('Select Image'),
            ),
            SizedBox(height: 10),
            _selectedFile != null
                ? Text("Selected: ${_selectedFile!.path.split('/').last}")
                : Text("No image selected"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => uploadImage("670fc797246ab228f077a072"), // Pass the skill ID here
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            Text(_uploadStatus),
          ],
        ),
      ),
    );
  }
}
