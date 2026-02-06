import 'package:esame/Clienti.dart';
import 'package:esame/Recensioni.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'api_service.dart';
import 'dart:convert';  // Per manipolare le risposte in JSON
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


final List<int> colorCodes = <int>[600, 500, 200, 100]; //codifiche di vari colori del arancione

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RecensioniDaCiccioPage(title: 'Recensioni "Da Ciccio"'),
    );
  }
}

class RecensioniDaCiccioPage extends StatefulWidget {
  const RecensioniDaCiccioPage({Key? key, required this.title}) : super(key: key);

  final String title;


  @override
  State<RecensioniDaCiccioPage> createState() => _RecensioniDaCiccioPageState();
}

class _RecensioniDaCiccioPageState extends State<RecensioniDaCiccioPage> {
  //tutte le resorse accessibili da qualsiasi punto (c.d. megavariabili)


  //final List<Recensioni> _entries = creaRecensioniDaCiccio(creaCliente()); //entries è una lista di recensioni
  //_entries è una variabile della classe e che fuori dalla classe non voglio modificare
  //final List<Clienti> _clienti = creaCliente();

  double _currentRating = 0; // Valutazione iniziale (modificabile)
  final _recensioneController = TextEditingController(text: 'Scrivi la tua'); //permette di fare modifiche più sofisticate
  final TextEditingController _emailController = TextEditingController();//controller del campo email
  int ristoranteId = 1; // Aggiungo l'idRistorante come parametro

  // Lista di recensioni caricata dal server
  RxList<Recensioni> recensioni = <Recensioni>[].obs;



