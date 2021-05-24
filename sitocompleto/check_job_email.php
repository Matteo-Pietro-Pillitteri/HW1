<?php
    #setto l'header della risposta che vogliamo ritornata
    header("Content-Type: application/json"); #voglio che questa pagina php restituisca un json 
    #mi collego al database
    require_once 'dbconfig.php';
    #vado a leggere il campo q inserito dall'utente e lo vado a prendere in GET
    $email = mysqli_real_escape_string($conn, $_GET['q']);
    #costruisco la query
    $query = "SELECT email FROM impiegato WHERE email='$email'";
    #eseguo la query
    $res = mysqli_query($conn, $query);
    #creo l'array da convertire in json che devo ritornare
    $json_array = array('exists' => mysqli_num_rows($res) > 0 ? true: false);
    $json = json_encode($json_array);
    echo $json;
    mysqli_close($conn);
?>