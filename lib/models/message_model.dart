class MessageModel {
  String? text;
  String? senderId;
  String? recieverId;
  String? dateTime;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.recieverId,
    required this.dateTime,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    senderId = json["senderId"];
    recieverId = json["recieverId"];
    dateTime = json["dateTime"];
  }

  Map<String, dynamic> toMap(){
    return{
      "text": text,
      "senderId": senderId,
      "recieverId": recieverId,
      "dateTime": dateTime,
    };
  }
}
