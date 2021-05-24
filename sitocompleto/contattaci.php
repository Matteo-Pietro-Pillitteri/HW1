
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
    <title>dinoscinema_contactus</title>
    <meta charset="utf-8" >
    <meta name="viewport" content="width=device-width, initial-scale=1"> <!--4Mobile--> 
    <link rel="stylesheet" href="homepage.css">  <!--collegamento al css del layout generale-->
    <link rel="stylesheet" href="film.css"> <!-- collegamento al css relativo alla sezione dedicata ai film-->
    <link rel="stylesheet" href="sedi.css">
    <link rel="stylesheet" href="staff.css">
    <link rel="stylesheet" href="contattaci.css">
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
    <script src="contattaci.js" defer="true"></script>
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
        <a hrer="contattaci.php">Contattaci</a>
        <a href="film.php">Film</a>
        <?php
          if(isset($joblog)) echo "<a href='staff.php' >Staff</a>";
          if(isset($log))   echo "<a id='logOff' href='logout.php'>Logout</a>";
          else echo "<a id='logON' href='login.php'>Login</a>";          
        ?>
      </div>
    </nav>

    <header class="classicheader"> 
      <h1>  <strong> Dino's Cinema e' una rete travolgente </strong> </h1>
    </header>


    <section> 
      <div class="introduction"> 
        <h1> Mettiti in contatto con noi, e' semplice! </h1>
        <p>
        Dino's Cinema collabora con molte aziende in tutta Italia, per offrire
        ai propri clienti servizi efficenti e soddisfacenti. Rappresenti un'impresa
        di pulizie, o ti occupi di un servizio di ristorazione ? Contattaci. Dino's Cinema
        ha bisogno anche di te.
        </p>
      </div>

      <div class="showLike"> <!-- metto questa classe perhe ha display flex e space-beetween -->
        <div id="contatti" class="otherdiv">

        </div>

        <div id="aziende" class="otherDiv">

        </div>
      <div>

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