<?php
    $SpotifyID = '159a3880bf1f4adab3aa681bb8b33389';
    $secretID = 'db95a3d882ec42c9a85b5501d82bfd33'; 
    header('Content-Type: application/json');

    $curl = curl_init(); 
    curl_setopt($curl, CURLOPT_URL, "https://accounts.spotify.com/api/token"); #url impostato
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); #restituisi il risultato come stringa
    curl_setopt($curl, CURLOPT_POST, 1); #invio dati tramite POST
    curl_setopt($curl, CURLOPT_POSTFIELDS,  'grant_type=client_credentials&client_id=' . $SpotifyID . '&client_secret=' . $secretID); #imposto il body
    curl_setopt($curl, CURLOPT_HTTPHEADER, array('Authorization: Basic ' .base64_encode($SpotifyID . ":" . $secretID))); #imposto l'autorizzazione
    #leggo  il risultato
    $token = json_decode(curl_exec($curl), true); #json_decode decodifica una stringa json, se specifico true gli oggetti json vengono restituiti come array associativi
    #elimino la risorse allocate
    curl_close($curl);
    echo json_encode($token);
?>