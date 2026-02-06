<?php
// Include il file di configurazione del database
function getPDOConnection() {
    try {
        // Connessione al database usando i parametri definiti nel file di configurazione(per sicurezza)
        $pdo = new PDO("mysql:host=localhost;dbname=android;charset=utf8mb4", "root", "");
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        //$pdo->exec("SET NAMES 'utf8mb4'"); 
        return $pdo;
    } catch (Exception $e) {
        // Gestisci gli errori di connessione al database
        die("Errore di connessione al database: " . $e->getMessage());
    }
}    
?>
