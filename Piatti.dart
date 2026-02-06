//Piatti e bevande
class Piatti {

  String nome;
  double prezzo;
  //forse aggiungere anche descrizione

  Piatti(this.nome, this.prezzo); //costruttore

  // Metodo per creare un Piatto da un JSON
  factory Piatti.fromJson(Map<String, dynamic> json) {
    print("JSON ricevuto: $json");

    String nome = json['nome_piatti'] ?? ''; //se è null lo sostituisce con spazio vuoto
    double prezzo = 0.0;


    return Piatti(
      json['nome_piatti'], json['prezzo']

    );
    /*return Piatti(

      json['nome']?? '',  // Se 'nome' è null, assegna una stringa vuota
      json['prezzo']!= null ? json['prezzo'].toDouble(): 0.0, // Gestisce il valore null per il prezzo
    );

     */
  }
}

//menù del ristorante "Da Ciccio"
List<Piatti> creaMenuDaCiccio() {
  List<Piatti> ret = []; //lista vuota dei piatti
  ret.add(Piatti('Pizza', 10));
  ret.add(Piatti('Tiramisù', 4));
  ret.add(Piatti('Spaghetti', 14.50));
  ret.add(Piatti('Risotto', 13.50));
  ret.add(Piatti('Coca Cola', 1.5));

  return ret;
}

//menù del ristorante "PorcaVacca"
List<Piatti> creaMenuPorcaVacca() {
  List<Piatti> ret = []; //lista vuota dei piatti
  ret.add(Piatti('Angus', 18));
  ret.add(Piatti('Tagliata di Vitello', 20));
  ret.add(Piatti('Birra rossa', 4.5));
  ret.add(Piatti('Birra bionda', 4.5));

  return ret;
}

//menù del ristorante "MortoDiFame"
List<Piatti> creaMenuMortoDiFame() {
  List<Piatti> ret = []; //lista vuota dei piatti
  ret.add(Piatti('Fame', 1));
  ret.add(Piatti('Le tue lacrime', 1.5));
  ret.add(Piatti('Sto ca', 4.5));

  return ret;
}

