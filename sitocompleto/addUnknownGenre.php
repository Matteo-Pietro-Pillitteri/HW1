<?php
    #impost l'header della risposta
    header('Content-Type: application/json');

    require_once 'dbconfig.php';
    $genere = mysqli_real_escape_string($conn, $_GET['gen']);
    #filter_var - Filtra una variabile con un filtro specificato

    $query = "SELECT nome FROM genere WHERE nome = '$genere'";
      
    $res = mysqli_query($conn, $query);
  
    if(mysqli_num_rows($res) == 0){
        mysqli_free_result($res);
        $query =  "INSERT INTO genere(nome) VALUES('$genere')";
        $res = mysqli_query($conn, $query);
        if($res)
            echo json_encode(array("genere" => $genere ,"aggiunto" => true));    
    }
    else 
        echo json_encode(array("genere" => $genere ,"aggiunto" => false));
  
    mysqli_close($conn);

?>