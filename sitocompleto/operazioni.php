<?php
  session_start();
  // nonostante la pagina staff puo' essere accessibile solo se e' loggato un dipendente
  // verifico nuovamente se il dipendente  e' loggato e quindi controllo se il codice fiscale (attributo presente solo nei dipendenti) e' in sessione

  if(isset($_SESSION['cf']) && isset($_SESSION['email']) && isset($_SESSION['nome']) && isset($_SESSION['cognome'])){
    #setto l'header della risposta che vogliamo ritornata
    header("Content-Type: application/json"); #voglio che questa pagina php restituisca un json 
    #mi collego al database
    require_once 'dbconfig.php';

    if(isset($_POST['cinema'])) $cod = mysqli_real_escape_string($conn, $_POST['cinema']);
    $cf = mysqli_real_escape_string($conn, $_SESSION['cf']);
    $operazione = mysqli_real_escape_string($conn, $_GET['q0']);
    #costruisco le query


    switch($operazione){
      case 'p0':
        $query = "CALL $operazione(@cod);";
        $res = mysqli_query($conn, $query) or die (mysqli_error($conn));
        
        if($res){
          $query = "SELECT @cod;";
          $res = mysqli_query($conn, $query) or die (mysqli_error($conn));
          $json = array();
          $json[] = array('operazione' => $operazione);
          while($row = mysqli_fetch_assoc($res)){
            $json[]= $row;
          }
    
          echo json_encode($json);  
          mysqli_free_result($res);
          mysqli_close($conn);
        }
        exit;
      
      break;

      case 'p1':
      case 'p3':
        $cod = mysqli_real_escape_string($conn, $_GET['q1']);
        $query = "CALL $operazione($cod);";
        $res = mysqli_query($conn, $query) or die (mysqli_error($conn));
    
        $json = array();
        $json[] = array('operazione' => $operazione);
        while($row = mysqli_fetch_assoc($res)){
            $json[]= $row;
        }
    
        echo json_encode($json);  
        mysqli_free_result($res);
        mysqli_close($conn);
        exit;
      break;
      
      case 'p4':
        $eta = mysqli_real_escape_string($conn, $_GET['q1']);
        $data = mysqli_real_escape_string($conn, $_GET['q2']);
        $query = "CALL $operazione($eta, '$data');";
        $res = mysqli_query($conn, $query) or die (mysqli_error($conn));
    
        $json = array();
        $json[] = array('operazione' => $operazione);
        while($row = mysqli_fetch_assoc($res)){
            $json[]= $row;
        }
       
        echo json_encode($json);  
        mysqli_free_result($res);
        mysqli_close($conn);
        exit;
      break;
    }

  }
  header("Location: homepage.php");
  exit
  
?>