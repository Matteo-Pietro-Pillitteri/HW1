
<?php 
    #avvio la sessione
    session_start();
    #verifico l'accesso
    if(isset($_SESSION['username']) && isset($_SESSION['email']) && isset($_SESSION['nome']) && isset($_SESSION['cognome']))
    { 
      header("Location: homepage.php");
      exit;
    }

  #verifico l'esistenza di dati POST
  if(isset($_POST['nome']) && isset($_POST['cognome']) && isset($_POST['email']) && isset($_POST['password']) 
    && isset($_POST['conferma'])  && isset($_POST['acconsenti']) && ($_POST['chisono'] == 'lavoratore' || $_POST['chisono'] == 'persona')){
 
    $conn = mysqli_connect("localhost", "root", "", "dinos_cinema") or die(mysqli_error($conn));
    #creo un array degli errori
    $error = array();

    if(strlen($_POST["password"])< 8) $error[] = "Caratteri password insufficenti";
    if(!preg_match('/[\$\@\#\!\?\*\+\.\&\%\(\)\_\:\,\;\/\|\=\-\']+/i', $_POST['password'])) $error[] = "La password non contiene nessun carattere speciale";
    if(strcmp($_POST["password"], $_POST["conferma"])) $error[] = "Le password non coincidono";
  
    if($_POST['chisono'] == 'lavoratore'){
      $email = mysqli_real_escape_string($conn, $_POST['email']);
      $query = "SELECT email FROM impiegato WHERE email = '$email'";
      $res = mysqli_query($conn, $query);

      if(mysqli_num_rows($res) > 0) $error[] ="Email gia' in uso tra i dipendenti del cinema";
      else{
        if(isset($_POST['cf'])){
          $cf = mysqli_real_escape_string($conn, $_POST['cf']);
          $query = "SELECT cf FROM impiegato WHERE cf = '$cf'";
          $res = mysqli_query($conn, $query);
          if(mysqli_num_rows($res) < 0 ) $error[] = "Codice fiscale non registrato nel database";
        }
        else $error[] = "Codice fiscale non effettivamente settato";
      }
    }

    if($_POST['chisono'] == 'persona'){
      if($_POST['birthday'] == 0) $error[] = "Nessuna data di compleanno selezionata";

      $email = mysqli_real_escape_string($conn, $_POST['email']);
      $query = "SELECT email FROM persona WHERE email = '$email'";
      $res = mysqli_query($conn, $query);
      if(mysqli_num_rows($res) > 0) $error[] ="Email gia' in uso tra gli utenti";
      else{
        if(isset($_POST['username'])){
          if(!ctype_upper($_POST['username'][0])) $error[] = "Username non inizia con lettera maiuscola";
          if(strlen($_POST['username']) < 5) $error[] = "Username inferiore a 5 caratteri";
          $username = mysqli_real_escape_string($conn, $_POST['username']);
          $query = "SELECT username FROM persona WHERE username = '$username'";
          $res = mysqli_query($conn, $query);
          if(mysqli_num_rows($res) > 0) $error[] = "Username gia' in uso";
        }
        else $error[] = "Username non effettivamente settato";
      }
    }

    $errori = count($error);
    print_r ($error);

    if(count($error) == 0){
      $nome = mysqli_real_escape_string($conn, $_POST['nome']);
      $cognome = mysqli_real_escape_string($conn, $_POST['cognome']);
      $password = mysqli_real_escape_string($conn, $_POST['password']);
      #cifro la password prima di inserirla nel database
      $password = password_hash($password, PASSWORD_BCRYPT);
      $birthday = mysqli_real_escape_string($conn, $_POST['birthday']);
      
      if($_POST['chisono'] == 'lavoratore'){
        $query = "UPDATE impiegato SET nome = '$nome' ,cognome = '$cognome',email = '$email', password = '$password' WHERE cf = '$cf'";
        #la query insert restituisce un booleano
        if(mysqli_query($conn, $query)){
          $_SESSION['email'] = $_POST['email'];
          $_SESSION['nome'] = $_POST['nome'];
          $_SESSION['cognome'] = $_POST['cognome'];
          $_SESSION['cf'] = $_POST['cf'];
          mysqli_close($conn);
          header("Location: homepage.php");
          exit;
        }
      }else{
        
        switch ($_POST['chefaccio']){
          case 'seleziona':
            $query = "INSERT INTO persona(username,nome,cognome,email,password,birthday) VALUES('$username','$nome', '$cognome', '$email', '$password', '$birthday')";

            if(mysqli_query($conn, $query)){
              $_SESSION['username'] = $_POST['username'];
              $_SESSION['email'] = $_POST['email'];
              $_SESSION['nome'] = $_POST['nome'];
              $_SESSION['cognome'] = $_POST['cognome'];
              mysqli_close($conn);
              header("Location: homepage.php");
              exit;
            }
            break;

          case 'lavoratore':
            $tipologia = mysqli_real_escape_string($conn, $_POST['job']);
            $query = "INSERT INTO persona(username,nome,cognome,email,password,birthday) VALUES('$username','$nome', '$cognome', '$email', '$password', '$birthday')";
            $estrai = "SELECT id_persona FROM persona WHERE username = '$username'";
            
            $res = mysqli_query($conn, $query);
            if($res){
              $res = mysqli_query($conn, $estrai);
              $row = mysqli_fetch_assoc($res);
              $id_persona = $row['id_persona'];
              $query2 = "INSERT INTO lavoratore(id_persona,categoria) VALUES('$id_persona','$tipologia')";
              if(mysqli_query($conn, $query2)){
                $_SESSION['username'] = $_POST['username'];
                $_SESSION['email'] = $_POST['email'];
                $_SESSION['nome'] = $_POST['nome'];
                $_SESSION['cognome'] = $_POST['cognome'];
                mysqli_close($conn);
                header("Location: homepage.php");
                exit;
              }
            }
            break;
        
          case 'studente':
            $istituto = mysqli_real_escape_string($conn, $_POST['istituto']);
            $query = "INSERT INTO persona(username,nome,cognome,email,password,birthday) VALUES('$username','$nome', '$cognome', '$email', '$password', '$birthday')";
            $estrai = "SELECT id_persona FROM persona WHERE username = '$username'";
            
            $res = mysqli_query($conn, $query);
            if($res){
              $res = mysqli_query($conn, $estrai);
              $row = mysqli_fetch_assoc($res);
              $id_persona = $row["id_persona"];
              $query2 = "INSERT INTO studente(id_persona,istituto) VALUES ('$id_persona', '$istituto')";
              if(mysqli_query($conn, $query2)){
                $_SESSION['username'] = $_POST['username'];
                $_SESSION['email'] = $_POST['email'];
                $_SESSION['nome'] = $_POST['nome'];
                $_SESSION['cognome'] = $_POST['cognome'];
                mysqli_close($conn);
                header("Location: homepage.php");
                exit;
              }
            }

            break;

          case 'both':
            $tipologia = mysqli_real_escape_string($conn, $_POST['job']);
            $istituto = mysqli_real_escape_string($conn, $_POST['istituto']);
            $query = "INSERT INTO persona(username,nome,cognome,email,password,birthday) VALUES('$username', '$nome', '$cognome', '$email', '$password', '$birthday')";
            $estrai = "SELECT id_persona FROM persona WHERE username = '$username'";
           
            $res = mysqli_query($conn, $query);
            if($res){
              $res = mysqli_query($conn, $estrai);
              $row = mysqli_fetch_assoc($res);
              $id_persona = $row["id_persona"];
              $query2 = "INSERT INTO studente(id_persona,istituto) VALUES ('$id_persona', '$istituto')";
              $query3 = "INSERT INTO lavoratore(id_persona,categoria) VALUES('$id_persona','$tipologia')";
              if(mysqli_query($conn, $query2) && mysqli_query($conn, $query3)){
                $_SESSION['username'] = $_POST['username'];
                $_SESSION['email'] = $_POST['email'];
                $_SESSION['nome'] = $_POST['nome'];
                $_SESSION['cognome'] = $_POST['cognome'];
                mysqli_close($conn);
                header("Location: homepage.php");
                exit;
              }
            }

            break;
        }
      }
    }
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
    <script src="signup.js" defer="true"> </script>    <!-- QUIIIIIII --> 
  </head>
     
  <body>

    <nav> <!-- flex conteiner-->
      <div id="dino"> <!-- flex item nav--> 
        <img id="logo" src="images/dinopixel.png" >  
        Dino's cinema 
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

        <h1>Entra nella nostra community<br/> 
        <strong>Diventa anche tu un dino!</strong>
        </h1>
        <img class="logo" src="images/dinopixel.png" >  

        <?php
          if(isset($errore)) #se la variabile errore e' stata settata
          {
            echo "<p class='error'>";
            echo "Credenziali non valide: controlla l'email e la password";
            echo "</p>";
          }
         ?>

        <form name="signup" method='POST'>
          <label>Nome <input type='text' name='nome'></label>
          <label>Cognome <input type='text' name='cognome'></label>
          <label>E-mail <input type='text' name='email'></label>
          <span> </span>
          <label>Password <input type='password' name='password'></label>
          <span> </span>
          <label>Conferma password<input type='password' name='conferma'></label>
          <span> </span>
          <label class='hidden'>Inserisci un username <input type='text' name='username'></label>
          <span> </span>
          <label>Iscriviti come : <select name='chisono' > <option value="seleziona" selected='selected'>Seleziona qualcosa..</option> <option value="lavoratore">Lavoro per Dino's Cinema</option> <option value="persona">Utente</option> </select></label>
          <label class='hidden'>Codice fiscale <input type='text' name='cf'></label>
          <span> </span>
          <label>Data di nascita <input type='date' name='birthday'></label>
          <label class='hidden'>Opzionale: Studi, lavori? <select name='chefaccio'> <option value="seleziona" selected='selected'>Seleziona qualcosa.. </option> <option value="lavoratore">Lavoro </option> <option value="studente">Studio </option> <option value="both">Entrambi </option> </select> </label>
          <label class='hidden'>Categoria <input type='text' name='job'></label>
          <label class='hidden'>Istituto <input type='text' name='istituto'></label>
          <label>Acconsenti di fornire dati personali <input type='checkbox' name='acconsenti'></label>
          <label>&nbsp;<input type='submit' value="Iscriviti"></label>
        </form>
        <h1>Hai gia un account? <a href="login.php">Accedi</a> </h1>
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