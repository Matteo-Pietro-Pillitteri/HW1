const bloccoDeiFilm = document.querySelector('.mainblock');  
const news = document.querySelector('#news');
const presentationBox = document.createElement('div');
const titleOfNews = document.createElement('h3');
const newsFilmBox = document.createElement('div');

presentationBox.id='presentation';
titleOfNews.textContent = 'Le novità da tutto il mondo in arrivo nelle nostre sale!';
newsFilmBox.id='mainNews';

news.appendChild(presentationBox);
presentationBox.appendChild(titleOfNews);
news.appendChild(newsFilmBox);

let token;
//SPOTIFY API
fetch("spotify_token.php").then(function (response){ return response.json();}).then(onTokenJson);

//recupero i titoli dei film dal database
fetch("titoli_film.php").then(function (response){ return response.json();}).then(onJson);

//TMDB API
fetch("tmdb_api.php").then(function (response){ return response.json();}).then(onJsonAll);


function onJson(json){
    //OMDB API
    for(let i=0; i<json.length; i++)
     fetch("OMDb_API.php?titolo=" + encodeURIComponent(json[i].titolo)).then(function (response){ return response.json();}).then(onOMDbJson);
    
}

function onTokenJson(json){
    token = json.access_token;
    const films = Array.from(bloccoDeiFilm.querySelectorAll('.eleminsection'));

    for(const film of films){
        const title = film.querySelector('h3').textContent;
        fetch("spotify_api.php?titolo="+ encodeURIComponent(title) + "&token=" + token).then(function (response){ return response.json();}).then(onJsonSpotify);
    }  
}

function onOMDbJson(json){

    console.log(json);
    const string = 'Country: ' + json.Country;
    const films = Array.from(bloccoDeiFilm.querySelectorAll('.eleminsection'));

    for(const film of films){
        const titolo = film.querySelector('h3').textContent;

        if(titolo == json.Title){
            const bloccoDettagli = film.querySelector('.details');
            const details = bloccoDettagli.querySelectorAll('h6');
            details[0].textContent = string;
            details[1].textContent = 'Genre: ' + json.Genre;
            details[2].textContent = 'Time: ' + json.Runtime;
            fetch("setTimeFilm.php?time=" + json.Runtime + "&tit=" + titolo).then(function (response){ return response.json();}).then(function (json) {console.log(json);});
            fetch("addUnknownGenre.php?gen=" + json.Genre).then(function (response){ return response.json();}).then(function (json) {console.log(json);});
            break;
        }
    }
}


function onJsonSpotify(json){
    console.log(json);
    const films = Array.from(bloccoDeiFilm.querySelectorAll('.eleminsection'));
    const playlist = json.playlists
    if(playlist.items.length != 0){
        
        const scelta = playlist.items[0]
        for(const film of films){
            const titlePlaylist = scelta.name;
            const titleFilm = film.querySelector('h3')

            if(titlePlaylist.indexOf(titleFilm.textContent)!==-1){
                const boxSpotify = film.querySelector('.spotify'); // primo e unico elemento di classe spotify dentro il box "film"
                
                (boxSpotify.querySelector('a')).href = (scelta.external_urls).spotify;
                boxSpotify.classList.remove('hidden');
                break;
            }
        }
    }
}

function onJsonAll(json){
    const forImageTMDB = 'https://www.themoviedb.org/t/p/original';
 
    for(const result of json){
        if(result.vote_average > 7.2 && result.release_date > "2021-01-01"){
            console.log(result);
            const box = document.createElement('div');
            const image = document.createElement('img');
            const title = document.createElement('h3');
            const relase = document.createElement('h6');

            box.classList.add('eleminsection');
            image.src =  forImageTMDB + result.poster_path;
            image.classList.add('locandina');
            title.textContent = result.title;
            relase.textContent = 'Release date: ' + result.release_date;

            newsFilmBox.appendChild(box);
            box.appendChild(image);
            box.appendChild(title);
            box.appendChild(relase);      
        }
    }   
}
