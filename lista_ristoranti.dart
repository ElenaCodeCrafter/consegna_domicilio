import 'package:esame/recensioni_ako.dart';
import 'package:esame/recensioni_da_karim.dart';
import 'package:flutter/material.dart';
import 'Ristoranti.dart';
import 'Recensioni.dart';
import 'recensioni_da_ciccio.dart';
import 'recensioni_porca_vacca.dart';
import 'recensioni_morto_di_fame.dart';
import 'Piatti.dart';
import 'Clienti.dart';
import 'package:get/get.dart';
import 'menu_da_ciccio.dart';
import 'menu_da_karim.dart';
import 'menu_ako.dart';
import 'api_service.dart';


final List<int> colorCodes = <int>[600, 500, 200, 100]; //codifiche di vari colori del arancione
//final List<Persona> entries = creaPersone(); //entries è una lista di persone creata con metodo creaPersone()
//è spostato in class _MyHomePageState extends State<MyHomePage>
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
      home: const ScegliRistorantiPage(title: 'Scegli il ristorante'),
    );
  }
}

class ScegliRistorantiPage extends StatefulWidget {
  const ScegliRistorantiPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ScegliRistorantiPage> createState() => _ScegliRistorantiPageState();
}

class _ScegliRistorantiPageState extends State<ScegliRistorantiPage> {
  // final yourScrollController = ScrollController();
  //final List<Ristorante> _entries = creaRistorante(creaCliente()); //entries è una lista di ristoranti creata con metodo creaPersone()
  late Future<List<Ristorante>> _ristoranti; // Lista futura per i ristoranti
  //final List<TextEditingController> _controllers = []; //creo il contenitore per i controllers x ciascuna riga

