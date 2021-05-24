<?php
  session_start();
  // verifico se l'utente e' loggato
  if(isset($_SESSION['username']) && isset($_SESSION['email']) && isset($_SESSION['nome']) && isset($_SESSION['cognome'])){
    #setto l'header della risposta che vogliamo ritornata
    header("Content-Type: application/json"); #voglio che questa pagina php restituisca un json 
    #mi collego al database
    require_once 'dbconfig.php';

    $username = mysqli_real_escape_string($conn, $_SESSION['username']);
    $cod = mysqli_real_escape_string($conn, $_GET['q']);
    #costruisco le query
    $query = "SELECT id_persona FROM persona WHERE username='$username'";
    $res = mysqli_query($conn, $query);
    $row = mysqli_fetch_assoc($res);
    $id_persona = mysqli_real_escape_string($conn, $row['id_persona']);

    $inserisci = "INSERT INTO likes_cinema(id_persona,cod) VALUES($id_persona, $cod)";
    #si attiva il trigger e vado a prendere il numero di likes
    $estrai = "SELECT likes,cod FROM cinema WHERE cod='$cod'";

    $res = mysqli_query($conn, $inserisci) or die (mysqli_error($conn));
    if($res){
        $res = mysqli_query($conn, $estrai);

        if(mysqli_num_rows($res) > 0){ 
            $entry = mysqli_fetch_assoc($res);
            #creo l'array da convertire in json che devo ritornare
            $json_array = array('log' => true, 'cod' => $entry['cod'], 'likes' => $entry['likes']);
            $json = json_encode($json_array);
            echo $json;
            mysqli_close($conn);
            exit;
        }
    }
        mysqli_close($conn);
  }
  $json_array = array('log' => false);
  echo json_encode($json_array);

?>