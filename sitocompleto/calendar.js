function esc(){
    document.body.classList.remove('noscroll');
    divCalendar.classList.add('hidden');
}

function calendarView(){
    document.body.classList.add('noscroll');
    divCalendar.classList.remove('hidden');
}

const button = document.querySelector('#info');
button.addEventListener("click", calendarView);

const divCalendar = document.querySelector('#modalView');
divCalendar.addEventListener("click", esc);


