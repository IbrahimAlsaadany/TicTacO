import "dart:math";
import 'package:flutter/material.dart';
class Game extends StatefulWidget{
  const Game({super.key});
  @override
  State<Game> createState() => _GameState();
}
class _GameState extends State<Game>{
  final List<bool?> _clicked = List<bool?>.generate(9,(int _)=>null);
  bool _isX=true,_isCancelIcon=true,_showArrow=false,_p1=true;
  bool? _winnerX;
  int _scoreX=0,_scoreO=0;
  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>newGame());
  }
  @override
  Scaffold build(BuildContext context)
  => Scaffold(
    backgroundColor: Colors.white,
    body:Column(
      children:[
        SafeArea(
          child: Transform.rotate(
            angle:pi,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                resignButton(!_p1),
                SizedBox(
                  width:150,
                  child: !_showArrow||!(_p1^_isX)?null:
                  const Icon(
                    Icons.arrow_upward_rounded,
                    color:Colors.green
                  )
                ),
                result()
              ]
            ),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              xoButton('',0),
              xoButton('',1),
              xoButton('',2),
            ]
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              xoButton('',3),
              xoButton('',4),
              xoButton('',5),
            ]
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              xoButton('',6),
              xoButton('',7),
              xoButton('',8),
            ]
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            resignButton(_p1),
            SizedBox(
              width:150,
              child:_showArrow&&!(_p1^_isX)?const Icon(
                Icons.arrow_upward_rounded,
                color:Colors.green
              ):null
            ),
            result()
          ]
        )
      ]
    )
  );
  Widget xoButton(String text,int index,{Color color=Colors.grey})
  => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: MaterialButton(
        elevation:0,
        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(20),
          side:const BorderSide(width:3,strokeAlign: 3)
        ),
        color:_clicked[index]==null?color:_clicked[index]!?Colors.red:Colors.blue,
        textColor: Colors.white,
        child:Icon(
          _clicked[index]==null?null:_clicked[index]!?Icons.close:Icons.circle_outlined,
          size:60
        ),
        onPressed:(){
          if(_clicked[index]==null)
          {
            setState(()=>_clicked[index]=_isCancelIcon);
            _isCancelIcon=!_isCancelIcon;
            _isX=!_isX;
          }
          if(_clicked.whereType<bool>().length>=5)
            win();
        },
      ),
    ),
  );
  Padding resignButton(bool isP1)
  => Padding(
    padding: const EdgeInsets.symmetric(vertical:15.0),
    child: MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(20)
      ),
      color:Colors.red,
      textColor:Colors.white,
      onPressed: (){
        isP1?_scoreO++:_scoreX++;
        _isCancelIcon=_isX=!isP1;
        setState(()=>_clicked.replaceRange(0,9,List.filled(9,null)));
      },
      child: const Text(
        "Resign"
      )
    ),
  );
  void win(){
    for(int i=0;i<9;i+=3)
      if(_clicked.sublist(i,i+3).every((element)=>element==true)||
         _clicked.sublist(i,i+3).every((element)=>element==false)){
        _clicked[i]!?_scoreX++:_scoreO++;
        _winnerX=_clicked[i];
        pop();
        return null;
        }
    for(int i=0;i<3;i++)
      if(_clicked[i] is bool&&_clicked[i]==_clicked[i+3]&&_clicked[i+3]==_clicked[i+6])
      {
        _clicked[i]!?_scoreX++:_scoreO++;
        _winnerX=_clicked[i];
        pop();
        return null;
      }
    if(_clicked[4] is bool&&(_clicked[0]==_clicked[4]&&_clicked[4]==_clicked[8]
            ||_clicked[2]==_clicked[4]&&_clicked[4]==_clicked[6])){
      _clicked[4]!?_scoreX++:_scoreO++;
      _winnerX=_clicked[4];
      pop();
    }
    else if(_clicked.every((element)=>element is bool)){
      _winnerX=null;
      pop();
    }
  }
  void pop(){
    _showArrow=false;
    showDialog(
      barrierDismissible:false,
      context:context,
      builder:(_)=>Transform.rotate(
        angle:!((_winnerX??_scoreX>=_scoreO)^_p1)?0:pi,
        child: AlertDialog(
          title:Text(
            _winnerX is bool? "Winner":"Draw",
            textAlign:TextAlign.center,
            style:const TextStyle(
              letterSpacing:6,
              fontWeight:FontWeight.bold
            )
          ),
          titleTextStyle:TextStyle(
            color:_winnerX is bool? Colors.orange:Colors.grey,
            fontSize:30,
          ),
          contentPadding:const EdgeInsets.symmetric(vertical:20) ,
          content:result(40),
          actions:[
            ElevatedButton(
              style:ElevatedButton.styleFrom(
                backgroundColor:Colors.grey,
              ),
              child:const Text("New game"),
              onPressed: (){
                _isCancelIcon=true;
                Navigator.of(context).pop();
                newGame();
              },
            ),
            ElevatedButton(
              style:ElevatedButton.styleFrom(
                backgroundColor:Colors.green,
              ),
              child:const Text("Play again"),
              onPressed: (){
                _showArrow=true;
                _isCancelIcon=_isX=_winnerX??_scoreX>=_scoreO;
                setState(()=>_clicked.replaceRange(0,9,List.filled(9,null)));
                Navigator.of(context).pop();
              },
            )
          ],
          actionsAlignment:MainAxisAlignment.center,
          shape:RoundedRectangleBorder(
            side:BorderSide(width:5,color:_winnerX is bool?Colors.orange:Colors.grey),
            borderRadius:BorderRadius.circular(20)
          ),
          actionsPadding:const EdgeInsets.only(bottom:30),
        ),
      )
    );
  }
  RichText result([double fontSize=30])
  => RichText(
    textAlign:TextAlign.center,
    text:TextSpan(
      style:const TextStyle(color:Colors.black),
      children:[
        TextSpan(
          text:"$_scoreX",
          style:TextStyle(
            color:Colors.red,
            fontSize:fontSize,
            fontWeight:FontWeight.bold
          )
        ),
        TextSpan(
          text:" : ",
          style:TextStyle(
            color:Colors.black,
            fontSize:fontSize,
            fontWeight:FontWeight.bold
          )
        ),
        TextSpan(
          text:"$_scoreO",
          style:TextStyle(
            color:Colors.blue,
            fontSize:fontSize,
            fontWeight:FontWeight.bold
          )
        )
      ]
    )
  );
  void newGame(){
    _scoreX=_scoreO=0;
    _isX=true;
    setState(()=>_clicked.replaceRange(0,9,List.filled(9,null)));
    showDialog(
      barrierDismissible:false,
      context:context,
      builder:(_)=>Transform.rotate(
        angle:!((_winnerX??_scoreX>=_scoreO)^_p1)?0:pi,
        child: AlertDialog(
          title:const Text(
            "Choose",
            textAlign:TextAlign.center
          ),
          content:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              FloatingActionButton(
                heroTag:true,
                backgroundColor:Colors.blue,
                onPressed:(){
                  _showArrow=true;
                  setState(()=>_p1=_winnerX=(_winnerX??_scoreX>=_scoreO)^_p1);
                  Navigator.of(context).pop();
                },
                child:const Icon(Icons.circle_outlined)
              ),
              FloatingActionButton(
                heroTag:false,
                backgroundColor:Colors.red,
                onPressed:(){
                  _showArrow=true;
                  setState(()=>_p1=_winnerX=!((_winnerX??_scoreX>=_scoreO)^_p1));
                  Navigator.of(context).pop();
                },
                child:const Icon(Icons.close),
              )
            ]
          ),
          shape:RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(20),
            side:const BorderSide(width:5)
          )
        ),
      )
    );
  }
}