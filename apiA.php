<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once 'connessioneDB.php'; 

$method = $_SERVER['REQUEST_METHOD']; // Ottieni il metodo della richiesta
$action = null;

// Controlla il metodo della richiesta
if ($method === 'GET') {
    $action = $_GET['action'] ?? null; // Leggi `action` dai parametri url (in GET)
    //In GET il parametro passato in url si chiama "ristorante_id"
    $ristorante_id = $_GET['ristorante_id'] ?? null;  
} elseif ($method === 'POST') {
    $inputJSON = file_get_contents('php://input'); // Leggi il corpo della richiesta
    $data = json_decode($inputJSON, true);
    //In POST il parametro passato in body si chiama "id_ristorante"
    $ristorante_id = $data['id_ristorante'] ?? null; //id_ristorante

    // Debug per verificare il contenuto della richiesta POST
    if ($data === null) {
        error_log("Errore nella decodifica JSON: " . json_last_error_msg());
        http_response_code(400);
        echo json_encode(["error" => "Dati JSON non validi."]);
        exit;
    }
    //Verifico i dati ricevuti con POST
    error_log("Dati POST ricevuti: " . print_r($data, true));
    $action = $data['action'] ?? null; // Leggi `action` dal corpo JSON
} else {
    $ristorante_id = null;
    http_response_code(405); // Metodo non supportato
    echo json_encode(["error" => "Metodo HTTP non supportato."]);
    exit;
}

// Debug per controllare l'action
error_log("Metodo: $method, Azione: $action");

// Ottieni la connessione al database
$pdo = getPDOConnection();
/*
$inputJSON = file_get_contents('php://input'); //leggo in POST dal corpo della richiesta
$data = json_decode($inputJSON, true); // Decodifica i dati JSON

// Ottieni l'action dal body
$action = $data['action'] ?? null;
//$action = isset($_GET['action']) ? $_GET['action'] : null;

*/

switch ($action) {
    case 'recuperaRistoranti':
        recuperaRistoranti(); 
        break;

    case 'recuperaMenu':
        recuperaMenu($ristorante_id); //se non funziona togli $data e scommenta sora
        break;

    case 'recuperaRecensioni':
        recuperaRecensioni($ristorante_id);
        break;
        
    case 'aggiungiRecensioni':
      /*if ($method === 'POST') {
        
       } else {
        http_response_code(405); // Metodo non supportato
        echo json_encode(["error" => "Metodo non supportato per questa azione."]);
        echo "Metodo ricevuto: $method, Azione: $action, Ristorante ID: $ristorante_id";
       }
        */
        aggiungiRecensioni($ristorante_id); // Richiede POST
        break;

    default:
        http_response_code(400); // Bad Request
        echo json_encode(["error" => "Azione non valida o mancante."]);
        break;
}

function recuperaRistoranti(){
  try {
    global $pdo; // Rendi la variabile globale visibile
    // Query per recuperare tutti i ristoranti

    $stmt = $pdo->prepare("SELECT * FROM ristoranti");
    $stmt->execute();

    // Recupera i dati in formato associativo
    $ristoranti = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Restituisci i dati in formato JSON
    echo json_encode($ristoranti);
  } catch (PDOException $e) {
    // Gestione degli errori
    http_response_code(500);
    echo json_encode(["error" => "Errore nel caricamento dati: " . $e->getMessage()]);
   }
}

