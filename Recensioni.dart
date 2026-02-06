import 'Clienti.dart';
import 'Ristoranti.dart';

class Recensioni {
  final Clienti cliente; // Istanza della classe Cliente
  DateTime data;
  String testo_recensione;
  int numero_stelle;

  Recensioni(this.cliente, this.data, this.testo_recensione, this.numero_stelle); //costruttore

  factory Recensioni.fromJson(Map<String, dynamic> json) {
    print("JSON ricevuto: $json");
    return Recensioni(
      Clienti(json['email']),
      DateTime.parse(json['data']),
      json['testo_recensione'],
      json['numero_stelle'],
    );
  }
  @override
  String toString() {
    return 'Recensione da ${cliente.email} (Stelle: $numero_stelle, Data: $data): $testo_recensione';
  }
}


//recensioni del ristorante "Da Ciccio" (preimpostate)
List<Recensioni> creaRecensioniDaCiccio(List<Clienti> clienti) { //il metodo che sto creando
  List<Recensioni> ret = []; //lista vuota
  ret.add(Recensioni(clienti[0], DateTime.now(), "Cibo ottimo, consegna veloce", 5));
  ret.add(Recensioni(clienti[1], DateTime.now(), "Fa schifo, ho trovato il capello dentro", 1));
  ret.add(Recensioni(clienti[2], DateTime.now(), "Il cibo è buono ma ci hanno messo un sacco a consegnarlo ed è arrivato tutto rovesciato", 3));

  return ret;
}

//recensioni del ristorante "Da Ciccio"
List<Recensioni> creaRecensioniPorcaVacca(List<Clienti> clienti) { //il metodo che sto creando
  List<Recensioni> ret = []; //lista vuota
  ret.add(Recensioni(clienti[0], DateTime.now(), "L'Angus era molto buono!", 5));
  ret.add(Recensioni(clienti[1], DateTime.now(), "La carne è troppo dura", 1));
  ret.add(Recensioni(clienti[2], DateTime.now(), "La carne è ottima ma ci hanno messo un sacco a consegnarlo ed è arrivato tutto rovesciato", 3));

  return ret;
}

//recensioni del ristorante "MortoDiFame"
List<Recensioni> creaRecensioniMortoDiFame(List<Clienti> clienti) { //il metodo che sto creando
  List<Recensioni> ret = []; //lista vuota
  ret.add(Recensioni(clienti[0], DateTime.now(), "Mi fa seguire la dieta. Consigliatissimo!", 5));
  ret.add(Recensioni(clienti[1], DateTime.now(), "Sono morto di fame", 1));

  return ret;
}
