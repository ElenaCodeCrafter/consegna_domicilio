import 'Piatti.dart';
import 'Recensioni.dart';
import 'Clienti.dart';

class Ristorante {
  int id;
  String nome;
  double tempo_consegna;
  /*
  final List<Piatti> menu; // Lista tipizzata di piatti (oggetti Piatto)
  final List<Recensioni> recensioni; // Lista di recensioni (oggetti Recensione)

   */
  //Qui puoi inserire logica per menu e recensioni
  List<Piatti> menu = []; // Lista vuota di default
  List<Recensioni> recensioni = []; // Lista vuota di default

  //Ristorante(this.id, this.nome, this.tempo_consegna, this.menu, this.recensioni); //costruttore
  Ristorante(this.id, this.nome, this.tempo_consegna, {this.menu = const [], this.recensioni = const []});

  factory Ristorante.fromJson(Map<String, dynamic> json) {
    //è un factory constructor che permette di creare un oggetto Ristorante a partire da un map di dati (in questo caso, il JSON che arriva dal server).
    // Estrai i valori dal JSON
    /*
    List<Piatti> menuList = (json['menu'] as List).map((item) => Piatti.fromJson(item)).toList();
    List<Recensioni> recensioniList = (json['recensioni'] as List).map((item) => Recensioni.fromJson(item)).toList();
     */
    final tempoConsegna = json['tempi_consegna'] ?? 0; // Imposta 0 se il valore è nullo
    print("Tempi di consegna dopo il controllo: $tempoConsegna"); // Stampa per debugging

    return Ristorante(
      json['id'],
      json['nome'],
      // Verifica che 'tempo_consegna' non sia null e in caso lo sia, usa un valore di default (es. 0.0)
      tempoConsegna.toDouble(),
    );


  }
}
/*
List<Ristorante> creaRistorante(List<Clienti> clienti) {

  List<Ristorante> ret = []; // Lista vuota per raccogliere i ristoranti.

  //"Assemblaggio di menù e Recensioni di ristorante "Da Ciccio"
  List<Recensioni> recensioniDaCiccio = creaRecensioniDaCiccio(clienti);
  List<Piatti> menuDaCiccio = creaMenuDaCiccio();

  //"Assemblaggio di menù e Recensioni di ristorante "Da Ciccio"
  List<Recensioni> recensioniPorcaVacca = creaRecensioniPorcaVacca(clienti);
  List<Piatti> menuPorcaVacca = creaMenuPorcaVacca();

  //"Assemblaggio di menù e Recensioni di ristorante "Morto di Fame"
  List<Recensioni> recensioniMortoDiFame = creaRecensioniMortoDiFame(clienti);
  List<Piatti> menuMortoDiFame = creaMenuMortoDiFame();



  ret.add(Ristorante(1,'Da Ciccio', 30,menuDaCiccio, recensioniDaCiccio));
  ret.add(Ristorante(2,'Porca Vacca', 35,menuPorcaVacca, recensioniPorcaVacca));
  ret.add(Ristorante(3,'Morto di Fame', 50,menuMortoDiFame, recensioniMortoDiFame));
  return ret;


}

 */