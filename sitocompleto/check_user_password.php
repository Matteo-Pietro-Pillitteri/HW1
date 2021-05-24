<?php
    #setto l'header della risposta che vogliamo ritornata
    header("Content-Type: application/json"); #voglio che questa pagina php restituisca un json 
    #mi collego al database
    require_once 'dbconfig.php';
    #vado a leggere il campo q inserito dall'utente e lo vado a prendere in GET
    $passowrd = mysqli_real_escape_string($conn, $_GET['q1']);
    $email = mysqli_real_escape_string($conn, $_GET['q2']);
    #costruisco la query
    $query = "SELECT * FROM persona WHERE email='$email'";
    $res = mysqli_query($conn, $query);

    if(mysqli_num_rows($res) > 0){ 
        $entry = mysqli_fetch_assoc($res);
        #creo l'array da convertire in json che devo ritornare
        $json_array = array('exists_password' => password_verify($passowrd, $entry['password'])? true: false);
        $json = json_encode($json_array);
        echo $json;
    }
    mysqli_close($conn);
?>