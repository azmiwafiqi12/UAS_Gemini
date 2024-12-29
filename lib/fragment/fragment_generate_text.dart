import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../utils/global_variable.dart';

class FragmentGenerateText extends StatefulWidget {
  const FragmentGenerateText({super.key});

  @override
  State<FragmentGenerateText> createState() => _FragmentGenerateTextState();
}

class _FragmentGenerateTextState extends State<FragmentGenerateText> {
  TextEditingController textEditingController = TextEditingController();
  List<Map<String, String>> messages = []; // List untuk menyimpan pesan
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Bagian daftar pesan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color.fromARGB(255, 1, 141, 255)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft:
                            isUser ? const Radius.circular(15) : Radius.zero,
                        bottomRight:
                            isUser ? Radius.zero : const Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input field
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
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
                    icon: isSending
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: isSending
                        ? null
                        : () {
                            if (textEditingController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Pesan tidak boleh kosong!'),
                                backgroundColor: Colors.red,
                              ));
                              return;
                            }
                            _sendMessage(textEditingController.text);
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    setState(() {
      messages.add({'sender': 'user', 'text': text});
      isSending = true;
    });
    textEditingController.clear();

    GenerativeModel model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: API_KEY,
    );

    model.generateContent([
      Content.text(text),
    ]).then((value) {
      setState(() {
        messages.add({'sender': 'bot', 'text': value.text.toString()});
        isSending = false;
      });
    }).catchError((error) {
      setState(() {
        messages.add({'sender': 'bot', 'text': 'Terjadi kesalahan: $error'});
        isSending = false;
      });
    });
  }
}