  @override
  void initState() {
    super.initState();
    _ristoranti = fetchRistoranti(); // Chiamata alla funzione fetchRistoranti di api_service.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      ColoredBox(color: Colors.indigo,
        child: Center(
          child: ColoredBox(color: Colors.orange.shade100,
            child: Column(
              children: [

                   ColoredBox(color: Colors.orange.shade100,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded( child: Text('Ristorante', textAlign: TextAlign.center)),
                          Expanded( child: Text('Tempo di consegna (in minuti)', textAlign: TextAlign.center)),
                          Expanded(child: SizedBox(height: 20)),
                          ]),
                  ),
                
                // Definizione della larghezza delle colonne
                Expanded(child: ColoredBox(color: Colors.teal,
                  child: FutureBuilder<List<Ristorante>>(
                   future: _ristoranti,
                   builder: (BuildContext context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return Center(
                           child: CircularProgressIndicator()); // Mostra il caricamento
                     } else if (snapshot.hasError) {
                       return Center(child: Text('Errore: ${snapshot.error}'));
                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                       return Center(
                           child: Text('Nessun ristorante disponibile'));
                     } else {
                       List<Ristorante> ristoranti_c = snapshot.data!;//la lista dei ristoranti caricata

                       return ListView.separated(
                         //elementi dentro sono separati
                         //  controller: yourScrollController,
                         padding: const EdgeInsets.all(20),
                         itemCount: ristoranti_c.length, //lunghezza della lista
                         itemBuilder: (BuildContext context,
                             int index) { //funzione che costruisce il singolo elemento della lista (index)
                           // Singolo ristorante
                           final ristorante = ristoranti_c[index];
                           return Container( //restituisce il contenitore x il singolo elemento
                             height: 57,
                             color: Colors.amber[colorCodes[index % 4]],
                             //codifica del colore
                             child: Column(
                                 children: [
                                   //Text("$index") //index è il numero dell'elemento nella lista che va mostrato
                                   ColoredBox(color: Colors.orangeAccent,
                                     child: Row(
                                         mainAxisAlignment: MainAxisAlignment
                                             .start, children: [

                                       Expanded(child: Center(child: Text('${ristorante.nome}', textAlign: TextAlign.center))),
                                       Expanded(child: Center(child: Text('${ristorante.tempo_consegna}', textAlign: TextAlign.center))),

                                       Expanded(
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.end,
                                             children: [
                                               //il bottone del menù
                                               Row(
                                                   mainAxisAlignment: MainAxisAlignment.end,
                                                   // Allinea il bottone a destra
                                                   children: [
                                                     Padding( // Padding per aggiungere spazio attorno al bottone
                                                       padding: const EdgeInsets
                                                           .all(12.0),
                                                       // Spazio attorno al bottone
                                                       child: Tooltip( //widget utilizzato x il suggerimento
                                                         message: 'vai al menù',
                                                         child: ElevatedButton(
                                                           style: ElevatedButton.styleFrom(
                                                               foregroundColor: Colors.brown),

                                                           onPressed: () {
                                                             // Naviga verso la pagina del menù

                                                             if (ristoranti_c[index].nome == 'Trattoria "Da Ciccio"') {
                                                               //Get.to(() => MenuDaCiccioPage(title: 'Menù Da Ciccio'));
                                                               Get.to(() => MenuDaCiccioPage(title: 'Menù ${ristorante.nome}', // Titolo dinamico
                                                                   ));
                                                             } else
                                                             if (ristoranti_c[index].nome == 'Kebab "Da Karim"') {
                                                               Get.to(() =>
                                                                   MenuDaKarimPage(title: 'Menù "Da Karim"'));
                                                             } else
                                                             if (ristoranti_c[index].nome == 'Sushi "AKO"') {
                                                               Get.to(() =>
                                                                   MenuAkoPage(title: 'Menù Sushi "AKO"'));
                                                             }
                                                           },
                                                           child: Text('Vedi il menù'),
                                                         ),

                                                       ),
                                                     ),
                                                   ],
                                                 ),



                                               //bottone delle recensioni

                                               Row(mainAxisAlignment: MainAxisAlignment.end,
                                                   // Allinea il bottone a destra
                                                   children: [
                                                     Padding( // Padding per aggiungere spazio attorno al bottone
                                                       padding: const EdgeInsets
                                                           .all(12.0),
                                                       // Spazio attorno al bottone
                                                       child: Tooltip( //widget utilizzato x il suggerimento
                                                         message: 'vai a recensioni',
                                                         child: ElevatedButton(
                                                           style: ElevatedButton.styleFrom(
                                                               foregroundColor: Colors.brown),

                                                             onPressed: () {
                                                               // Naviga verso la pagina delle recensioni

                                                               if (ristorante.nome == 'Trattoria "Da Ciccio"') {Get.to(() =>
                                                                     RecensioniDaCiccioPage(
                                                                         title: 'Recensioni Da Ciccio'));
                                                               } else
                                                               if (ristoranti_c[index].nome == 'Kebab "Da Karim"') {
                                                                 Get.to(() =>
                                                                     RecensioniDaKarimPage(
                                                                         title: 'Recensioni "Da Karim"'));
                                                               } else
                                                               if (ristoranti_c[index].nome == 'Sushi "AKO"') {
                                                                 Get.to(() =>
                                                                     RecensioniAkoPage(title: 'Recensioni Sushi "AKO"'));
                                                               }
                                                             },
                                                             child: Text(
                                                                 'Leggi recensioni')
                                                         ),
                                                         //cliccato è un metodo definito sotto (stampa index)
                                                         //icon.add è un bottone con "+"
                                                       ),
                                                     ),
                                                   ],
                                                 ),


                                             ],
                                           ),


                                       ),
                                     ]),
                                   ),
                                   // Bottoni fuori dalla Row, sotto la lista


                                 ],),


                           );
                         },
                         separatorBuilder: (BuildContext context,
                             int index) => const Divider(), //Divider è una linea scura che divide elementi
                       );
                     }
                   },
                  ),
                ),
                ),

              ],),
          ),
        ),
      ),
    );
  }
}








