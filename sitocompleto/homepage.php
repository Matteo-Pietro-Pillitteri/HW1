<?php 
  session_start();
  // verifico se l'utente e' loggato
  if(isset($_SESSION['email']) && isset($_SESSION['nome']) && isset($_SESSION['cognome'])){
    //setto un flag
    $log = true;
    if(isset($_SESSION['cf']))  $joblog = true;
    else if(isset($_SESSION['username']) ) $userlog = true; 
  }
?>

<html>
<!--codice html della mhw1 con eventuali modifiche-->
  <head>
    <title> dinoscinema_homepage </title>
    <meta charset="utf-8" >
    <meta name="viewport" content="width=device-width, initial-scale=1"> <!--4Mobile--> 
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
    <link rel="stylesheet" href="homepage.css">  <!--collegamento al mio css-->
    <script src="calendar.js" defer="true"></script>
    <script src="logo.js" defer="true"></script>
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
        <a href="contattaci.php">Contatti</a>
        <a href="film.php">Film</a>
        <?php
          if(isset($joblog)) echo "<a href='staff.php' >Staff</a>";
          if(isset($log))   echo "<a id='logOff' href='logout.php'>Logout</a>";
          else echo "<a id='logOn' href='login.php'>Login</a>";          
        ?>
      </div>
    </nav>

    <header>
      
      <div id="headerDiv">
        <h1> The new cinema experience <br/> 
          <strong> Dino's cinema </strong>  <br/> <br/>
        </h1>

        <div id="button">
          <?php
            if(isset($log)) echo "<h3 id='sub'> <a href='logout.php' > <em>Logout</em></a> </h3>";
            else echo "<h3 id='sub' > <a href='signup.php'> <em>Subscribe</em></a> </h3>";
          ?>
          <h3 id="info"> <em>Info e orari</em> </h3>
        </div>
      </div> 
      
      <div id="freccia">
        <a href="#saluti"></a>
      </div>

    </header>

    <section> <!-- Flex conteiner, con direction: column-->
     
    <div id='saluti' >
      <?php 
        // verifico se l'utente e' loggato
        if(isset($log)){
          if(isset($userlog))
            echo "<h3> Bentornato  " . $_SESSION["username"] ."</h3>";
          else 
            echo "<h3> Bentornato  " . $_SESSION["nome"] ." " . $_SESSION['cognome'] ."</h3>";

          echo "<a href=logout.php> Vuoi uscire dalla sessione? </a>";
        }
      ?>
    </div>

      <div id="modalView" class='hidden'>
        <iframe src="https://calendar.google.com/calendar/embed?height=550&amp;wkst=2&amp;bgcolor=%2300bd4f&amp;ctz=Europe%2FRome&amp;src=MGo1ZXZyZG0xc2JzY3BiNGludGZ0bTQ4dTBAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ&amp;src=aXQuaXRhbGlhbiNob2xpZGF5QGdyb3VwLnYuY2FsZW5kYXIuZ29vZ2xlLmNvbQ&amp;color=%23E67C73&amp;color=%230B8043&amp;showTitle=1&amp;title=Orari%20di%20apertura%2Fchiusura%20ed%20eventi&amp;showDate=1&amp;showPrint=0&amp;showTabs=0&amp;showTz=0&amp;showCalendars=0"  width="670" height="480" frameborder="0" scrolling="no" ></iframe>  <!-- google calendar-->
      </div>

      <div class="introduction"> <!-- flex item section-->
        <h1>Immergiti nel mondo del cinema!</h1>
        <p>
        Scopri i nostri cinema e goditi tutti i migliori 
        titoli della cinematografia mondiale. 
        Ogni giorno hai la possibilità di scegliere tra piu' titoli
        e con la possibilità di scegliere tra diverse fasce orarie. 
        Dino's cinema garantisce qualita, pulizia e comodita, provare per credere!
        </p>
      </div>
          
      <div class="blockinsection"><!-- flex item section-->
        <img src="images/cinema.jpg" >
        <h3> Cinema </h3>
        <p> Piu' di 10 sedi in tutta Italia, trova quello piu' vicino a te! <br/>
        <a> Clicca qui! </a>
        </p>
      </div>
          
      <div class="blockinsection" ><!-- flex item section--> 
        <img src="images/sale.jpg">
        <h3>Sale </h3>
        <p>
        Famose in tutta Italia per il loro design unico. <br/> 
        Puoi vivere una esperienza di cinema unica <a>prenotando</a> 
        un posto  nelle nostre 'relax room', o nelle 'experience room'. 
        <br/> Dino's cinema non finira' mai di stupirti  <br/>
        <a>Scopri di piu'!</a>
        </p>
      </div>
          
      <div class="blockinsection" ><!-- flex item section-->
        <img src= "images/novita.jpg">
        <h3>Novità del mese</h3>
        <p>
        Dino's cinema garantisce continuamente nuovi contenuti adatti a tutti i gusti! <br/>
        Scopri tutte i titoli del giorno nella tua città con un <a href="film.html">click!</a>
        </p>
      </div>

      <div id="sottosezione">
    
        <div> <!--flex item della sottosezione-->
          <h1> Chi siamo </h1>
          <p>
          La catena dei cinema di marchio Dino's nasce nel 2020 <br/>
          e ha come obiettivo quello di offrire un massimo confort<br/>
          ai clienti, facendoli sentire a casa solo!. Nelle nostre sale <br/> 
          sono proiettati diversi nuovi titoli a diversi orari e tutti i giorni! <br/>
          <em><a>Vieni a trovarci!  </a> </em>
          </p>
          <a> <img class="icon" src = "images/positionicon.jpg" > </a>
        </div>
              
        <div> <!-- flex item della sottosezione-->
          <h1>Diventa un dino!</h1>
          <p> Inscriviti alla nostra newsletter per essere ogni giorno informato e <br/>usufruire di offerte esclusive.E' facile, unisciti a noi! </p>
          <a>  <img class="icon" src= "images/mailicon.jpg" > </a>
        </div>

      </div>

    </section>
          
    <footer> <!-- flex conteiner-->
            
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