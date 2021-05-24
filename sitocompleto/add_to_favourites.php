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
        $img = basename(mysqli_real_escape_string($conn, $_GET['img'])); 
        $tit = mysqli_real_escape_string($conn, $_GET['title']);
        $username = mysqli_real_escape_string($conn, $_SESSION['username']);

        $query = "INSERT INTO users_favourites_movies(username,locandina,titolo) value('$username','$img','$tit')";
        $res = mysqli_query($conn, $query);

        if($res)
            echo json_encode(array("log" => true , "addFavourites" => true, "username" => $username, "film_aggiunto" => $tit));
        else
            echo json_encode(array("log" => true , "addFavourites" => false));
        
        mysqli_close($conn);
    }
    else echo json_encode(array("log" => false));
?>