import 'package:esame/Piatti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'carello.dart';
import 'recensioni_da_ciccio.dart';
import 'lista_ristoranti.dart';

class Controller extends GetxController {
  var cart = <Piatti>[].obs; // Lista osservabile di prodotti in carello
  //per ora è vuota ma poi va riempita
  //var prova = 'stringa'.obs;

  //metodi per aggiungere/rimuovere piatti

  void addToCart(Piatti piatto) {
    //aggiunta prodott* in carello

    //gestione ripetizioni prodotti in carello
    bool trovato = false;

    // Ciclo su tutti i piatti nel carrello
    for (var item in cart) {
      if (item.nome == piatto.nome && item.prezzo == piatto.prezzo) {
        // Se troviamo un piatto con lo stesso nome e prezzo
        int index = cart.indexOf(item); // Otteniamo l'indice del piatto
        aggiungiQuantita(index); // Aggiungiamo quantità
        trovato = true;
        break; // Uscire dal ciclo poiché abbiamo trovato il piatto
      }
    }
    //fuori dal ciclo per aggiungere prodotti in carello independentemente dal contenuto carello
      if (!trovato) {
        cart.add(piatto);
        _quantitaMap.add(1); //imposto quantità iniziale = 1
        print("aggiunto al carello: ${piatto.nome}");
      }

    }


  void rimuoviPiatto(Piatti piatto) {
    cart.remove(piatto); // Rimuove il prodotto specifico
    int index = cart.indexOf(piatto);
    _quantitaMap.removeAt(index);
  }

  void svuotaCarrello() {
    cart.clear(); // Svuota tutto il carrello
    _quantitaMap.clear(); // e anche la quantitaMap
  }

  // Mappa che tiene traccia della quantità di ogni piatto nel carrello
  RxList <int> _quantitaMap = <int>[].obs;

  List <int> get quantitaMap => _quantitaMap;

  //metodi per aggiungere/togliere quantità di piatti
  // Ottieni la quantità di un piatto, se non c'è già nella lista, la quantità è 1 di default
  //String get quantitaMap(index) => '${_quantitaMap[index]}';

  int getQuantita(int index) {
    // Se il piatto non è nella mappa, viene aggiunto con quantità = 1
    if (_quantitaMap[index] == 0) {
      _quantitaMap[index] = 1; // Aggiungi con quantità 1 di default
    }
    return _quantitaMap[index]!;
  }

  // Incrementa la quantità del piatto di 1
  void aggiungiQuantita(int index) {
    _quantitaMap[index] = _quantitaMap[index] + 1;
    _quantitaMap.refresh();
  }


  // Decrementa la quantità del piatto di 1 (non può scendere sotto 1)
  void togliQuantita(int index) {
    if (_quantitaMap[index] > 1){
      quantitaMap[index] = _quantitaMap[index] - 1;
    } else{
      _quantitaMap[index] = 1;
    }
    _quantitaMap.refresh();
  }


  //Calcolo del totale
  double calcolaTotale(List<Piatti> entries) {
    double totale = 0;

    for (int i = 0; i < entries.length; i++) {
      // Recupera la quantità dal map
      int? quantita = _quantitaMap[i]; // Prende la quantità dal map (potrebbe essere null)

      if (quantita != null && quantita > 0) { // Se la quantità esiste e è positiva
        double prezzo = entries[i].prezzo; // Ottieni il prezzo del piatto
        totale += prezzo * quantita; // Calcola il totale per quel piatto
      }
    }

    return totale;
  }



  // Funzione per mostrare il pop-up di conferma ordine
  void mostraConfermaOrdine(double totale, int tempoAttesa ) {
    // Usa GetX per mostrare il dialog
    Get.dialog(
      cart.isEmpty // Verifica se la lista è vuota
          ? AlertDialog(title: Text("Impossibile inviare l'ordine"),
          content: Center(child: Text("Nessun articolo nel carrello. Aggiungi articol* oppure annulla l'ordine"))) :
      AlertDialog(
        title: Text('Riepilogo Ordine'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Il tuo ordine è stato correttamente inviato!'),
            Text('Totale: €${totale.toStringAsFixed(2)}'),
            // Mostra il totale
            Text('Tempo di attesa: ${tempoAttesa} min'),
            // Mostra il tempo di attesa
          ],
        ),
        actions: [
          /*
          TextButton(
            onPressed: () {
              // Dopo la conferma, vai alla pagina delle recensioni
              Get.to(() =>
                  RecensioniDaCiccioPage(
                      title: 'Recensioni ristorante $ristoranteId'), arguments: {'ristoranteId': ristoranteId}); // Naviga alla pagina delle recensioni
            },
            child: Text('Lascia recensione'),
          ),

           */
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Dopo la conferma, vai alla pagina della lista dei ristoranti
              Get.to(() =>
                  ScegliRistorantiPage(
                      title: 'Scegli il ristorante')); // Naviga alla lista dei ristoranti
            },
            child: Text('Torna ai ristoranti'),
          ),
        ],
      ),
    );
  }
}







