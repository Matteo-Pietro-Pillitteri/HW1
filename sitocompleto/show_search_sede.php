<?php
    #QUESTA OPERAZIONE E' DISPONIBILE A TUTTI 
    #impost l'header della risposta
    header('Content-Type: application/json');
    #mi collego al database
    require_once 'dbconfig.php';
    #costruisco la query 
    $citta = ucfirst(mysqli_real_escape_string($conn, $_GET['citta'])); #ucfirst converte in maiuscolo la prima lettera
    $regione = ucfirst(mysqli_real_escape_string($conn, $_GET['regione']));
    $query = "SELECT * FROM cinema WHERE città = '$citta' AND regione = '$regione'";
    #eseguo la query
    $res = mysqli_query($conn, $query);
    #creo un array in cui vado a salvare ogni riga del result set, dato che ogni riga e' un array, l'array che sto creando sara' un array multidimensionale
   
    if(mysqli_num_rows($res) > 0){
        $json = array("trovato" => true);
        echo json_encode(mysqli_fetch_assoc($res) + $json);
    }
    else{
        $json = array("trovato" => false);
        echo json_encode($json);
    }

    mysqli_free_result($res);
    mysqli_close($conn);
  
?>