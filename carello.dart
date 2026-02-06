import 'package:esame/Clienti.dart';
import 'package:esame/Piatti.dart';
import 'package:esame/Recensioni.dart';
import 'package:esame/menu_da_ciccio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllerCarello.dart';


final List<int> colorCodes = <int>[600, 500, 200, 100]; //codifiche di vari colori del arancione

void main() {
  Get.put(Controller());
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
      home:  CarelloPage(title: 'Riepilogo ordine'),
    );
  }
}

class CarelloPage extends GetView<Controller> {
   CarelloPage({Key? key, required this.title}) : super(key: key);

  final String title;

  //@override
  //State<CarelloPage> createState() => _CarelloPageState();
//}

//class _CarelloPageState extends State<CarelloPage> {
  //tutte le resorse accessibili da qualsiasi punto (c.d. megavariabili)


  //final List<Piatti> _entries = creaMenuDaCiccio(); //entries è una lista di piatti
  //final List<Piatti> cart = creaMenuDaCiccio();
  //final List<Piatti> cart = [];
  //_entries è una variabile della classe e che fuori dalla classe non voglio modificare
  final List<Clienti> _clienti = creaCliente();
   // Ottieni l'istanza del controller di carello

  @override
  Widget build(BuildContext context) {
    //final String ristoranteNome = Get.arguments['ristoranteNome']; //recupero nome della pagina di menù di provenienza
    //final int ristoranteId = Get.arguments['ristoranteId'];
    return Scaffold(
        appBar: AppBar(
          title: Text('Carello'),
        ),
        body:

        ColoredBox(color: Colors.teal,
          child: Center(
            child: ColoredBox(color: Colors.orangeAccent,
              child: Column(
                children: [
                  //Intestazione
                  Text(
                    "Carello",
                    style: TextStyle(
                      fontSize: 22, // Dimensione grande del testo, come un h1
                      fontWeight: FontWeight.bold, // Per farlo in grassetto, opzionale
                    ),), // Spazio tra la scritta e il TextField

                   Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Colore del bordo
                          width: 2.0, // Spessore del bordo
                        ),
                        borderRadius: BorderRadius.circular(12.0), // Angoli arrotondati
                        color: Colors.brown, // Colore di sfondo
                      ), // Fine BoxDecoration
                      padding: EdgeInsets.all(16.0), // Spazi interni tra bordo e contenuto
                      child: SizedBox(
                        width: 750,
                        height: 300,

                        child:
                          ColoredBox(color: Colors.white70,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                    ColoredBox(color: Colors.blueGrey,

                                      //intestazione
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded( child: Text('Articolo', textAlign: TextAlign.center)),
                                            Expanded( child: Text('Quantità', textAlign: TextAlign.center)),
                                            Expanded( child: Text('Prezzo (€)', textAlign: TextAlign.center)),
                                            SizedBox(width: 230)

                                            //allineamento tra intestazione e tabella
                                          ]),
                                    ),

                                    SizedBox(height: 10),//piccolo spazio


                                      //lista di articoli nel carello


                                      Expanded(
                                        child: Obx(()=>

                                                  controller.cart.isEmpty // Verifica se la lista è vuota
                                                      ? Center(child: Text("Nessun articolo nel carrello")) :
                                                  //Text('fin qua tutto ok')
                                          
                                            //da qui iniziano problemi
                                          
                                                  ListView.separated(
                                                        shrinkWrap: true,  // Per evitare che la lista cresca oltre i suoi limiti
                                                        padding: const EdgeInsets.all(20),
                                                        itemCount: controller.cart.length, //lunghezza della lista
                                                        itemBuilder: (BuildContext context, int index) { //funzione che costruisce il singolo elemento della lista (index)
                                                          return
                                                            //Text('fin qua tutto ok');
                                                            Container(
                                                              height: 57,
                                                              child:
                                                                  Column(
                                                                    children: [
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                                                                          /*
                                                                          SizedBox(width: 100, child: Text('${controller.cart[index].nome}', textAlign: TextAlign.center)),
                                                                          SizedBox(width:100, child: Obx(() =>Text('${controller.quantitaMap[index]}', textAlign: TextAlign.center))),
                                                                          SizedBox(width:100, child: Text('${controller.cart[index].prezzo}', textAlign: TextAlign.center)),
                                        
                                        
                                                                           */
                                                                          Expanded(child: Text('${controller.cart[index].nome}', textAlign: TextAlign.center)),
                                                                          Expanded(child: Obx(() =>Text('${controller.quantitaMap[index]}', textAlign: TextAlign.center))),
                                                                          Expanded(child: Text('${controller.cart[index].prezzo}', textAlign: TextAlign.center)),
                                                                          ElevatedButton(
                                        
                                                                          onPressed: () {
                                                                            controller.aggiungiQuantita(index);
                                                                          },
                                                                          child: const Icon(Icons.add, color: Colors.brown,),//icona del "+"

                                                                          //icon.add è un bottone con "+"
                                                                        ),
                                                                        ElevatedButton(
                                        
                                                                          onPressed: () {
                                                                            controller.togliQuantita(index);
                                                                          },
                                                                          child: const Icon(Icons.remove, color: Colors.brown),//icona del "-"
                                                                          //icon.add è un bottone con "+"
                                                                        ),
                                                                        ElevatedButton(
                                        
                                                                          onPressed: () {
                                                                            // Recupero il piatto dalla lista cart usando l'indice
                                                                            Piatti piatto = controller.cart[index];
                                                                            controller.rimuoviPiatto(piatto);
                                                                          },
                                                                          child: const Icon(Icons.delete, color: Colors.brown),//icona del cestino
                                        
                                                                        ),
                                                                      ],),
                                                                      
                                                                    ],
                                                                  ),
                                                              
                                                            )
                                        
                                                          ;
                                                        },
                                                           separatorBuilder: (BuildContext context, int index) => const Divider(),
                                                      ),
                                            
                                            //commentare fino a qua
                                          
                                            // problemi finiscono con questo widget
                                          

                                        ),
                                      ),



                                    //separatore prima totale
                                    Divider(color: Colors.grey, thickness: 1, height: 20),


                                    //riga totali
                                    Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Totale:",
                                          style: TextStyle(
                                            fontSize: 14, // Dimensione grande del testo, come un h1
                                            fontWeight: FontWeight.bold, // Per farlo in grassetto, opzionale
                                          ),),
                                        SizedBox(width: 5,), //spazio tra righe
                                        Obx(() =>
                                               Text('${controller.calcolaTotale(controller.cart)}',style: TextStyle(
                                                fontSize: 14, // Dimensione grande del testo, come un h1
                                                fontWeight: FontWeight.bold, // Per farlo in grassetto, opzionale
                                              ),),
                                            )
                        ,
                                        SizedBox(width: 5),
                                        Text("€", style: TextStyle(
                                          fontSize: 14, // Dimensione grande del testo, come un h1
                                          fontWeight: FontWeight.bold, // Per farlo in grassetto, opzionale
                                        ),),
                                      ],
                                    )
                                    ]
                                ),



                              ),



                              ),
                      ),



                //i bottoni fuori
                SizedBox(width: 300,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      //bottone "Conferma"
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(  // Padding per aggiungere spazio attorno al bottone
                            padding: const EdgeInsets.all(6.0),  // Spazio attorno al bottone
                            child: Tooltip( //widget utilizzato x il suggerimento
                              message: "Invia l'ordine",
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),

                                  onPressed: () {
                                    // Calcola il totale e il tempo di attesa
                                    double totale = controller.calcolaTotale(controller.cart); // Totale dell'ordine
                                    int tempoAttesa = 30; // Esempio di tempo di attesa (puoi sostituirlo con il valore reale)


                                    // Mostra il pop-up di conferma
                                    controller.mostraConfermaOrdine(totale, tempoAttesa);
                                  },
                                  child: Text('Conferma')),
                            ),
                          ),
                        ],
                      ),


                      //bottone "Annullla"
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(  // Padding per aggiungere spazio attorno al bottone
                            padding: const EdgeInsets.all(6.0),  // Spazio attorno al bottone
                            child: Tooltip( //widget utilizzato x il suggerimento
                              message: "Annulla l'ordine",
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),

                                  onPressed: () {
                                     controller.svuotaCarrello();
                                    // Dopo la conferma, vai alla pagina delle recensioni
                                    Get.to(() => MenuDaCiccioPage(title: 'Menù "Da Ciccio"')); // Torna al menù
                                  }, child: Text('Annulla tutto')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ],
              )
            ),
          ),
        )
    );

  }
}




