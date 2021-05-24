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
      $operazione = mysqli_real_escape_string($conn, $_GET['op']);
      #costruisco le query in base al tipo di operazione
  
      switch($operazione){
        case 'insertFilm':
            $regista = mysqli_real_escape_string($conn, $_GET['q0']);
            $titolo = mysqli_real_escape_string($conn, $_GET['q1']);
            $locandina = mysqli_real_escape_string($conn, $_GET['q2']);
            $trama = mysqli_real_escape_string($conn, $_GET['q3']);
            
            $query = "INSERT INTO film(regista,titolo,locandina,trama) VALUES('$regista', '$titolo', '$locandina', '$trama')";
            $res = mysqli_query($conn, $query) or die (mysqli_error($conn));

            if($res){
                $query = "SELECT regista,titolo,locandina,trama FROM film WHERE regista='$regista' AND titolo = '$titolo'";
                $res = mysqli_query($conn, $query) or die (mysqli_error($conn));
                $json = array();
                $json[] = array('operazione' => $operazione);
                while($row = mysqli_fetch_assoc($res)){
                    $json[]= $row;
                }
                echo json_encode($json);  
            }
            
            mysqli_free_result($res);
            mysqli_close($conn);
            exit;
        
        break;
  
        case 'deleteFilm':
            $regista = mysqli_real_escape_string($conn, $_GET['q0']);
            $titolo = mysqli_real_escape_string($conn, $_GET['q1']);
            
            $estrai = "SELECT regista,titolo,locandina,trama FROM film WHERE regista = '$regista' AND titolo = '$titolo'";
            $res = mysqli_query($conn, $estrai) or die (mysqli_error($conn));
            $json = array();
            $json[] = array('operazione' => $operazione);
            while($row = mysqli_fetch_assoc($res)){
                $json[]= $row;
            }

            $delete = "DELETE FROM film WHERE regista = '$regista' AND titolo = '$titolo'";
            $res = mysqli_query($conn, $delete) or die (mysqli_error($conn));
            if($res){
                echo json_encode($json);  
            }
            
            mysqli_close($conn);
            exit;
        
        break;
        
        case 'insertSede':
            $cod = mysqli_real_escape_string($conn, $_GET['q0']);
            $nome = mysqli_real_escape_string($conn, $_GET['q1']);
            $regione = mysqli_real_escape_string($conn, $_GET['q2']);
            $citta = mysqli_real_escape_string($conn, $_GET['q3']);
            $tred = mysqli_real_escape_string($conn, $_GET['q4']);
            $disabili = mysqli_real_escape_string($conn, $_GET['q5']);
            $parcheggio = mysqli_real_escape_string($conn, $_GET['q6']);
            $relax = mysqli_real_escape_string($conn, $_GET['q7']);
            $logo = mysqli_real_escape_string($conn, $_GET['q8']);
            
            $query = "INSERT INTO cinema(cod,nome,regione,città,tred,posti_disabili,parcheggio,area_relax,img) VALUES('$cod', '$nome', '$regione', '$citta', '$tred' , '$disabili', '$parcheggio', '$relax', '$logo')";
            $res = mysqli_query($conn, $query) or die (mysqli_error($conn));

            if($res){
                $query = "SELECT * FROM cinema WHERE cod = '$cod'";
                $res = mysqli_query($conn, $query) or die (mysqli_error($conn));
                $json = array();
                $json[] = array('operazione' => $operazione);
                while($row = mysqli_fetch_assoc($res)){
                    $json[]= $row;
                }
                echo json_encode($json);  
            }
            
            mysqli_free_result($res);
            mysqli_close($conn);
            exit;
        
        break;

        case 'deleteSede':
            $cod = mysqli_real_escape_string($conn, $_GET['q0']);
            
            $estrai = "SELECT * FROM cinema WHERE cod = '$cod'";
            $res = mysqli_query($conn, $estrai) or die (mysqli_error($conn));
            $json = array();
            $json[] = array('operazione' => $operazione);
            while($row = mysqli_fetch_assoc($res)){
                $json[]= $row;
            }
              
            $delete = "DELETE FROM cinema WHERE cod = '$cod'";
            $res = mysqli_query($conn, $delete) or die (mysqli_error($conn));
            if($res){
                echo json_encode($json);  
            }
         
            mysqli_close($conn);
            exit;
        break;
      }
  
    }
    header("Location: homepage.php");
    exit;
    
  
?>