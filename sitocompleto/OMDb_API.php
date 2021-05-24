<?php 
    $endPointOMDb = 'http://www.omdbapi.com/';
    $OMDb_key = '6c66bae';
    $titolo = urlencode($_GET['titolo']);

    #let  url = endPointOMDb + "?apikey=" + OMDb_key + '&t=' + titoli[i];
    $url = $endPointOMDb . "?apikey=" . $OMDb_key . "&t=" . $titolo;
    #impost l'header della risposta
    header('Content-Type: application/json');

    $curl = curl_init(); 
    curl_setopt($curl, CURLOPT_URL, $url); #url impostato
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); #restituisi il risultato come stringa
    $result = curl_exec($curl);
    #leggo  il risultato
    $json = json_decode($result, true); #json_decode decodifica una stringa json, se specifico true gli oggetti json vengono restituiti come array associativi
    #elimino la risorse allocate
    curl_close($curl);

    echo json_encode($json);
?>