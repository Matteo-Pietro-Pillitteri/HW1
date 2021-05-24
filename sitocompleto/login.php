<?php
  #avvio la sessione
  session_start();
  #verifico l'accesso
  if(isset($_SESSION['email']) && isset($_SESSION['nome']) && isset($_SESSION['cognome'])){ 
    header("Location: homepage.php");
    exit;
  }

  #verifico l'esistenza di dati POST
  if(isset($_POST['email']) && isset($_POST["password"]) && ($_POST['accedicome'] == 'lavoratore' || $_POST['accedicome'] == 'persona'))
  {
    #se queste variabili sono settate, mi connetto al database
    $conn = mysqli_connect("localhost", "root", "", "dinos_cinema") or die(mysqli_error($conn));
    #faccio l'escape dell'input per evitare problemi di sql injection
    $email = mysqli_real_escape_string($conn, $_POST["email"]);
    $password = mysqli_real_escape_string($conn, $_POST["password"]);
    #cerco utenti dentro il database con quella email 
    #se la "select" --> accedicome e' settata con value = lavoratore allora vado a cercare nella tabella degli impiegati altrimenti nella tabella delle persone
    $query = $_POST['accedicome'] == 'lavoratore' ? "SELECT * FROM impiegato WHERE email = '$email'" : "SELECT * FROM persona WHERE email = '$email'";
    #eseguo la query
    $res = mysqli_query($conn, $query);
    #verifico la correttezza delle credenziali, se la query mi restituisce un risultato(max 1 perche la combinazione email e' univoca);
    if(mysqli_num_rows($res) > 0){
      $entry = mysqli_fetch_assoc($res);
      if(password_verify($_POST['password'], $entry['password'])){
        #se sono state impostate le credenziali esatte vado alla pagina home, impostando prima la variabile di sessione
        $_SESSION["email"] = $_POST["email"];
        $_SESSION['nome'] = $entry['nome'];
        $_SESSION['cognome'] = $entry['cognome']; 
        if(isset($entry['cf'])) $_SESSION['cf'] = $entry['cf']; 
        if(isset($entry['username'])) $_SESSION['username'] = $entry['username'];
        mysqli_close($conn);
        header("Location: homepage.php");
        exit; 
      }
      else $errorePassword = true;
    }
    else $erroreEmail = true;
  }
?>

<html>
  <head>
    <title>dinoscinema_login</title>
    <meta charset="utf-8" >
    <meta name="viewport" content="width=device-width, initial-scale=1"> <!--4Mobile--> 
    <link rel="stylesheet" href="homepage.css">  <!--collegamento al css del layout generale-->
    <link rel="stylesheet" href="film.css"> <!-- collegamento al css relativo alla sezione dedicata ai film-->
    <link rel="stylesheet" href="log.css">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Lora&family=Montserrat:wght@200&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@200&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Turret+Road:wght@300&display=swap" rel="stylesheet">
    <link rel="preconnect"  href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Audiowide&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@100&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Alef&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Ubuntu+Mono&display=swap" rel="stylesheet">
    <script src="controlloaccesso.js" defer="true"> </script>
  </head>
    
  <body>
    <nav> <!-- flex conteiner-->
      <div id="dino">
        <img id="logo" src="images/dinopixel.png" >  
        <div id="logoWrite"> <!-- flex item nav--> 
          <p> Dino's cinema </p>
        </div>
      </div>

      <div class="links"> <!-- flex item nav-->
        <a href="homepage.php">Home</a>
        <a href="sedi.php">Sedi</a>
        <a href="contattaci.php">Contattaci</a>
        <a href="film.php">Film</a>
        <a id="logOn" href="login.php">Login</a>
      </div>
    </nav>

    <section id="sectionLog">

      <div class="interactive">

        <h1>Non restare fuori<br/> 
        <strong>Vieni a vedere da vicino!</strong>
        </h1>

        <?php
          if(isset($erroreEmail)) echo "<p class='error'> Email non registrata </p>";
          if(isset($errorePassword)) echo "<p class='error'> Password non valida </p>";
         ?>

        <form name="login" method='POST'>
          <label>E-mail <input type='text'  name='email'></label>
          <span> </span>
          <label>Password <input type='password' name='password'></label>
          <span> </span>
          <label>Accedi come: <select name='accedicome' > <option value="seleziona" selected='selected'>Seleziona qualcosa..</option> <option value="lavoratore">Lavoro per Dino's Cinema</option> <option value="persona">Utente</option> </select></label>
          <label>&nbsp;<input type='submit' value="accedi"></label>
        </form>
        <h1>Non hai un account? <a href="signup.php">Iscriviti</a> </h1>
      </div>
    </section>

    
    <footer>
      <div id="infooter" > <!-- flex item footer-->
            
        <div>
          <h3>Contact us</h3> 
          <p>
          Indirizzo:<br/>
          Via della Rinascita 12 -Barrafranca (EN) 
          <a href="contattaci.php"> Telefono </a>
          Email: <br/> dinoscinema@hotmail.it 
          </p> 
        </div>
                
        <div>
          <h3> Acquisto biglietti </h3>
          <p>
          Online <br/>
          Via telefono <br/>
          Acquista e stampa
          </p>
        </div>
                
        <div>
          <h3> Account </h3>
          <a href="login.php"> Profilo </a> <br/>
          <a href="signup.php"> Crea nuovo profilo </a>
        </div>
                
        <div>
          <h3> Seguici su i Social </h3> 
          <p> 
          Ci trovi ovunque! Promozioni in piu' per te
          <br/> se ci segui su i nostri profili ufficiali. </p>
          <a> <img class="icon" src= "images/facebookicon.jpg"> </a>
          <a> <img class="icon" src = "images/instagramicon.jpg"> </a>
          <a> <img class="icon" src = "images/twittericon.jpg"> </a>
        </div>
  
      </div>
  
      <div id="information" > <!-- flex item del footer-->
        <a> Informativa sulla privacy</a>
        <a> Area legale </a>
        <a> Coockie e pubblicità</a>
        <a href="contattaci.php"> Affiliati </a>
        <p>
        Matteo Pietro Pillitteri O46002173<br/>
        Anno accademico 2020/2021
        </p>
      </div>

    </footer>

  </body>

</html>