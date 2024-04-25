import 'package:flutter/material.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 200,
                child: Image.asset('assets/images/home_logo.png'),
              ),
              const SizedBox(height: 40),
              const TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Имя пользователь',

                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                keyboardType: TextInputType.text,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Пароль',
                  suffixIcon: Icon(Icons.visibility_off)
                ),
              ),
              const SizedBox(height: 44),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, 'tasks', (route) => false);
                },
                child: Container(
                  width: double.maxFinite,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      )
                    ]
                  ),
                  child: const Center(
                      child: Text(
                          'Вход',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
