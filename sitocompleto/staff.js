
const elaborate = document.querySelector('#elaborate');
const delicate = document.querySelector('#delicate');
const operazioni = elaborate.querySelectorAll('.operation');
const operazioniDelicate = delicate.querySelectorAll('.operation');

for(const operazione of operazioni){
    const inserisci  = operazione.querySelector('h6');

    inserisci.textContent = "Inserisci dati per operazione " + operazione.dataset.operation;
    inserisci.addEventListener("click", showDati);   
}


for(const operazioneDel of operazioniDelicate){
    const inserisci  = operazioneDel.querySelector('h6');

    inserisci.addEventListener("click", showDatiDelicati);   
}


function showDati(event){
    const divOperation = event.currentTarget.parentNode;
    const insert = divOperation.querySelector('.insert');
    const invia = insert.querySelector('h6');

    insert.classList.toggle('hidden');
    invia.addEventListener("click", inviaDati);
}

function showDatiDelicati(event){
    const divOperation = event.currentTarget.parentNode;
    const h6 = divOperation.querySelectorAll('h6');
    const form = divOperation.querySelector('form');

    form.classList.toggle('hidden');
    h6[1].classList.toggle('hidden');
    h6[1].addEventListener('click', inviaDatiDue);
}


function inviaDati(event){
    const insert = event.currentTarget.parentNode;
    const divOperation = insert.parentNode;
    const numOp = divOperation.dataset.operation;
    const divResult = document.querySelectorAll('.result')[0];
    console.log(divResult);
    divResult.innerHTML = "";

  
    if(insert.children.length > 2){
        const inputs = Array.from(insert.querySelectorAll('input'));
        const parametro = "q";
        let i = 1;
        let string = "";
        for(let y = 0 ; y<inputs.length; y++){
            if(y<inputs.length-1){
                string = string + parametro+i++ + "=" + inputs[y].value + "&";
            }       
            else if(y<inputs.length){
                string = string + parametro+i++ + "=" + inputs[y].value;
            }
        }
        fetch("operazioni.php?q0=" +numOp + "&" + string).then(onOperationResponse).then(onOperationJson);
        
       
    }
    else if(insert.children.length > 1){
        const input =insert.querySelector('input');
        fetch("operazioni.php?q0=" +numOp +"&q1=" + input.value).then(onOperationResponse).then(onOperationJson);
    }
    else{
        fetch("operazioni.php?q0=" +numOp).then(onOperationResponse).then(onOperationJson);
    }
}

function inviaDatiDue(event){
    const divOperation = event.currentTarget.parentNode;
    const tipoOp = divOperation.dataset.operation;
    const form = divOperation.querySelector('form');
    const divResult = document.querySelectorAll('.result')[1];
    console.log(divResult);
    divResult.innerHTML = "";

    switch(tipoOp){
        case 'insertFilm':
            fetch("operazioni_delicate.php?op=" + tipoOp + "&q0=" + form.regista.value + "&q1=" + form.titolo.value + "&q2=" + form.locandina.value + "&q3=" + form.trama.value).then(insertOrDeleteResponse).then(insertOrDeleteJson);
        break;

        case 'deleteFilm':
            fetch("operazioni_delicate.php?op=" + tipoOp + "&q0=" + form.regista.value + "&q1=" + form.titolo.value).then(insertOrDeleteResponse).then(insertOrDeleteJson);
        break;

        case 'insertSede':
            fetch("operazioni_delicate.php?op=" +tipoOp + "&q0=" + form.cod.value + "&q1=" + form.nome.value + "&q2=" + form.regione.value + "&q3=" + form.citta.value + "&q4=" +form.tred.value + "&q5=" + form.disabili.value + "&q6=" + form.parcheggio.value + "&q7=" + form.relax.value +  "&q8=" + form.logo.value ).then(insertOrDeleteResponse).then(insertOrDeleteJson);
        break;
           
        case 'deleteSede':
            fetch("operazioni_delicate.php?op=" + tipoOp + "&q0=" + form.cod.value).then(insertOrDeleteResponse).then(insertOrDeleteJson);
        break;
    }
}

function onOperationResponse(response){
    return response.json();
}

function insertOrDeleteResponse(response){
    return response.json();
}

