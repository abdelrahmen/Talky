class UserModel {
  String? name;
  String? email;
  String? uId;
  String? image;
  UserModel({required this.name, required this.email, required this.uId, required this.image});

  UserModel.fromJson(Map<String, dynamic> json){
    name = json["name"]; 
    email = json["email"]; 
    uId = json["uId"];
    image = json["imageUrl"];
  }
}
