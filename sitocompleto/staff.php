
<?php 
  session_start();
  // verifico se il dipendente e' loggato
  if(!isset($_SESSION['cf'])){
    header("Location: homepage.php");
    exit;
  }

  if(isset($_SESSION['email']) && isset($_SESSION['nome']) && isset($_SESSION['cognome'])){
    $log = true;
    if(isset($_SESSION['cf']))  $joblog = true;
  }
?>

<html>
  <head>
    <title>dinoscinema_staff</title>
    <meta charset="utf-8" >
    <meta name="viewport" content="width=device-width, initial-scale=1"> <!--4Mobile--> 
    <link rel="stylesheet" href="homepage.css">  <!--collegamento al css del layout generale-->
    <link rel="stylesheet" href="film.css"> <!-- collegamento al css relativo alla sezione dedicata ai film-->
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
    <script src="staff.js" defer="true"></script>
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
          if(isset($joblog)) echo "<a>Staff</a>";
          if(isset($log))   echo "<a id='logOff' href='logout.php'>Logout</a>";
          else echo "<a id='logON' href='login.php'>Login</a>";          
        ?>
      </div>
    </nav>

    <!--<header class="classicheader"> 
     
    </header>
-->


    <section> 
      <div class="introduction"> <!-- flex item section-->
        <h1>Operazioni frequenti e utili a fini statistici!</h1>
        <p>
          Inserisci i dati per le deteterminate operazioni e visualizza i risultati sulla destra. <br/>
          Esempi: <br/>
          p1 --> 100 <br/>
          p3 --> 101 <br/>
          p4 --> 25, 21-12-2020 
        </p>
      </div>
      
      <div id="elaborate">
        <div class='halfElaboration'> 
            <h3> Scegli operazione </h3>

            
            <div data-operation = "p0" class="operation">
                <p>Mostra cinema con il maggior numero di sale </p>
                <h6> </h6>
                <div class="hidden insert">
                    <h6 class="underline">Mostra risultato »</h6>
                </div>
            </div>

            <div data-operation = "p1" class="operation">
                <p>Numero di studenti per istituto scolastico o facoltà che hanno comprato almeno un biglietto in un determinato DINO'S CINEMA </p>
                <h6> </h6>
                <div class="hidden insert">
                    <label>Codice cinema <input type="text" name = "cod"> </label>
                    <h6 class="underline">Invia i dati »</h6>
                </div>
            </div>

            <div data-operation = "p3" class="operation">
              <p> Dato uno specifico cinema , mostrare le informazioni sugli impiegati omonimi che hanno lavorato o lavorano in quel cinema </p>
              <h6 > </h6>
              <div class="hidden insert">
                  <label>Codice cinema <input type="text" name = "cod"> </label>
                  <h6 class="underline">Invia i dati »</h6>
              </div>
            </div>
               
            <div data-operation = "p4" class="operation">
                <p> Mostrare tutte le informazioni sugli impiegati attuali, di età inferiore ad una soglia data, i quali lavorano nel cinema che ha venduto  il maggior numero  di  biglietti in un determinato giorno </p>
                <h6> </h6>
                <div class="hidden insert">
                  <label>Età <input type="text" name = "eta"> </label>
                  <label>Data <input type="date" name ="data"> </label>
                  <h6 class="underline">Invia i dati »</h6>
                </div>
            </div>
        </div>

        <div class='halfElaboration'>
          <h3> Risultati.. </h3>
          <div class="result"> </div>
        </div>
      </div>
    </section>

    <section>
      <div class="introduction"> <!-- flex item section-->
        <h1>Operazioni di inserimento e rimozione!</h1>
        <p>
          Aggiungi o elimina, film e sedi. 
        </p>
      </div>

      <div id="delicate">
        <div class='halfElaboration'>

          <div data-operation = "insertFilm" class="operation">
            <p> Inserisci un nuovo film direttamente da qui </p>
            <h6> Inserisci dati</h6>
            <form class="hidden" name="inserisciFilm">
              <label>Regista <input type='text' name='regista'></label>
              <label>Titolo in lingua originale<input type='text' name='titolo'></label>
              <label>Path locandina <input type='text' name='locandina'></label>
              <label>trama <input type='text' name='trama'></label>
            </form>
            <h6 class="hidden underline">Invia i dati »</h6>
          </div>

          <div data-operation = "deleteFilm" class="operation">
            <p> Elimina un film</p>
            <h6> Inserisci dati</h6>
            <form class="hidden" name="rimuoviFilm">
              <label>Regista <input type='text' name='regista'></label>
              <label>Titolo in lingua originale<input type='text' name='titolo'></label>
            </form>
            <h6 class="hidden underline">Invia i dati »</h6>
          </div>

          <div data-operation = "insertSede" class="operation">
            <p> Aggiungi una nuova sede direttamente da qui</p>
            <h6> Inserisci dati</h6>
            <form class="hidden" name="inserisciSede">
              <label>Codice cinema <input type='text' name='cod'></label>
              <label>Nome <input type='text' name='nome'></label>
              <label>Regione <input type='text' name='regione'></label>
              <label>Citta <input type='trama' name='citta'></label>
              <label>3d <input type='text' name='tred'></label>
              <label>Posti disabili <input type='text' name='disabili'></label>
              <label>Parcheggio <input type='text' name='parcheggio'></label>
              <label>Area relax <input type='text' name='relax'></label>
              <label>Logo <input type='text' name='logo'></label>
            </form>
            <h6 class="hidden underline">Invia i dati »</h6>
          </div>

          <div data-operation = "deleteSede" class="operation">
            <p> Elimina una sede</p>
            <h6> Inserisci dati</h6>
            <form class="hidden" name="rimuoviSede">
              <label>Codice cinema <input type='text' name='cod'></label>
            </form>
            <h6 class="hidden underline">Invia i dati »</h6>
          </div>

        </div>

        <div class='halfElaboration'>
          <h3>  </h3>
          <div class="result"> </div>
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