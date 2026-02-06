import 'dart:convert';  // Per manipolare le risposte in JSON
import 'package:http/http.dart' as http;
import 'Ristoranti.dart';
import'Recensioni.dart';
import 'Clienti.dart';
import 'recensioni_da_ciccio.dart';
import'Piatti.dart';// Importa la classe Ristorante che hai definito
import 'package:get/get.dart';

var recensioni = <Recensioni>[].obs;
var clienti = <Clienti>[].obs;

// Funzione per recuperare la lista dei ristoranti dal server
Future<List<Ristorante>> fetchRistoranti() async {
  // URL del tuo API PHP che restituisce la lista dei ristoranti
  try{
    //IP WIFI di casa
    //final response = await http.get(Uri.parse('http://192.168.8.130/android/apiA.php?action=recuperaRistoranti'));

    //IP di Hotspot di cellulare
    final response = await http.get(Uri.parse('http://10.148.3.95/android/apiA.php?action=recuperaRistoranti'));

  // Verifica che la richiesta sia stata eseguita con successo (status code 200)
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        print('La risposta è vuota.');
        return [];  // Ritorna una lista vuota
      }
    // Se la richiesta è andata a buon fine, decodifica il JSON
    print(response.body);
    List<dynamic> data = jsonDecode(response.body);

    // Mappa i dati ricevuti alla lista di oggetti Ristorante
    return data.map((item) {
      return Ristorante.fromJson(item);  // Usa la funzione `fromJson` per ogni elemento
    }).toList();
   } else {

  print('Server responded with status: ${response.statusCode}');
  print('Messaggio del server: ${response.body}');
  throw Exception('Errore nella risposta del server');

  }
  }
  catch (e) {
  print('Errore: $e');
  print('Eccezione catturata: $e');
  }
    // In caso di errore, lancia un'eccezione
    throw Exception('Failed to load ristoranti');
  }


// Funzione per recuperare le recensioni di un ristorante
Future<List<Recensioni>> fetchRecensioni(int ristoranteId) async {

  try {
    //IP WIFI di casa
    //final response = await http.get(Uri.parse('http://192.168.8.130/android/apiA.php?action=recuperaRecensioni&ristorante_id=$ristoranteId'));

    //IP di Hotspot di cellulare
    //final response = await http.get(Uri.parse('http://192.168.43.50/android/apiA.php?action=recuperaRecensioni&ristorante_id=$ristoranteId'));
    final response = await http.get(Uri.parse('http://10.148.3.95/android/apiA.php?action=recuperaRecensioni&ristorante_id=$ristoranteId'));
    print(response.body);
    print("Risposta ricevuta: ${response.body}");
    print('Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');

    if (response.statusCode == 200) {

      List<dynamic> data = json.decode(response.body);
      // Mappa i dati ricevuti in una lista di oggetti Recensioni
      List<Recensioni> nuoveRecensioni = data.map((rec) {
        return Recensioni(
          Clienti(rec["email"]), // Creo l'istanza del cliente direttamente dalla email
          DateTime.parse(rec["data"]),
          rec["testo_recensione"],
          rec["numero_stelle"],
        );
      }).toList();

      recensioni.assignAll(nuoveRecensioni);

      // Creo la lista di clienti univoci
      Set<String> emailUniche = nuoveRecensioni.map((r) => r.cliente.email).toSet();
      List<Clienti> nuoviClienti = emailUniche.map((email) => Clienti(email)).toList();

      clienti.assignAll(nuoviClienti);
      return nuoveRecensioni;

    } else {
      print('Server responded with status: ${response.statusCode}');
      print('Messaggio del server: ${response.body}');
      throw Exception('Errore nel recupero delle recensioni: ${response.statusCode}');
      return [];

    }
  } catch (e) {
    print('Eccezione catturata: $e');
    throw Exception('Errore di connessione: $e');
  }

}




// Funzione per recuperare il menù di un ristorante
Future<List<Piatti>> fetchMenu(int ristoranteId) async {
  // URL dell'API che restituisce il menù di un ristorante

  //IP del WIFI di casa
  //final response = await http.get(Uri.parse('http://192.168.8.130/android/apiA.php?action=recuperaMenu&ristorante_id=$ristoranteId'));

  //IP di Hotspot di cellulare
  final response = await http.get(Uri.parse('http://10.148.3.95/android/apiA.php?action=recuperaMenu&ristorante_id=$ristoranteId'));

  // Verifica che la richiesta sia andata a buon fine (status code 200)
  if (response.statusCode == 200) {
    // Se la richiesta è andata a buon fine, decodifica il JSON
    List<dynamic> data = jsonDecode(response.body);

    // Mappa i dati ricevuti alla lista di oggetti Piatti
    return data.map((item) {
      return Piatti.fromJson(item);  // Usa la funzione `fromJson` per ogni piatto
    }).toList();
  } else {
    // In caso di errore, lancia un'eccezione
    throw Exception('Failed to load menu');
  }
}

