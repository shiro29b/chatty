
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _store = FirebaseFirestore.instance;
late User loggedInUser;


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth= FirebaseAuth.instance;

  late String messageText;
  final messageTextController =TextEditingController();



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

Future getCurrentUser() async{
  try{
    final user= await _auth.currentUser;
    if(user !=null){
        loggedInUser = user;
        print(loggedInUser.email);

    }
  }
  catch(e){
      print(e.toString());
  }
}

/*void getMessages() async{
  final messages = await _store.collection('messages').get();
  for(var message in messages.docs)
    {
       print(message.data(),);
    };

}*/
  Future messageStream() async{
    await for(var snapshot in _store.collection('messages').snapshots()){
      for(var message in snapshot.docs)
      {
        print(message.data(),);
      };
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacementNamed(context,'/login');
                messageStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStreams(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText=value;

                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _store.collection('messages').add({
                        'text':messageText,
                        'sender':loggedInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                      

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreams extends StatelessWidget {
  const MessageStreams() ;



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _store.collection('messages').orderBy('time',descending: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

          if(!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),

            );
          }
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  List <MessageBubble> messageWidgets= [];

                  final messages = snapshot.data!.docs[index];

                    final messageText = messages['text'];
                    final messageSender = messages['sender'];
                    final currentUser = loggedInUser.email;

                    final messageWidget = MessageBubble(text: messageText, sender: messageSender, isMe: currentUser==messageSender);

                    messageWidgets.add(messageWidget);

                  return messageWidget;
                }
            ),
          );
          final messages = snapshot.data!.docs;
          List <MessageBubble> messageWidgets= [];
          for(var message in messages)
          {
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];
            final currentUser = loggedInUser.email;

            final messageWidget = MessageBubble(text: messageText, sender: messageSender, isMe: currentUser==messageSender);

            messageWidgets.add(messageWidget);
          }


          // return Expanded(
          //   child: ListView(
          //   reverse: true ,
          //     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          //     children: messageWidgets,
          //   ),
          // );
        }
    );
  }
}




class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.text,required this.sender, required this.isMe});

  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [

          Material(
            elevation: 5,
            borderRadius: isMe ?BorderRadius.only(
                 topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ):BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: isMe ? Colors.lightBlueAccent: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text('$text',textAlign: TextAlign.end,
                style: TextStyle(
                  color: isMe ? Colors.white: Colors.black54,
                ),
              ),
            ),
          ),
          Text(sender,
            style:TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