function recuperaMenu($ristorante_id){ 
    
    try {
        global $pdo;

        //recupera menù di un ristorante associato al suo id
       $ristorante_id = isset($_GET['ristorante_id']) ? intval($_GET['ristorante_id']) : 0;
       if ($ristorante_id === 0) {
        http_response_code(400);
        echo json_encode(["error" => "Parametro ristorante_id mancante o non valido."]);
        return;
        } 
        $menuTable = "";

        switch ($ristorante_id) {
          case 1:
              $menuTable = "menu_da_ciccio";  // Nome tabella per il ristorante 1
              break;
          case 2:
              $menuTable = "menu_da_karim";  // Nome tabella per il ristorante 2
              break;
          case 3:
              $menuTable = "menu_ako";  // Nome tabella per il ristorante 3
              break;
          // Aggiungi altri case per altri ristoranti, se necessario
          default:
              http_response_code(404);  // Ristorante non trovato
              echo json_encode(["error" => "Ristorante non trovato."]);
              return;
      }
      
        $stmt = $pdo->prepare("SELECT * FROM $menuTable");
        //$stmt->bindParam(':ristorante_id', $ristorante_id, PDO::PARAM_INT);
        $stmt->execute();
    
        // Recupera i dati in formato associativo
        $menu = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
        // Restituisci i dati in formato JSON
        echo json_encode($menu);
    } catch (PDOException $e) {
      // Gestione degli errori
      http_response_code(500);
      echo json_encode(["error" => "Errore nel caricamento dati: " . $e->getMessage()]);
  }
  }

  function getRecensioniTable($ristorante_id) {

    switch ($ristorante_id) {
        case 1: return "recensioni_da_ciccio";
        case 2: return "recensioni_da_karim";
        case 3: return "recensioni_ako";
        default:
            http_response_code(404);
            echo json_encode(["error" => "Ristorante non trovato."]);
            return null; // Indica un errore
    }
}

  function recuperaRecensioni($ristorante_id){
    //recupera recensioni di un ristorante associato al suo id
   
    try {
      global $pdo;
      $ristorante_id = isset($_GET['ristorante_id']) ? intval($_GET['ristorante_id']) : 0;
      if ($ristorante_id === 0) {
          http_response_code(400);
          echo json_encode(["error" => "Parametro ristorante_id mancante o non valido."]);
          return;
      }
      /*
      $recensioniPage = "";

        switch ($ristorante_id) {
          case 1:
              $recensioniPage = "recensioni_da_ciccio";  // Nome tabella per il ristorante 1
              break;
          case 2:
              $recensioniPage = "recensioni_da_karim";  // Nome tabella per il ristorante 2
              break;
          case 3:
              $recensioniPage = "recensioni_ako";  // Nome tabella per il ristorante 3
              break;
          // Aggiungi altri case per altri ristoranti, se necessario
          default:
              http_response_code(404);  // Ristorante non trovato
              echo json_encode(["error" => "Ristorante non trovato."]);
              return;
      }
              */

               // Ottieni il nome della tabella recensioni
        $recensioniPage = getRecensioniTable($ristorante_id);
        error_log("Tabella recensioni: " . $recensioniPage);
        if ($recensioniPage === null) {
            return; // Errore già gestito dalla funzione
        }

         // Query per recuperare le recensioni del ristorante specifico
       $stmt = $pdo->prepare("SELECT * FROM $recensioniPage JOIN clienti ON $recensioniPage.cliente_id = clienti.id JOIN ristoranti ON $recensioniPage.id_ristorante = ristoranti.id WHERE $recensioniPage.id_ristorante = :ristorante_id");
       // $stmt = $pdo->prepare("SELECT * FROM $recensioniPage JOIN clienti ON $recensioniPage.cliente_id = clienti.id "); 
       $stmt->bindParam(':ristorante_id', $ristorante_id, PDO::PARAM_INT);
       $stmt->execute();

       // Recupera i dati in formato associativo
       $recensioni = $stmt->fetchAll(PDO::FETCH_ASSOC);

       // Restituisci i dati in formato JSON
       echo json_encode($recensioni);
    } catch (PDOException $e) {
      // Gestione degli errori
      http_response_code(500);
      echo json_encode(["error" => "Errore nel caricamento dati: " . $e->getMessage()]);
  }
  }

  

 
  function aggiungiRecensioni($ristorante_id){
    error_log("Richiesta ricevuta");
    error_log("Metodo richiesta: " . $_SERVER['REQUEST_METHOD']);
    error_log("Action: " . $_POST['action']);
    error_log("Ristorante ID: " . $_POST['ristorante_id']);
    error_log("Dati RAW: " . file_get_contents("php://input"));
   
   
    // Controlla che i dati siano inviati con il metodo POST
      if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        echo "È un POST<br>";
        try{
            global $pdo;

            $ristorante_id = isset($_POST['id_ristorante']) ? intval($_POST['id_ristorante']) : 0;
            if ($ristorante_id === 0) {
               http_response_code(400);
               echo json_encode(["error" => "Parametro ristorante_id mancante o non valido."]);
               return;
              }
              /*
            // Decodifica dei dati ricevuti (se `$data` non è passato)
             if (empty($data)) {
              $inputJSON = file_get_contents("php://input");
               $data = json_decode($inputJSON, true);
             }
               */
              $inputJSON = file_get_contents('php://input');
              $data = json_decode($inputJSON, true);

             if (json_last_error() !== JSON_ERROR_NONE) {
                file_put_contents('debug.log', "Errore JSON: " . json_last_error_msg() . PHP_EOL, FILE_APPEND);
                http_response_code(400);
                echo json_encode(["error" => "Dati JSON non validi"]);
                exit;
                }

              file_put_contents('debug.log', print_r($data, true), FILE_APPEND);

             if (json_last_error() !== JSON_ERROR_NONE) {
              http_response_code(400);
              echo json_encode(["error" => "Dati JSON non validi", "details" => json_last_error_msg()]);
              exit;
             }

            error_log(print_r($data, true));

            $requiredParams = ['email', 'testo_recensione', 'numero_stelle', 'id_ristorante'];
             foreach ($requiredParams as $param) {
               if (!isset($data[$param]) || empty($data[$param])) {
                http_response_code(400); // Richiesta non valida
                echo json_encode(['success' => false, 'message' => "Parametro mancante o vuoto: $param"]);
                return;
               }
            }

            $email = $data['email'];
            $recensione = $data['testo_recensione'];
            $valutazione = $data['numero_stelle'];
            $ristorante_id = $data['id_ristorante']; // ID ristorante (parametro passato)
        
            // Ottiengo il nome della tabella recensioni
            $recensioniPage = getRecensioniTable($ristorante_id);
            if ($recensioniPage === null) {
                echo json_encode(['success' => false, 'message' => 'Ristorante non trovato']);
                return; // Errore già gestito dalla funzione
            }


           // 1. Trovo il cliente in base all'email
           $stmtCliente = $pdo->prepare("SELECT id FROM clienti WHERE email = :email");
           $stmtCliente->execute([':email' => $email]);
           $cliente = $stmtCliente->fetch(PDO::FETCH_ASSOC);

           if ($cliente) {
            // Cliente trovato, otteniamo il suo ID
              $clienteId = $cliente['id'];
           } else {
            // Cliente non trovato, lo aggiungiamo alla tabella `clienti`
              $stmtNuovoCliente = $pdo->prepare("INSERT INTO clienti (email) VALUES (:email)");
              $stmtNuovoCliente->execute([':email' => $email]);

            // Ottengo l'ID del nuovo cliente appena inserito
              $clienteId = $pdo->lastInsertId();
            }

           // Prepara la query SQL per l'inserimento
           $stmtRecensione = $pdo->prepare("INSERT INTO $recensioniPage (id_ristorante,cliente_id, data, testo_recensione, numero_stelle) 
                                VALUES (:id_ristorante, :cliente_id, NOW(), :testo_recensione, :numero_stelle)");
        
           // Esegui la query con i parametri
           $stmt->execute([
            ':id_ristorante' => $ristorante_id,
            ':cliente_id' => $clienteId,
            ':testo_recensione' => $recensione,
            ':numero_stelle' => $valutazione,
            
           ]);

        // Risposta JSON
        // Risposta di successo
          echo json_encode(['success' => true, 'message' => 'Recensione aggiunta con successo!']);
      }   catch (PDOException $e) {
             error_log("Errore: " . $e->getMessage());
             echo json_encode(['success' => false, 'message' => 'Errore: ' . $e->getMessage()]);
      } 
        // Risposta se la richiesta non è un POST
        
   }
   else { 
    echo "Non è un POST. Metodo: " . $_SERVER['REQUEST_METHOD'] . "<br>";
    echo json_encode(['success' => false, 'message' => 'Richiesta non valida.']);
   }
  }
  
    
  




?>