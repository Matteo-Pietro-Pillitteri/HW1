<?php
    session_start();

    if(isset($_SESSION['username']) && isset($_SESSION['email'])){
        #impost l'header della risposta
        header('Content-Type: application/json');
        #mi collego al database
        require_once 'dbconfig.php';
        $cinema = $_GET['q'];
        #costruisco la query 
        $query = "SELECT P.username AS user , P.nome AS nome , P.cognome AS cognome FROM persona P  JOIN likes_cinema L ON P.id_persona = L.id_persona WHERE L.cod = '$cinema' ";
        #eseguo la query
        $res = mysqli_query($conn, $query);
        $json[] = array('log' => true);
        #leggo le righe
        while($row = mysqli_fetch_assoc($res)){
            $json[]= $row;
        }
        echo json_encode($json);
        mysqli_free_result($res);
        mysqli_close($conn);
    }
    else{
        $json_array[] = array('log' => false, 'error' => 'loggati per mettere like');
        $json_array[] = array('error' => 'loggati per mettere like');
        echo json_encode($json_array);
    }
?>