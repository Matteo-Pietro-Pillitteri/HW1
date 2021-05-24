const forSearch = document.querySelector('#forSearch');
const divCitta = document.querySelector('#inYourCity');
const bloccoCinema = document.querySelector('.mainblock');
const search = document.createElement('input');
const presentation = document.createElement('h3');
const modale = document.querySelector('#modale');
const likeModale = document.querySelector('#like');
const commentModale = document.querySelector('#comment');


forSearch.classList.add('searchBar')
search.classList.add("searchInput");

presentation.textContent = "Cerca un Dino's Cinema nella tua regione: ";
search.placeholder="Search..";


search.addEventListener('keyup', searchLetter);
divCitta.querySelector('h6').addEventListener('click', cercaInCitta);
modale.addEventListener("click", esciModale);

forSearch.appendChild(presentation);
forSearch.appendChild(search);

fetch("cinema_database.php?").then(function (response){ return response.json();}).then(onFirstJson);

function creaSede(sede,result){
    const divInSede = document.createElement('div');
    const image = document.createElement('img');
    const reg = document.createElement('h3');
    const citAndName = document.createElement('h6');
    const more = document.createElement('div') ;
    const description = document.createElement('h5');
    const codice = document.createElement('li');
    const tred = document.createElement('li');
    const disabili = document.createElement('li');
    const parcheggio = document.createElement('li');
    const relax = document.createElement('li');
    const sale = document.createElement('a');
    const interaction = document.createElement('div');
    const numeroLike = document.createElement('a');
    const like = document.createElement('img');
    const numeroComment = document.createElement('a');
    const linkForComment = document.createElement('a');
    const comment = document.createElement('img');

    numeroLike.addEventListener("click", showLike);
    numeroComment.addEventListener("click", showComment);
    sale.addEventListener("click", showSale);
    like.addEventListener("click", likeOrUnlike);
    comment.addEventListener("click", showComment);
    citAndName.addEventListener("click", show);

    interaction.classList.add("interaction");
    more.classList.add('details');
    more.classList.add('hidden');
    sede.classList.add('eleminsection');
    image.classList.add('dini');
    numeroLike.classList.add('nlikes');
    numeroComment.classList.add('ncomments');
    like.classList.add('unchecked');
    citAndName.classList.add('underline');


    like.src = "images/like.png";
    comment.src= "images/comment.png";
    image.src = result.img;

    reg.textContent = result.regione;
    numeroLike.textContent = result.likes;
    numeroComment.textContent = result.comments;
    citAndName.textContent = result.città + " | " + result.nome;     
    description.textContent = "Caratteristiche di questo cinema: ";
    codice.textContent = result.cod;
    tred.textContent = result.tred == 1 ?  "3d: ✔" : "3d: x";
    disabili.textContent = result.posti_disabili == 1 ? "posti disabili: ✔" : "posti disabili: x";
    parcheggio.textContent = result.parcheggio == 1 ? "parcheggio: ✔" : "parcheggio: x"; 
    relax.textContent = result.area_relax == 1 ? "zona relax: ✔" : "zona relax: x";
    sale.textContent = "Clicca qui per visualizzare le sale";
    
    sale.href="#forSearch";
    numeroLike.href="#forSearch";
    numeroComment.href="#forSearch";
    linkForComment.href="#forSearch";

    linkForComment.appendChild(comment);
    more.appendChild(description);
    more.appendChild(codice);
    more.appendChild(tred);
    more.appendChild(disabili);
    more.appendChild(parcheggio);
    more.appendChild(relax);
    more.appendChild(sale);
    divInSede.appendChild(reg);
    divInSede.appendChild(image);
    divInSede.appendChild(citAndName);
    interaction.appendChild(numeroLike)
    interaction.appendChild(like);
    interaction.appendChild(numeroComment);
    interaction.appendChild(linkForComment); 
    divInSede.appendChild(interaction);
    divInSede.appendChild(more);
    sede.appendChild(divInSede);

    return sede;
}

function onFirstJson(json){
    console.log(json);
    const arrayRegioni = [];
    let count = 0;
    for(const result of json){
        count ++;
        if(count == json.length) fetch("check_like.php").then(function (response){ return response.json();}).then(onCheckLikeJson);

        if(arrayRegioni.indexOf(result.regione) === -1){
            arrayRegioni.push(result.regione);

            const sede = document.createElement('div');
            bloccoCinema.appendChild(creaSede(sede,result));
        }
        else{
            const sedi = Array.from(bloccoCinema.querySelectorAll('.eleminsection'));

            for(const sede of sedi){
                if(sede.querySelector('h3').textContent == result.regione){
                    creaSede(sede,result);
                    break;
                }
            }
        }
    }
}

