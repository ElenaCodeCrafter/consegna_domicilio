class Clienti {
  String email;

  Clienti(this.email); //costruttore

  factory Clienti.fromJson(Map<String, dynamic> json) {
    return Clienti(
      json['email'],
    );
  }
}

List<Clienti> creaCliente() { //il metodo che sto creando
  List<Clienti> ret = [];
  Clienti cliente1 = Clienti('yoursugarmom73@yahoo.it');
  Clienti cliente2 = Clienti('lucastarwars@gmail.com');
  Clienti cliente3 = Clienti('davidgrysly@virgilio.it');

  ret.add(cliente1);
  ret.add(cliente2);
  ret.add(cliente3);

  return ret;
}