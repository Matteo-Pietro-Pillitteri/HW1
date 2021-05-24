
<?php 
  session_start();
  // verifico se l'utente e' loggato
  if(isset($_SESSION['email']) && isset($_SESSION['nome']) && isset($_SESSION['cognome'])){
    //setto un flag
    $log = true;
    if(isset($_SESSION['cf']))  $joblog = true;
    if(isset($_SESSION['username'])) $userlog = true;
  }
?>

<html>
  <head>
    <title>dinoscinema_sedi</title>
    <meta charset="utf-8" >
    <meta name="viewport" content="width=device-width, initial-scale=1"> <!--4Mobile--> 
    <link rel="stylesheet" href="homepage.css">  <!--collegamento al css del layout generale-->
    <link rel="stylesheet" href="film.css"> <!-- collegamento al css relativo alla sezione dedicata ai film-->
    <link rel="stylesheet" href="sedi.css">
    <link rel="stylesheet" href="staff.css">
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
    <script src="logo.js" defer="true"></script>
    <script src="sedi.js" defer="true"></script>
 </head>

  <body>
    <nav> <!-- flex conteiner-->
      <div id="dino">
        <img id="logo" src="images/dinopixel.png" >  
        <div id="logoWrite"> <!-- flex item nav--> 
          <p> Dino's cinema </p>
          <?php
            if(isset($log)) echo "<p>" . $_SESSION['nome'] . " " . $_SESSION['cognome'] . "</p>" ;
          ?>
        </div>
      </div>
  
      <div class="links"> <!-- flex item nav-->
        <a href="homepage.php">Home</a>
        <a href="sedi.php">Sedi</a>
        <a href="contattaci.php">Contattaci</a>
        <a href="film.php">Film</a>
        <?php
          if(isset($joblog)) echo "<a href='staff.php' >Staff</a>";
          if(isset($log))   echo "<a id='logOff' href='logout.php'>Logout</a>";
          else echo "<a id='logON' href='login.php'>Login</a>";          
        ?>
      </div>
    </nav>

    <header class="classicheader"> 
      <h1>Vienici a trovare <br/> 
      <strong>Dino's Cinema e' ovunque!</strong>
      </h1>
      <h6>Facci sapere cosa ne pensi di noi e come possiamo migliorare</h6>
    </header>


    <section> 
      
      <?php
        if (isset($userlog)) {
          echo '<input type="hidden" id="username" value="' . $_SESSION["username"] . '">';
       }
      ?>

      <div id="forSearch"> </div>
      
      <div id="inYourCity"> 

        <h6>Vuoi cercare direttamente nella tua citta? Clicca qui</h6>

        <div>

          <div class="sedehidden halfElaboration"> 
            <form name = "inserisci"> 
                <label>Regione: <input type="text" name = "regione"> </label>
                <label>Città: <input type="text" name = "citta"> </label>
                <h6 class="underline">Mostra Dino's Cinema nella tua città</h6>
            </form>
          </div>

          <div  class="sedehidden halfElaboration"> 
            
          </div>

        </div>

      </div>

      <div class="mainblock"> </div>
      <div id="modale" class="modalView sedehidden"> 
        <div class="content">  
         
        </div>
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