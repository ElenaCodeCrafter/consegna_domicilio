import 'package:flutter/material.dart';
import 'Ristoranti.dart';
import 'Recensioni.dart';
import 'Piatti.dart';
import 'Clienti.dart';
import 'package:get/get.dart';
import 'controllerCarello.dart';
import 'carello.dart';
import 'lista_ristoranti.dart';
import 'api_service.dart';

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
      home: const MenuDaKarimPage(title: 'Menù "Da Karim"'),
    );
  }
}

class MenuDaKarimPage extends StatefulWidget {
  const MenuDaKarimPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MenuDaKarimPage> createState() => _MenuDaKarimPageState();
}

class _MenuDaKarimPageState extends State<MenuDaKarimPage> {
  // final yourScrollController = ScrollController();
  //final List<Piatti> _entries = creaMenuDaCiccio(); //entries è una lista di piatti
  // il controller GetX per trasferire i dati al carrello
  final Controller _controller = Get.put(Controller());


  @override
  Widget build(BuildContext context) {
    final int ristoranteId = 2;
    final String ristoranteNome = "Da Ciccio";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      ColoredBox(color: Colors.brown,
        child: Column(
          children: [

            //intestazione
             ColoredBox(color: Colors.blueGrey,
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded( child: Text('Piatto/Bevanda', textAlign: TextAlign.center)),
                      Expanded( child: Text('Prezzo (€)', textAlign: TextAlign.center)),
                      Expanded(child: SizedBox(height: 21)),
                    ]),
              ),



            // Definizione della larghezza delle colonne
            Expanded(child: ColoredBox(color: Colors.teal,
              child: FutureBuilder<List<Piatti>>(
                future: fetchMenu(ristoranteId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                     return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                     return Center(child: Text('Errore: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                List<Piatti> menu = snapshot.data!;// questo è il menu con i piatti da server
                return ListView.separated( //serve anche per l'esame
                  //elementi dentro sono separati
                  //  controller: yourScrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: menu.length, //lunghezza della lista
                  itemBuilder: (BuildContext context, int index) { //funzione che costruisce il singolo elemento della lista (index)
                    return  Container( //restituisce il contenitore x il singolo elemento
                      height: 57,
                      color: Colors.amber[colorCodes[index % 4]], //codifica del colore
                      child: Column(
                        children:[
                          //Text("$index") //index è il numero dell'elemento nella lista che va mostrato
                          ColoredBox(color: Colors.orangeAccent,
                            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                              Expanded(child: Center(child: Text('${menu[index].nome}', textAlign: TextAlign.center))),
                              Expanded(child: Center(child: Text('${menu[index].prezzo}', textAlign: TextAlign.center))),
                              //entries è una lista di ristoranti con indice 0,1,2... nella lista "entries"

                              Expanded(
                                child:
                    //ColoredBox(color:Colors.pinkAccent,
                                  //child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //children: [

                                      //il bottone aggiungi al carello
                                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Allinea il bottone a destra
                                          children: [
                                            Padding(  // Padding per aggiungere spazio attorno al bottone
                                              padding: const EdgeInsets.all(12.0),  // Spazio attorno al bottone
                                              child: Tooltip( //widget utilizzato x il suggerimento
                                                message: 'aggiungi al carello',
                                                child: ElevatedButton(

                                                    onPressed: () {

                                                      final piatto = menu[index];
                                                      // Aggiungo il piatto selezionato al carrello (in base all'indice di riga)
                                                      _controller.addToCart(piatto);
                                                      print("aggiunto al carello");
                                                    },
                                                    child: const Icon(Icons.add, color: Colors.brown,),//icona del "+"
                                                //cliccato è un metodo definito sotto (stampa index)
                                                //icon.add è un bottone con "+"
                                              ),
                                            ),

                                           ),
                                          ],
                                      ),

                                //]),
                              //),
                              ),
                          ]),
                          // Bottoni fuori dalla Row, sotto la lista

                          ),],),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(), //Divider è una linea scura che divide elementi
                );
                  } else {
                  return Center(child: Text('Nessun dato disponibile.'));
                  }
                },
              ),
            ),
            ),

            //riga dei bottoni fuori lista
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                //bottone Torna alla lista dei ristoranti
            Row(mainAxisAlignment: MainAxisAlignment.start,  // Allinea il bottone a destra
             children: [

             Padding(  // Padding per aggiungere spazio attorno al bottone
             padding: const EdgeInsets.all(12.0),  // Spazio attorno al bottone
              child: Tooltip( //widget utilizzato x il suggerimento
               message: 'vai alla lista dei ristoranti',
               child: ElevatedButton(
               style: ElevatedButton.styleFrom(
               minimumSize: const Size(120, 60), // Dimensioni minime del bottone (larghezza, altezza)
                 foregroundColor: Colors.brown,
               shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8), // Angoli leggermente arrotondati
               ),
               ),
                 onPressed: () {
                   // Naviga verso la pagina dei ristoranti

                   Get.to(() => ScegliRistorantiPage(title: 'Scegli il ristorante'));
                 },
                 child: Text('Vedi tutti ristoranti '),//icona del carello,

               ),
              ),
             ),
               ColoredBox(color: Colors.pinkAccent ,child: SizedBox(width: 9,)),

             ]
            ),


                //bottone vai al carello
                Row(mainAxisAlignment: MainAxisAlignment.end,  // Allinea il bottone a destra
                      children: [

                        Padding(  // Padding per aggiungere spazio attorno al bottone
                          padding: const EdgeInsets.all(12.0),  // Spazio attorno al bottone
                          child: Tooltip( //widget utilizzato x il suggerimento
                            message: 'vai al carello',
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(120, 60), // Dimensioni minime del bottone (larghezza, altezza)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Angoli leggermente arrotondati
                                ),
                              ),

                              onPressed: () {
                                // Naviga verso la pagina del carrello

                                Get.to(() => CarelloPage(title: 'Riepilogo ordine'));
                              },
                              child: const Icon(Icons.shopping_cart, size: 40, color: Colors.brown,),//icona del carello,
                              //cliccato è un metodo definito sotto (stampa index)
                              //icon.add è un bottone con "+"
                            ),
                          ),
                        ),
                        ColoredBox(color: Colors.pinkAccent ,child: SizedBox(width: 9,)),

                      ]
                  ),
              ],
            ),

    ],),
      ),
    );
  }
}








