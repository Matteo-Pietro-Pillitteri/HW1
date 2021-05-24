<?php
    session_start();

    if(isset($_SESSION['username']) && isset($_SESSION['email']) && isset($_SESSION['nome']) && isset($_SESSION['cognome'])){
        #setto l'header della risposta che vogliamo ritornata
        header("Content-Type: application/json"); #voglio che questa pagina php restituisca un json 
        #mi collego al database
        require_once 'dbconfig.php';
    
        $username = mysqli_real_escape_string($conn, $_SESSION['username']);
        $cod = mysqli_real_escape_string($conn, $_GET['q']);

        #costruisco le query
        $query = "SELECT P.username AS user , P.nome AS nome , P.cognome AS cognome , L.commento AS commento FROM persona P  JOIN comments_cinema L ON P.id_persona = L.id_persona WHERE L.cod = '$cod' ";
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
        $json_array[] = array('log' => false);
        $json_array[] = array('error' => 'loggati');
        echo json_encode($json_array);
    }
    
?>