  // Funzione per aggiungere una nuova recensione al server
  Future<void> aggiungiRecensione(int ristoranteId) async {
    //wifi di casa
    //final url = Uri.parse('http://192.168.8.130/android/apiA.php?action=aggiungiRecensioni&ristorante_id=$ristoranteId');
    //wifi di cellulare
    //final url = Uri.parse('http://192.168.43.50/android/apiA.php?action=aggiungiRecensioni&ristorante_id=$ristoranteId');
    final url = Uri.parse('http://192.168.43.50/android/apiA.php');
    //final url = Uri.parse('http://10.0.2.2/android/apiA.php');

    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final nuovaRecensione = {
      "email": _emailController.text,
      "numero_stelle": _currentRating.toInt(),
      "testo_recensione": _recensioneController.text,
      //"data": DateTime.now().toString(),
      "data": formattedDate,
      "id_ristorante": ristoranteId,
      "action": "aggiungiRecensioni"
    };

    //debug
    print('URL: $url');
    print('Headers: {"Content-Type": "application/json"}');
    print('Body: ${json.encode(nuovaRecensione)}');
    print('Dati inviati: $nuovaRecensione');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(nuovaRecensione),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchRecensioni(ristoranteId); // Ricarica le recensioni dal server
        _emailController.clear();
        _recensioneController.clear();
        _currentRating = 0;

      } else {
        Get.snackbar("Errore", "Impossibile aggiungere la recensione");
      }
    } catch (e) {
      Get.snackbar("Errore", "Errore di connessione al server");
      print("Errore di connessione: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecensioni(ristoranteId); // Carica le recensioni appena la pagina viene avviata
  }



  /*
  Future <void> aggiungiRecensione(index) {
    //print('click index = $index'); //stampa in console

    setState(() { //controlla se ci sono cambiamenti nell'interfaccia
      //istruzioni per aggiornare le variabili con cui è costruita l'interfaccia

      String emailInserita = _emailController.text; //recupero email inserita dal form
      Clienti? cliente; // Dichiaro la variabile cliente che potrebbe essere anche null
      Clienti? clienteEsistente;

      // Verifico se esiste già un cliente con questa email
      for (var c in _clienti) {
        if (c.email == emailInserita) {
          clienteEsistente = c;
          break; // Trovo il primo cliente con l'email e esco dal ciclo
        }
      }

      // Se il cliente non esiste, lo aggiungo alla lista Clienti cliente;
      if (clienteEsistente == null) {
        cliente = Clienti(emailInserita);
        _clienti.add(cliente!); // Aggiungo il nuovo cliente che non è null alla lista
      } else {
      cliente = clienteEsistente;
      }


      // Aggiungo la recensione associata al cliente
      _entries.add(Recensioni(cliente!, DateTime.now(), _recensioneController.text, _currentRating.toInt()));//inserisce nuova riga alla fine
      //segue l'ordine del costruttore
      _recensioneController.text; //recupera la recensione dal campo "Textfienld"

      // Pulisco i campi del form dopo aver aggiunto
      _emailController.clear();
      _recensioneController.clear();
      _currentRating = 3; // Reimposta la valutazione iniziale
    });
  }

    */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Colore del bordo
              width: 2.0, // Spessore del bordo
            ),
            borderRadius: BorderRadius.circular(12.0), // Angoli arrotondati
            color: Colors.grey[200], // Colore di sfondo
          ), // Fine BoxDecoration
          padding: EdgeInsets.all(16.0), // Spazi interni tra bordo e contenuto


          //il form

            child: Column(
              children: [

                //Call-to--action
                Text(
                  "Scrivi la tua recensione",
                  style: TextStyle(
                    fontSize: 32, // Dimensione grande del testo, come un h1
                    fontWeight: FontWeight.bold, // Per farlo in grassetto, opzionale
                  ),),// Spazio tra la scritta e il TextField

                //lo spazio vuoto tra scritta e il box
                SizedBox(height: 20),



                //Valutazione
                Row(
                  children: [
                    Text("Come valuteresti la tua esperienza d'acquisto? *"), // Etichetta
                    SizedBox(width: 8), // Spazio tra il testo e le stelle
                    RatingBar.builder(
                      initialRating: _currentRating, // Valutazione iniziale
                      minRating: 1, // Valutazione minima
                      direction: Axis.horizontal,
                      allowHalfRating: true, // Consente mezze stelle
                      itemCount: 5, // Numero massimo di stelle
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber, // Colore delle stelle
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _currentRating = rating; // Aggiorna la valutazione
                        });
                      },
                    ),
                  ],
                ),



                // la righe delle etichette e campi
                 Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //colonna delle etichette
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

                          SizedBox(height: 15),

                          Text('Email: *'),

                          SizedBox(height: 45), // Spazio tra le tichette

                          Text('Commento:'),

                        ]),



                      //lo spazio tra le colonne
                      SizedBox(width: 16),

                      //colonna dei campi
                      Expanded(
                        child:  Column(children: [
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0), // Angoli arrotondati opzionali
                                  borderSide: BorderSide(
                                    color: Colors.black, // Colore della cornice
                                    width: 1.0, // Spessore della cornice
                                  ), // Fine definizione del bordo
                                ), // Fine definizione del contorno
                                contentPadding: EdgeInsets.symmetric(horizontal: 8.0), // Padding interno
                                hintText: 'Inserisci la email', // Testo d'esempio
                              ), // Fine decorazione
                            ),

                            SizedBox(height: 20), // Spazio tra i campi


                            TextField(
                              controller: _recensioneController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0), // Angoli arrotondati opzionali
                                  borderSide: BorderSide(
                                    color: Colors.black, // Colore della cornice
                                    width: 1.0, // Spessore della cornice
                                  ), // Fine definizione del bordo
                                ), // Fine definizione del contorno
                                contentPadding: EdgeInsets.symmetric(horizontal: 8.0), // Padding interno
                                hintText: 'Scrivi la tua', // Testo d'esempio
                              ), // Fine decorazione
                            ), // Fine TextField

                          ]),

                      )],
                  ),


                //lo spazio tra form e il bottone
                SizedBox(height: 20),

                //bottone aggiunta recensione
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(  // Padding per aggiungere spazio attorno al bottone
                      padding: const EdgeInsets.all(6.0),  // Spazio attorno al bottone
                      child: Tooltip( //widget utilizzato x il suggerimento
                        message: 'Aggiungi recensione',
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),

                            onPressed: () => aggiungiRecensione(ristoranteId), child: Text('Aggiungi recensione')),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),// spazio tra bottone e lista


                //lista

                //intestazione lista

                Expanded(
                  child: Column(
                    children: [
                      SizedBox(width:962,
                        child: ColoredBox(color: Colors.orangeAccent,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: Text('Utente', textAlign: TextAlign.center)),
                              Expanded(
                                  child: Text('Valutazione', textAlign: TextAlign.center)),
                              //Expanded( child: Text('Cambio nome', textAlign: TextAlign.center)),
                              Expanded(child: Text('Data', textAlign: TextAlign.center)),
                              Expanded(child: Text('Commento', textAlign: TextAlign.center)),

                            ],
                          ),
                        ),
                      ),
                  
                      // Lista
                      Expanded(child:
                      FutureBuilder<List<Recensioni>>(
                        future: fetchRecensioni(ristoranteId),
                        builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Errore: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                        List<Recensioni> recensioni = snapshot.data!;// questo è il menu con i piatti da server
                        return ListView.separated(
                            //elementi dentro sono separati
                            //  controller: yourScrollController,
                            padding: const EdgeInsets.all(20),
                            itemCount: recensioni.length, //lunghezza della lista
                            itemBuilder: (BuildContext context, int index) { //funzione che costruisce il singolo elemento della lista (index)
                              return Container( //restituisce il contenitore x il singolo elemento
                                height: 65,
                                color: Colors.teal,
                                //codifica del colore
                                child: Column(
                                  children: [
                                    //Text("$index") //index è il numero dell'elemento nella lista che va mostrato
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(child: Center(child: Text(
                                            //associo la recenzione alla email del cliente
                                              '${recensioni[index].cliente.email}', // Accedi al cliente direttamente dalla recensione
                                              textAlign: TextAlign.center))),
                                          //entries è una lista di persone

                                          //visualizzazione di valutazioni come stelle
                                          Expanded(
                                            child: Center(
                                              child: RatingBarIndicator(
                                                rating: recensioni[index].numero_stelle.toDouble(), // Converto in double perché lo vuole la barra
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 20.0, // Regola la dimensione delle stelle
                                                direction: Axis.horizontal,
                                              ),
                                            ),
                                          ),


                                          Expanded(child: Center(child: Text(
                                              '${recensioni[index].data}',
                                              textAlign: TextAlign.center))),
                                          Expanded(child: Center(child: Text(
                                              '${recensioni[index].testo_recensione}',
                                              textAlign: TextAlign.center))),
                                        ]),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context,
                                int index) => const Divider(), //Divider è una linea scura che divide elementi
                           );
                            } else {
                            return Center(child: Text('Nessun dato disponibile.'));
                            }
                        },

                      ),),
                    ],
                  ),
                ),


              ],
            ),
          //),
        ),
      )

            //Form aggiunta recensione


             // Spazio tra la scritta e il TextField

            //lo spazio vuoto tra scritta e il box





















    );
  }
}



