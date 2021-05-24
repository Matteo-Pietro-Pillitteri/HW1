<?php
    #anche un utente non loggato puo' aggiungere ai preferiti ma una volta cambiata pagina li perdera. Un untente
    #loggato invece salvera i suoi preferiti all'interno del database, rendendoli "permanenti" fin quando vuole.

    session_start(); 
    #impost l'header della risposta
    if(isset($_SESSION['username']) && isset($_SESSION['email'])){
       header('Content-Type: application/json');
       #mi collego al database
       require_once 'dbconfig.php';
        #costruisco la query 
        $username = mysqli_real_escape_string($conn, $_SESSION['username']);

        $query = "SELECT locandina,titolo FROM users_favourites_movies WHERE username = '$username'";
        $res = mysqli_query($conn, $query);

        if($res){
           # echo json_encode(array("log" => true , "addFavourites" => true, "username" => $username, "film_aggiunto" => $tit));
           $json = array();
           while($row = mysqli_fetch_assoc($res)){
             $json[]= $row;
           }
           echo json_encode($json);
        }
        
        mysqli_close($conn);
    }
    else echo json_encode(array("log" => false, "fetching_favourites" => false));
?>