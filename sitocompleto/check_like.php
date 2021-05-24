<?php
    session_start();

    if(isset($_SESSION['username']) && isset($_SESSION['email'])){
        header("Content-Type: application/json"); #voglio che questa pagina php restituisca un json 
        #mi collego al database
        require_once 'dbconfig.php';
        $username = mysqli_real_escape_string($conn, $_SESSION['username']);
        #$json = array();
        #costruisco la query
        $query = "SELECT P.id_persona AS id, P.username AS username, L.cod AS cod FROM persona P JOIN likes_cinema L JOIN cinema C ON P.id_persona = L.id_persona AND L.cod = C.cod";
        #eseguo la query
        $json[] = array('log' => true);
        $res = mysqli_query($conn, $query);
        while($row = mysqli_fetch_assoc($res)){
            $json[]= $row;
          }
 
        echo json_encode($json);
        mysqli_free_result($res);
        mysqli_close($conn);
    }
    else{
        $json_array[] = array('log' => false);
        $json_array[] = array('error' => 'loggati per mettere like');
        echo json_encode($json_array);
    }
?>