function likeOrUnlike(event){
    const interaction = event.currentTarget.parentNode;
    const cod = interaction.parentNode.querySelector('li').textContent; //primo tag li
    const condition = event.currentTarget.className == 'unchecked' ? true : false;

    if(condition)
        fetch("like.php?q=" + cod).then(function (response){ return response.json();}).then(onJsonLike); // aggiorno i like
    else
        fetch("unlike.php?q=" + cod).then(function (response){ return response.json();}).then(onJsonUnlike);
    
}


function onCheckLikeJson(json){
    console.log(json);

        if(json[0].log){
        const interactions = Array.from(bloccoCinema.querySelectorAll('.interaction'));
        const username = document.querySelector('#username').value;

        for(let i= 1 ; i < json.length; i++){
            for(const interaction of interactions){
                const div = interaction.parentNode;
                const hidden = div.querySelector('.details');
     
                if(hidden.querySelector('li').textContent == json[i].cod && username == json[i].username)// mi da il primo tag li  
                    interaction.querySelector('img').classList.remove('unchecked');
            }
        }
    }
}


function onJsonLike(json){

    console.log(json);
    if(json.log){
        const details = document.querySelectorAll('.details');
        for(const detail of details){
            if(detail.querySelector('li').textContent ===  json.cod){
                const sede = detail.parentNode;
                const num = sede.querySelector('.nlikes')
                const interaction = sede.querySelector('.interaction');

                num.textContent = json.likes;
                interaction.querySelector('img').classList.remove('unchecked');
                break;
            }
        }
    }
    else{
    const interactions = document.querySelectorAll('.interaction');
        for(const interaction of interactions){
            if(interaction.querySelector('img').className != 'unchecked'){
                interaction.querySelector('img').classList.add('unchecked');
                break;
            }
        }
    }
    
          
}

function onJsonUnlike(json){
    console.log(json);

    if(json.log){
        const details = document.querySelectorAll('.details');
        for(const detail of details){
            if(detail.querySelector('li').textContent ===  json.cod){
                const sede = detail.parentNode;
                const num = sede.querySelector('.nlikes')
                const interaction = sede.querySelector('.interaction');

                num.textContent = json.likes;
                interaction.querySelector('img').classList.add('unchecked');
                break;
            }
        }
    }
    
}


function showComment(event){
    const divSede = event.currentTarget.parentNode.parentNode.parentNode;
    const cin = divSede.querySelector('li').textContent; // primo li
    const bloccoComment = modale.querySelector('div');
    const AreaCommenti = document.createElement('div');
    const divInput = document.createElement('div');
    const inputArea = document.createElement('textarea');
    const divSend = document.createElement('div');
    const span = document.createElement('span');
    const button = document.createElement('button');
    const hidden = document.createElement('input');

    hidden.type ="hidden";
    hidden.value = cin;
    hidden.id = "cinemaId";

    document.body.classList.add('noscroll');
    modale.classList.remove('sedehidden');
    AreaCommenti.classList.add('overflow');
    bloccoComment.innerHTML = "";

    button.textContent = "Send";
    span.textContent = "Dicci qualcosa sulla tua esperienza in questo cinema";
    
    AreaCommenti.id="areaCommenti";
    divInput.id="divInput";
    divSend.id="divSend";


    divSend.appendChild(span);
    divSend.appendChild(button);
    divInput.appendChild(inputArea);
    divInput.appendChild(hidden);
    divInput.appendChild(divSend);
    bloccoComment.appendChild(AreaCommenti);
    bloccoComment.appendChild(divInput);
    button.addEventListener('click', sendComment);

    fetch("show_comments.php?q=" + cin).then(function (response){ return response.json();}).then(onJsonComments);
}



function sendComment(event){
    const divSend = event.currentTarget.parentNode;
    const cin = divSend.parentNode.querySelector('#cinemaId').value;

    const text = divSend.parentNode.querySelector('textarea');
    fetch("send_comment.php?q=" + cin + "&text=" + text.value).then(function (response){ return response.json();}).then(onJsonSend);
}


function onJsonSend(json){

    console.log(json);
    if(json.log){
        const details = document.querySelectorAll('.details');
        for(const detail of details){
            if(detail.querySelector('li').textContent ===  json.cod){
                const sede = detail.parentNode;
                const num = sede.querySelector('.ncomments')

                num.textContent = json.comments;
                break;
            }
        }
        fetch("show_latest_comment.php?q=" + json.cod).then(function (response){ return response.json();}).then(onJsonCommentsOne);

    }else{
        modale.querySelector('textarea').placeholder="Accedi/registrati per inviare commenti";
    }
}


function creaCommento(j){
    const areaCommenti = modale.querySelector('#areaCommenti');
    const commento = document.createElement('div');
    const username = document.createElement('h5');
    const nomeCognome = document.createElement('h6');
    const text = document.createElement('p');

    username.textContent = j.user;
    nomeCognome.textContent = j.cognome + " " + j.nome;
    text.textContent = j.commento;
    
    commento.appendChild(username);
    commento.appendChild(nomeCognome);
    commento.appendChild(text);
    
    areaCommenti.appendChild(commento);
}


