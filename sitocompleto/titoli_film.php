<?php
    #impost l'header della risposta
    header('Content-Type: application/json');
    #mi collego al database
    $conn = mysqli_connect('localhost', 'root', '', 'dinos_cinema');
    #costruisco la query 
    $query = "SELECT titolo FROM film";
    #eseguo la query
    $res = mysqli_query($conn, $query);
    #creo un array in cui vado a salvare ogni riga del result set, dato che ogni riga e' un array, l'array che sto creando sara' un array multidimensionale
    $json = array();
    #leggo le righe
    while($row = mysqli_fetch_assoc($res)){
        $json[]= $row; 
    }

    echo json_encode($json);
    mysqli_free_result($res);
    mysqli_close($conn);
?>