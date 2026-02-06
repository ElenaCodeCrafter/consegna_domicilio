<?php
// definizione della classe Sessione
class Session { 
   //se la sessione non esiste, la inizializziamo
    public static function start() {
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }
    }

    //metodo che effettua il set parametrizzato delle variabili di sessione
    public static function set($key, $value) { //crea la variabile di sessione x memorizzare i dati di sessione (es. id del user)
        self::start();
        $_SESSION[$key] = $value;
    }
   //se la sessione è settata, la inizializzo, sennò la cancello
    public static function get($key, $default = null) {
        self::start();
        return isset($_SESSION[$key]) ? $_SESSION[$key] : $default;
    }
    //metodo che effettua la rimozione di una variabila della sessione
    public static function remove($key) {
        self::start();
        if (isset($_SESSION[$key])) {
            unset($_SESSION[$key]);
        }
    }
    //metodo che effettua la distruzione della sessione - totalmente
    public static function destroy() {
        self::start();
        session_destroy();
    }
    //metodo che effettua il controllo dell'inizializzazione della sessione
    public static function exists() {
        self::start();
        return !empty($_SESSION);
    }
}

?>