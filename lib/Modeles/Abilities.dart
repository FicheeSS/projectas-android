
class Abilities {

  late String _nom;

  String get nom => _nom;

  set nom(String value) {
    _nom = value;
  }

  late String _desc;
  late int _cd;


  Abilities(String nom,String desc,int cd){
    _nom = nom;
    _desc = desc;
    _cd = cd;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  int get cd => _cd;

  set cd(int value) {
    _cd = value;
  }
}