function onJsonCommentsOne(json){
    console.log(json);

    if(json[0].log)
        creaCommento(json[1]);
}


function onJsonComments(json){
    console.log(json);

    if(json[0].log)
        for(let i = 1; i< json.length; i++)
            creaCommento(json[i]);
    
}


function showSale(event){
    const divSede = event.currentTarget.parentNode;
    const cin = divSede.querySelector('li').textContent; // primo li

    fetch("sale_database.php?q=" + cin).then(function (response){ return response.json();}).then(onSaleJson);
    document.body.classList.add('noscroll');
    modale.classList.remove('sedehidden');
}


function showLike(event){
    const divSede = event.currentTarget.parentNode.parentNode;
    const cin = divSede.querySelector('li').textContent; // primo li

    fetch("mostra_like.php?q=" + cin).then(function (response){ return response.json();}).then(onMostraLikeJson);
    document.body.classList.add('noscroll');
    modale.classList.remove('sedehidden');
}



function esciModale(event){
    const div = event.currentTarget.querySelector('div');
    
    if (div.contains(event.target)){
        console.log("tutto ok");
    } else{
        document.body.classList.remove('noscroll');
        modale.classList.add('sedehidden');
    }
  
}

function show(event) {
    const elem = event.currentTarget;
    const div = Array.from(elem.parentNode.querySelectorAll('.details'));
    const h6 = elem.parentNode.querySelectorAll('h6');

    for(let i=0;i<h6.length;i++){
        if(h6[i].textContent == elem.textContent){
            div[i].classList.toggle('hidden');
            break;
        }
    }
}


function onSaleJson(json){
    console.log(json);
    const bloccoSala = modale.querySelector('div');
    bloccoSala.innerHTML="";    

    for(const result of json){
        const string = document.createElement('p');

        string.textContent = "Nome sala: " + result.nome_sala + "    " + "Numero Posti: " + result.numero_posti + "    " + "Numero sala: " + result.numero_sala;
        bloccoSala.appendChild(string);
    }
}

function onMostraLikeJson(json){
    console.log(json);
    const bloccoLike = modale.querySelector('div');
    bloccoLike.innerHTML = "";

    if(json[0].log){
        for(let i = 1 ; i<json.length; i++){
            const div = document.createElement('div');
            const username = document.createElement('span');
            const nomeCognome = document.createElement('span');

            div.classList.add('showLike');
            username.textContent = json[i].user;
            nomeCognome.textContent = json[i].nome + " " + json[i].cognome;

            div.appendChild(username);
            div.appendChild(nomeCognome);
            bloccoLike.appendChild(div);
        }
    }
}

function searchLetter(event){
    const barra = event.currentTarget;
    const sedi = Array.from(bloccoCinema.querySelectorAll('.eleminsection'));
    console.log(sedi);
    
    for(const sede of sedi){
        const sedeRegione = sede.querySelector('h3');
        const sedeRegioneText = (sedeRegione.textContent).toUpperCase();

        if(sedeRegioneText.search((barra.value).toUpperCase())!== -1){
            sede.classList.remove('sedehidden');
        }
        else{
            sede.classList.add('sedehidden');
        }
    }
}

function cercaInCitta(event){
    const divCitta = event.currentTarget.parentNode;
    const div = divCitta.querySelector('div');
    const elaboration = divCitta.querySelectorAll('.halfElaboration')[0]; // primo div halfElaboration
    const result =  divCitta.querySelectorAll('.halfElaboration')[1];
    const form = elaboration.querySelector('form');

    div.classList.add('showLike'); // gli do questa classe che ha solo display flex e space-beetwen
    event.currentTarget.textContent = event.currentTarget.textContent == "Vuoi cercare direttamente nella tua citta? Clicca qui" ? "Nascondi ⇡"  : "Vuoi cercare direttamente nella tua citta? Clicca qui";
    elaboration.classList.toggle('sedehidden');

    form.querySelector('h6').addEventListener("click", inviaDati);
    if(result.className != 'sedehidden') result.classList.add('sedehidden');
    result.classList.remove('result');
}

function inviaDati(event){
    const form = event.currentTarget.parentNode;

    if(form.citta.value.length != 0 && form.regione.value.length != 0){
        fetch("show_search_sede.php?citta=" + form.citta.value.toLowerCase() + "&regione=" + form.regione.value.toLowerCase()).then(function (response){ return response.json();}).then(onJsonSearchSede);
    }
    else
        console.log("Un valore o nessun valore inserito");
}

function onJsonSearchSede(json){
    console.log(json);
    const result = document.querySelectorAll('.halfElaboration')[1];
    const sede = document.createElement('div');
    result.classList.remove('sedehidden');
    result.classList.add('result');

    result.innerHTML="";

    if(json.trovato)
        result.appendChild(creaSede(sede, json));
    else{
        const error = document.createElement('h6');
        error.textContent = "Nessun risultato corrisponde ai criteri di ricerca, controlla i dati inseriti";

        result.appendChild(error);
    }
    
}