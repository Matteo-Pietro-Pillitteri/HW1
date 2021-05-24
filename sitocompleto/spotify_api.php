<?php 
    $endPointSpotify = 'https://api.spotify.com/v1/search?query=';
    $token = $_GET['token'];
    $titolo = urlencode($_GET['titolo']);

    #impost l'header della risposta
    header('Content-Type: application/json');

    $url = $endPointSpotify . $titolo . '+soundtrack&type=playlist&limit=1';
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  
    curl_setopt($curl, CURLOPT_HTTPHEADER, array('Authorization: Bearer ' .$token));
    $result = curl_exec($curl);
    $json = json_decode($result, true);
    curl_close($curl);
    echo json_encode($json); 
?>