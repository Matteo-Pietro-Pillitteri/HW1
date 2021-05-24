<?php
    #impost l'header della risposta
    header('Content-Type: application/json');

    require_once 'dbconfig.php';
    $time = mysqli_real_escape_string($conn, $_GET['time']);
    #filter_var - Filtra una variabile con un filtro specificato
    $time = filter_var($time, FILTER_SANITIZE_NUMBER_INT);
    $titolo = mysqli_real_escape_string($conn, $_GET['tit']);

    $query = "UPDATE film SET durata = $time WHERE titolo = '$titolo'";
    
    $res = mysqli_query($conn, $query);

    if($res)
        echo json_encode(array("film" => $titolo ,"set_durata" => true));    
    else 
        echo json_encode(array("film" => $titolo ,"set_durata" => false));

    mysqli_close($conn);
?>