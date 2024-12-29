import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/global_variable.dart';

class FragmentGenerateImage extends StatefulWidget {
  const FragmentGenerateImage({super.key});

  @override
  State<FragmentGenerateImage> createState() => _FragmentGenerateImageState();
}

class _FragmentGenerateImageState extends State<FragmentGenerateImage> {
  TextEditingController textEditingController = TextEditingController();
  String strAnswer = '';
  File? imageFile;
  final imagePicker = ImagePicker();
  List<Map<String, dynamic>> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['isUser']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message['isUser']
                          ? const Color.fromARGB(255, 198, 247, 248)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: message['isUser']
                            ? const Radius.circular(12)
                            : Radius.zero,
                        bottomRight: message['isUser']
                            ? Radius.zero
                            : const Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message['image'] != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Image.file(
                              File(message['image']),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Text(
                          message['text'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image,
                      color: const Color.fromARGB(255, 1, 141, 255)),
                  onPressed: () => _selectImageSource(context),
                ),
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Ketik Pesan...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 1, 141, 255),
                      ),
                      color: const Color.fromARGB(255, 1, 141, 255)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: _sendMessage,
                  ),
                )
                // IconButton(

                //   icon: const Icon(Icons.send,
                //       color: const Color.fromARGB(255, 1, 141, 255)),
                //   onPressed: _sendMessage,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = textEditingController.text;
    if (text.isNotEmpty || imageFile != null) {
      setState(() {
        messages.insert(0, {
          'text': text,
          'image': imageFile?.path,
          'isUser': true,
        });
      });
      textEditingController.clear();
      imageFile = null;

      // Simulate bot response
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          messages.insert(0, {
            'text': 'This is a generated response for "$text".',
            'image': null,
            'isUser': false,
          });
        });
      });
    }
  }

  void _selectImageSource(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo,
                  color: const Color.fromARGB(255, 1, 141, 255),
                ),
                title: const Text('Cari di Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt,
                    color: const Color.fromARGB(255, 1, 141, 255)),
                title: const Text('Ambil Gambar'),
                onTap: () {
                  Navigator.pop(context);
                  _getFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
