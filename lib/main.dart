import 'package:argon2_hash_test/global_helper.dart';
import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Argon2 Hasher Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var txtRaw = TextEditingController();
  var hashedString = '';
  var storedHash = '';
  var storedEncodedString = '';
  var salt = Salt.newSalt();

  Future<DArgon2Result> _getHashResult() async {
    return await argon2.hashPasswordString(
      txtRaw.text,
      salt: salt,
      version: Argon2Version.V13,
      iterations: 3,
      memory: 4096,
      parallelism: 1,
      length: 66,
      type: Argon2Type.id,
    );
    // return await Fargon2(mode: Fargon2Mode.argon2id).hash(salt: salt, memoryKibibytes: 4096, iterations: 3, parallelism: 1);
  }

  Future<bool> _sameWithStoredHash() async {
    var res;
    try {
      res = await argon2.verifyHashString(
        txtRaw.text,
        storedEncodedString,
        type: Argon2Type.id,
      );
    } catch (e) {
      res = false;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: txtRaw,
              decoration: const InputDecoration(
                label: Text('Raw Text'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _getHashResult().then((value) {
                    storedHash = value.base64String;
                    storedEncodedString = value.encodedString;
                  });
                });
              },
              child: const Text('Hash'),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                if (storedHash.isEmpty) {
                  betterShowMessage(
                      context: context,
                      title: 'Error',
                      content: const Text('There\'s no stored hash!'));
                  return;
                }

                _sameWithStoredHash().then((valid) {
                  if (valid) {
                    betterShowMessage(
                        context: context,
                        title: 'Valid',
                        content: const Text('The hash is valid'));
                  } else {
                    betterShowMessage(
                        context: context,
                        title: 'Not Valid',
                        content: const Text('The hash is not valid'));
                  }
                });
              },
              child: const Text('Compare Hash'),
            ),
            const SizedBox(
              height: 16,
            ),
            Text('Hashed String : $storedHash'),
            const SizedBox(
              height: 8,
            ),
            Text('Encoded String : $storedEncodedString'),
          ],
        ),
      ),
    );
  }
}