function onOperationJson(json){
    console.log(json);
    const divResult = document.querySelectorAll('.result')[0];
    const table = document.createElement('table');
    const rigamain = document.createElement('tr');
    const colonna1main = document.createElement('td');
    const colonna2main = document.createElement('td');

   
        const op = json[0].operazione;

        switch(op){
            case 'p0':
                colonna1main.textContent = "Codice cinema";
                rigamain.appendChild(colonna1main);
                table.appendChild(rigamain);

                for(let i = 1 ; i < json.length; i++){
                    const riga = document.createElement('tr');
                    const colonna1 = document.createElement('td');
               
                    colonna1.textContent = json[i]['@cod'];
                    console.log(colonna1.textContent);
                    riga.appendChild(colonna1);
                    table.appendChild(riga);
                }
                divResult.appendChild(table);                
            break;

            case 'p1':
                colonna1main.textContent = "Facoltà";
                colonna2main.textContent = "Num studenti";
                rigamain.appendChild(colonna1main);
                rigamain.appendChild(colonna2main);
                table.appendChild(rigamain);
                

                for(let i = 1 ; i < json.length; i++){
                    const riga = document.createElement('tr');
                    const colonna1 = document.createElement('td');
                    const colonna2 = document.createElement('td');
               
                    colonna1.textContent = json[i].facoltà;
                    colonna2.textContent = json[i].num_studenti;
                    riga.appendChild(colonna1);
                    riga.appendChild(colonna2);
                    table.appendChild(riga);
                }
                divResult.appendChild(table);
            break;

            case 'p3':
            case 'p4':        
                colonna1main.textContent="Cf";
                colonna2main.textContent="Nome";
                rigamain.appendChild(colonna1main);
                rigamain.appendChild(colonna2main);

                for(const contentColumn of ["Cognome", "Email", "Compleanno", "Età"]){
                    // per tutte i nomi di questo array
                    const col = document.createElement('td');
                    col.textContent = contentColumn;
                    rigamain.appendChild(col);
                }

                table.appendChild(rigamain);

                for(let i=1; i<json.length; i++){
                    const riga = document.createElement('tr');
                    // creo un array contente i campi del json 
                    const fields = [json[i].cf, json[i].nome, json[i].cognome, json[i].email, json[i].birthday, json[i].età];

                    for(const rowContent of fields){
                        const col = document.createElement('td');
                        col.textContent = rowContent;
                        riga.appendChild(col);
                    }
                    table.appendChild(riga)
                }
                divResult.appendChild(table);

            break;
        }
        
}

function resultFilm(json,op){
    const divResult = document.querySelectorAll('.result')[1];
    const h3 = divResult.parentNode.querySelector('h3');
    const title = document.createElement('h3');
    const img = document.createElement('img');
    const regista = document.createElement('h6');
    const trama = document.createElement('p');

    h3.textContent = "Risultato del tipo di operazione: " + op;
    title.textContent = json.titolo;
    img.src = json.locandina;
    img.classList.add('locandina');
    regista.textContent = json.regista;
    trama.textContent = json.trama;

    divResult.appendChild(title);
    divResult.appendChild(img);
    divResult.appendChild(regista);
    divResult.appendChild(trama);
}


function resultSede(json,op){
    const divResult = document.querySelectorAll('.result')[1];
    const h3 = divResult.parentNode.querySelector('h3');
    const codice = document.createElement('h6');
    const logo = document.createElement('img');
    const nome = document.createElement('h3');
    const regione = document.createElement('h6');
    const citta = document.createElement('h6');

    h3.textContent = "Risultato del tipo di operazione: " + op;
    codice.textContent = json.codice;
    logo.src = json.img;
    logo.classList.add('dini');
    nome.textContent = json.nome;
    regione.textContent = json.regione;
    citta.textContent = json.città;

    divResult.appendChild(nome);
    divResult.appendChild(logo);
    divResult.appendChild(codice);
    divResult.appendChild(regione);
    divResult.appendChild(citta);
}

function insertOrDeleteJson(json){
    console.log(json);
    const divResult = document.querySelectorAll('.result')[1];
    const h3 = document.createElement('h3');
    const op = json[0].operazione;


    switch(op){
        case 'insertFilm':
            resultFilm(json[1], op);
            h3.textContent = "Inserimento avvenuto con successo";
            divResult.appendChild(h3);
        break;

        case 'deleteFilm':
            resultFilm(json[1], op);
            h3.textContent = "Rimozione avvenuta con successo";
            divResult.appendChild(h3);
        break;

        case 'insertSede':
            resultSede(json[1], op);
            h3.textContent = "Inserimento avvenuto con successo";
            divResult.appendChild(h3);
        break;
           
        case 'deleteSede':
            resultSede(json[1], op);
            h3.textContent = "Rimozione avvenuta con successo";
            divResult.appendChild(h3);
        break;
    }
}




