import "package:flutter/material.dart";
import 'package:tic_tac_o/game.dart';
void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  MaterialApp build(BuildContext context)
  => const MaterialApp(home:Game());
}
