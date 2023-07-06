import 'dart:convert';

import 'package:chatgpt/model/ResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController promptController;
  String responseTxt = '';
  late ResponseModel _responseModel;

  @override
  void initState() {
    promptController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343541),
      appBar: AppBar(
        title: Text(
          'Flutter and ChatGPT',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff343541),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PromptBldr(responseTxt: responseTxt),
          TextFormFieldBldr(
              promptController: promptController, btnFun: completeFunc),
        ],
      ),
    );
  }

  completeFunc() async {
    setState(() => responseTxt = 'Loading...');

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['token']}',
      },
      body: jsonEncode(
        {
          "model": "text-davinci-003",
          "prompt": promptController.text,
          "max_tokens": 250,
          "temperature": 0,
          "top_p": 1,
        },
      ),
    );
    setState(() {
      Map<String, dynamic> jsonMap = json.decode(response.body);
      _responseModel = ResponseModel.fromJson(jsonMap);
      responseTxt = _responseModel.choices[0].text;
      print(responseTxt);
    });
  }
}

class PromptBldr extends StatelessWidget {
  const PromptBldr({super.key, required this.responseTxt});

  final String responseTxt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.35,
      color: const Color(0xff434654),
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Text(
          responseTxt,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}

class TextFormFieldBldr extends StatelessWidget {
  const TextFormFieldBldr(
      {super.key, required this.promptController, required this.btnFun});

  final TextEditingController promptController;
  final Function btnFun;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 50),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                cursorColor: Colors.white,
                controller: promptController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff444653),
                    ),
                    borderRadius: BorderRadius.circular(5.5),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff444653),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xff444653),
                  hintText: 'Ask me anything',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Container(
              color: const Color(0xff19bc99),
              padding: EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: () => btnFun(),
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
