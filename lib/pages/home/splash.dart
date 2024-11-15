import 'package:flutter/material.dart';



class SplashHome extends StatelessWidget {
  const SplashHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:Text("Menu")) ,
      ),
      backgroundColor: Colors.white,
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Loading...',
                ),
                SizedBox(height: 10,),
               
                 SizedBox(height: 30,),
                
            ],
          ),
        ),
      ),
    );
  }

 
}