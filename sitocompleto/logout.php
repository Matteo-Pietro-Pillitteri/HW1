<?php
    #avvio la sessione per collegarmi alla sessione corrente, altrimenti session_destroy() non sa quale sessione chiudere
    session_start();
    #elimino la sessione
    session_destroy();
    header("Location: login.php");
    exit; 
?>