<?php 
    $TMDB_key = "ea511dd3e9897ea0212c8b74fdea23c7";
    $endPointTMDB = "https://api.themoviedb.org/3/movie/upcoming";
    $urlAllFilm = $endPointTMDB . "?api_key=" . $TMDB_key;
    
    #impost l'header della risposta
    header('Content-Type: application/json');

    $curl = curl_init(); 
    curl_setopt($curl, CURLOPT_URL, $urlAllFilm); #url impostato
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); #restituisi il risultato come stringa
    $result = curl_exec($curl);
    #leggo  il risultato
    $json = json_decode($result, true); #json_decode decodifica una stringa json, se specifico true gli oggetti json vengono restituiti come array associativi
    #elimino la risorse allocate
    curl_close($curl);
    #formatto il json
    $new_json = array();
    $new_json = $json['results'];
    echo json_encode($new_json);
?>