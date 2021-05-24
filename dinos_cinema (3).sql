-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mag 24, 2021 alle 23:19
-- Versione del server: 10.4.14-MariaDB
-- Versione PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dinos_cinema`
--

DELIMITER $$
--
-- Procedure
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `film_catena` (OUT `film_piu_visto` VARCHAR(255))  BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmp;
    CREATE TEMPORARY TABLE tmp(
      	  film varchar(255),
          num_biglietti_venduti integer
    );
    
    INSERT INTO tmp
    SELECT F.titolo, count(*) as num_biglietti
    FROM cinema_persone C JOIN film F ON C.film_proiettato = F.id_film
    GROUP BY F.titolo;
    
    SELECT * FROM tmp;
    
    SELECT film INTO film_piu_visto
    FROM tmp
    WHERE num_biglietti_venduti = (SELECT MAX(num_biglietti_venduti)
                                   FROM tmp);
                                  

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `num_medio_biglietti` (IN `partenza` DATE)  BEGIN
	DROP TEMPORARY TABLE IF EXISTS giorni;
    CREATE TEMPORARY TABLE giorni(
         giorno date
    );
    
    WHILE partenza <= (SELECT MAX (data_acquisto)
					   FROM biglietto)
    DO 
    INSERT INTO giorni
    SELECT partenza;
    SET partenza = partenza +1;
    END WHILE;
    
    SELECT * FROM giorni;
    
    DROP TEMPORARY TABLE IF EXISTS tmp;
    CREATE TEMPORARY TABLE tmp(
        giorno date,
        num_biglietti integer
    );
    
    INSERT INTO tmp
    SELECT giorno, count(*)
    FROM cinema_persone C JOIN giorni G ON C.data_acquisto = G.giorno
    GROUP BY giorno;
    
    SELECT * FROM tmp;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p0` (OUT `cin` INT)  BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp;
    CREATE TEMPORARY TABLE tmp(
      	cinema integer,
        numero_sale integer
    );
    
	INSERT INTO tmp
	SELECT C.cod, count(*) as num_sale
    FROM cinema C JOIN sala S ON C.cod = S.cinema
    GROUP BY C.cod;
    
    SELECT cinema INTO cin
    FROM tmp
    WHERE numero_sale = ( SELECT MAX(numero_sale)
                          FROM tmp);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p1` (IN `cin` INT)  BEGIN
    DROP TEMPORARY TABLE IF EXISTS tmp;
    CREATE TEMPORARY TABLE tmp(
        facoltà varchar(255),
        num_studenti integer
    );  
	
    INSERT INTO tmp
    SELECT S.istituto AS facoltà , count(*) AS num_studenti
    FROM cinema_persone C JOIN studente S ON C.biglietto_di = S.id_persona
    WHERE C.cod_cinema = cin 
    GROUP BY facoltà;

    SELECT * FROM tmp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p2` (IN `partenza` DATE)  BEGIN
	DROP TEMPORARY TABLE IF EXISTS giorni;
    CREATE TEMPORARY TABLE giorni(
         giorno date
    );
    
    WHILE partenza <= (SELECT MAX(data_acquisto)
					   FROM biglietto)
    DO 
    INSERT INTO giorni
    SELECT partenza;
    SET partenza = partenza +1;
    END WHILE;
    
    DROP TEMPORARY TABLE IF EXISTS tmp;
    CREATE TEMPORARY TABLE tmp(
        giorno date,
        num_biglietti integer
    );
    
    INSERT INTO tmp
    SELECT giorno, count(ALL C.num_biglietto)
    FROM cinema_persone C RIGHT JOIN giorni G ON C.data_acquisto = G.giorno
    GROUP BY giorno;
    
    SELECT * FROM tmp;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p3` (IN `cin` INT)  BEGIN
	DROP TEMPORARY TABLE IF EXISTS imp;
    CREATE TEMPORARY TABLE imp(
        cf varchar(26),
        nome varchar(255),
        cognome varchar(255),
        email varchar(255),
        birthday date,
        età integer
    );
    
    INSERT INTO imp
    SELECT cf, nome, cognome, email, birthday, età
    FROM impiegato I 
    WHERE EXISTS
    (
    	SELECT *
        FROM impiegato I1 JOIN impiego IM ON I1.cf = IM.cf
        WHERE IM.cinema = cin
        AND I.nome = I1.nome
        AND I.cognome = I1.cognome
        AND I.cf <> I1.cf
        -- l'inizio dell'impiego non deve essere per forza uguale 
    );
    
    SELECT * FROM imp;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p4` (IN `soglia` INT, IN `giorno` DATE)  BEGIN
	
    DROP TEMPORARY TABLE IF EXISTS biglietti_giorno;
    CREATE TEMPORARY TABLE biglietti_giorno(
        cinema integer,
        num_biglietti integer
    );
    
    INSERT INTO biglietti_giorno
    SELECT cod_cinema, count(*) AS num_biglietti 
    FROM cinema_persone 
    WHERE data_acquisto = giorno
    GROUP BY cod_cinema;
	
	DROP TEMPORARY TABLE IF EXISTS imp;
    CREATE TEMPORARY TABLE imp(
        cf varchar(26),
        nome varchar(255),
        cognome varchar(255),
        email varchar(255),
        birthday date,
        età integer
    );
    
    INSERT INTO imp
    SELECT I.cf, I.nome, I.cognome, I.email, I.birthday, I.età
    FROM impiegato I JOIN impiego IM ON I.cf = IM.cf
    WHERE I.età < soglia AND IM.cinema IN (SELECT cinema
                                           FROM biglietti_giorno 
                                           WHERE num_biglietti = (SELECT MAX(num_biglietti)
                                                                  FROM biglietti_giorno));
  SELECT * FROM imp;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `vecchia_p2` (IN `cine` INT, IN `icr_uno` FLOAT, IN `icr_due` FLOAT, IN `icr_tre` FLOAT)  BEGIN
    UPDATE impiego SET stipendio = 
    CASE
    	WHEN(TIMESTAMPDIFF(YEAR, inizio, CURRENT_DATE)) < 2
        THEN stipendio + (stipendio * icr_uno)
        
        WHEN(TIMESTAMPDIFF(YEAR, inizio, CURRENT_DATE)) >= 2 AND (TIMESTAMPDIFF(YEAR, inizio, CURRENT_DATE)) < 5
        THEN stipendio + (stipendio * icr_due)
        
        ELSE stipendio + (stipendio * icr_tre)
    END
    WHERE cinema = cine AND fine IS null;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `assunzione`
--

CREATE TABLE `assunzione` (
  `cinema` int(11) NOT NULL,
  `ditta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `assunzione`
--

INSERT INTO `assunzione` (`cinema`, `ditta`) VALUES
(100, 1),
(100, 2),
(100, 3),
(101, 1),
(101, 3),
(101, 4),
(102, 1),
(102, 3),
(102, 5),
(103, 1),
(103, 2),
(103, 3),
(104, 1),
(104, 3),
(104, 4),
(109, 1),
(109, 3),
(109, 4);

-- --------------------------------------------------------

--
-- Struttura della tabella `biglietto`
--

CREATE TABLE `biglietto` (
  `num` int(11) NOT NULL,
  `proiezione` int(11) NOT NULL,
  `costo` float DEFAULT NULL,
  `persona` int(16) DEFAULT NULL,
  `data_acquisto` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `biglietto`
--

INSERT INTO `biglietto` (`num`, `proiezione`, `costo`, `persona`, `data_acquisto`) VALUES
(1, 1, 5.5, 50, '2020-12-21'),
(1, 2, 5, 51, '2020-12-21'),
(1, 3, 6, 52, '2020-12-21'),
(1, 16, 5, 54, '2020-12-29'),
(2, 1, 5.5, 55, '2020-12-21'),
(2, 2, 5, 56, '2020-12-21'),
(2, 3, 6, 57, '2020-12-21'),
(2, 16, 5, 58, '2020-12-29'),
(3, 1, 5.5, 58, '2020-12-21'),
(3, 2, 5, 57, '2020-12-21'),
(3, 3, 6, 56, '2020-12-21'),
(3, 16, 5, 55, '2020-12-29'),
(4, 1, 5.5, 54, '2020-12-21'),
(4, 2, 5, 53, '2020-12-21'),
(4, 3, 6, 52, '2020-12-21'),
(4, 16, 5, 51, '2020-12-29'),
(5, 1, 5.5, 50, '2020-12-21'),
(5, 3, 6, 0, '2020-12-21'),
(5, 16, 5, 51, '2020-12-29'),
(6, 1, 5.5, 51, '2020-12-21'),
(6, 16, 5, 51, '2020-12-29'),
(7, 1, 5.5, 52, '2020-12-21'),
(8, 1, 5.5, 51, '2020-12-21'),
(9, 1, 5.5, 53, '2020-12-21'),
(10, 1, 5.5, 54, '2020-12-21'),
(11, 1, 5.5, 55, '2020-12-21'),
(12, 1, 5.5, 56, '2020-12-21'),
(13, 1, 5.5, 57, '2020-12-21'),
(14, 1, 5.5, 58, '2020-12-21'),
(15, 1, 5.5, 58, '2020-12-21'),
(16, 1, 5.5, 51, '2020-12-21'),
(17, 1, 5.5, 57, '2020-12-21'),
(18, 1, 5.5, 56, '2020-12-21'),
(19, 1, 5.5, 55, '2020-12-21'),
(20, 1, 5.5, 54, '2020-12-21'),
(21, 1, 5.5, 53, '2020-12-21');

-- --------------------------------------------------------

--
-- Struttura della tabella `cinema`
--

CREATE TABLE `cinema` (
  `cod` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `regione` varchar(255) NOT NULL,
  `città` varchar(255) DEFAULT NULL,
  `tred` tinyint(1) NOT NULL,
  `posti_disabili` tinyint(1) NOT NULL,
  `parcheggio` tinyint(1) NOT NULL,
  `area_relax` tinyint(1) NOT NULL,
  `img` varchar(255) DEFAULT NULL,
  `likes` int(11) NOT NULL,
  `comments` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `cinema`
--

INSERT INTO `cinema` (`cod`, `nome`, `regione`, `città`, `tred`, `posti_disabili`, `parcheggio`, `area_relax`, `img`, `likes`, `comments`) VALUES
(100, 'dinos_catania', 'Sicilia', 'Catania', 1, 1, 1, 0, 'images/dino_catania.png', 3, 1),
(101, 'dinos_palermo', 'Sicilia', 'Palermo', 1, 1, 0, 0, 'images/dino_palermo.png', 2, 2),
(102, 'dinos_roma', 'Lazio', 'Roma', 1, 1, 0, 1, 'images/dino_roma.png', 2, 0),
(103, 'dinos_milano', 'Lombardia', 'Milano', 1, 1, 1, 1, 'images/dino_milano.png', 1, 1),
(104, 'dinos_torino', 'Piemonte', 'Torino', 1, 1, 1, 1, 'images/dino_torino.png', 0, 0),
(109, 'dinos_firenze', 'Toscana', 'Firenze', 1, 1, 0, 0, 'images/dino_firenze.png', 1, 0),
(110, 'dinos_venezia', 'Veneto', 'Venezia', 1, 0, 0, 0, 'images/dino_venezia.png', 0, 0),
(111, 'dinos_verona', 'Veneto', 'Verona', 1, 1, 0, 1, 'images/dino_verona.png', 1, 1),
(112, 'dinos_enna', 'Sicilia', 'Enna', 1, 1, 1, 0, 'images/dino_enna.png', 0, 0),
(113, 'dinos_siena', 'Toscana', 'Siena', 1, 1, 0, 1, 'images/dino_siena.png', 1, 0);

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `cinema_persone`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `cinema_persone` (
`cod_cinema` int(11)
,`nome_cinema` varchar(255)
,`id_sala` int(11)
,`proiezione` int(11)
,`num_biglietto` int(11)
,`biglietto_di` int(16)
,`data_acquisto` date
);

-- --------------------------------------------------------

--
-- Struttura della tabella `comments_cinema`
--

CREATE TABLE `comments_cinema` (
  `id_comment` int(11) NOT NULL,
  `id_persona` int(11) NOT NULL,
  `cod` int(11) NOT NULL,
  `commento` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `comments_cinema`
--

INSERT INTO `comments_cinema` (`id_comment`, `id_persona`, `cod`, `commento`) VALUES
(26, 51, 101, 'Ottima esperienza da Dino\'s Cinema Palermo'),
(27, 54, 101, 'Concordo con Betta, sale grandi e comode.'),
(28, 54, 103, 'Ottima l\'esperienza delle nuove strutture Dino\'s Cinema.. personale un po\' antipatico'),
(29, 51, 100, 'Super originale il design delle sale.'),
(30, 51, 111, 'Di passaggio a Verona per lavoro, non c\'è niente di meglio di godersi un film da Dino\'s Cinema');

--
-- Trigger `comments_cinema`
--
DELIMITER $$
CREATE TRIGGER `comments_trigger` AFTER INSERT ON `comments_cinema` FOR EACH ROW BEGIN
UPDATE cinema 
SET comments = comments + 1
WHERE cod = new.cod;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `ditta_esterna`
--

CREATE TABLE `ditta_esterna` (
  `id_ditta` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `ambito` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `ditta_esterna`
--

INSERT INTO `ditta_esterna` (`id_ditta`, `nome`, `ambito`) VALUES
(1, 'Levante_interni', 'pulizia_ristorazione'),
(2, 'Velox', 'pulizia_uffici'),
(3, 'GS_service', 'sanificazione'),
(4, 'Professione_pulizia', 'lucidazione_pavimenti'),
(5, 'Puliexpress', 'pulizia_uffici');

-- --------------------------------------------------------

--
-- Struttura della tabella `film`
--

CREATE TABLE `film` (
  `id_film` int(11) NOT NULL,
  `durata` int(11) DEFAULT NULL,
  `regista` varchar(255) DEFAULT NULL,
  `titolo` varchar(255) DEFAULT NULL,
  `locandina` varchar(255) NOT NULL,
  `trama` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `film`
--

INSERT INTO `film` (`id_film`, `durata`, `regista`, `titolo`, `locandina`, `trama`) VALUES
(1, NULL, 'Francis Ford Coppola', 'Il Padrino', 'images/Il_padrino.jpg', 'New York, 1945. Vito Corleone, padrino della famiglia Corleone, è un immigrato siciliano. È diventato, dopo anni di crimine, principalmente nell\'organizzazione del gioco d\'azzardo illegale, nella prostituzione e nei racket sindacali, il più potente tra i cinque capi-mafia italo-americani della città. La sua organizzazione gestisce un enorme giro di affari illegali. Coinvolge: l\'iracondo primogenito Santino, detto Sonny, Fredo, secondogenito ingenuo e poco intelligente, e il figliastro Tom Hagen, brillante avvocato divenuto \"consigliere\", cioè braccio destro del capo. Il suo potere non si basa solo sulla violenza, ma anche e soprattutto sull\'\"amicizia\". Il Capo elargisce \"amicizia\" a chi gli chiede favori e in cambio pretende devozione e riconoscenza assoluta. Egli ha così creato, negli anni, una rete di conoscenze e protezioni nel mondo cosiddetto \"legale\".\r\n\r\nDopo il fastoso matrimonio \"alla siciliana\" della figlia Connie, Corleone riceve Virgil Sollozzo, un pericoloso trafficante di droga chiamato \"Il Turco\", affiliato al clan Tattaglia, una delle cinque famiglie newyorkesi, che gli chiede protezione e l\'appoggio finanziario di un milione di dollari per impiantare un traffico di stupefacenti di vasta portata. Il boss rifiuta il proprio appoggio al nascente affare della droga, nonostante il parere favorevole di Santino e di Tom. Scoppia così tra le famiglie una terribile e sanguinaria guerra fatta di reciproci attentati ai principali capi e rappresentanti.\r\n\r\nQuando viene a sapere che il padre è in pericolo di vita a seguito di un attentato, Michael Corleone, decorato della seconda guerra mondiale e unico figlio di don Vito a non essere stato sino ad allora coinvolto negli affari criminali della famiglia, convince il fratello Santino, che ha preso momentaneamente il comando, a farlo incontrare a una cena con Sollozzo per ucciderlo, tendendogli un tranello durante l\'incontro per trattare una tregua. Michael affronta così il trafficante di droga e il capitano di polizia corrotto che lo scorta, uccidendoli in un ristorante del Bronx. Per evitare di essere arrestato o ucciso, il giovane lascia quindi gli Stati Uniti e si rifugia in Sicilia. Qui incontra e si innamora di Apollonia, giovane siciliana che sposa, ma che morirà pochi mesi dopo in un attentato con un\'autobomba a cui egli scampa fortunosamente.\r\n\r\nNel frattempo, a New York, Santino cade in un\'imboscata in cui rimane brutalmente ucciso. Appena ripresosi, don Vito riassume il comando e, colpito profondamente dalla morte del figlio, decide di porre fine alla faida convocando un incontro tra i capi delle principali famiglie mafiose per contrattare una tregua. Durante l\'incontro i boss decidono di permettere lo spaccio di droga, con alcune regole che tutti dovranno rispettare, pena una nuova guerra. In cambio della pace e della garanzia dell\'incolumità di Michael, don Vito accetta di porre le proprie protezioni giudiziarie al servizio del nascente affare.\r\n\r\nRientrato in America, Michael prende il posto di Sonny nella famiglia e in breve tempo il padre gli passa il comando, ritirandosi a vita privata e continuando a consigliare il figlio da dietro le quinte. Nello stesso periodo Michael sposa Kay Adams, sua vecchia fidanzata e compagna di college; da lei ha poi un primogenito, Anthony. Alla morte del padre, avvenuta nel 1955, Michael riceve una proposta dai capi delle altre famiglie mafiose per stipulare un nuovo accordo di pace. Grazie ai vecchi consigli paterni, però, il nuovo boss sa che i capi delle cinque famiglie in realtà operano per esautorare la famiglia Corleone e sa che durante l\'incontro lo uccideranno.\r\n\r\nCon un\'abile mossa anticipa gli eventi facendo uccidere a uno a uno i capifamiglia rivali e Moe Greene durante il battesimo del nipote, punendo con la morte anche chi lo aveva precedentemente tradito, ovvero il caporegime Tessio e il cognato Carlo Rizzi, marito di Connie, il quale anni prima aveva tradito Santino facendolo cadere nell\'imboscata dei Barrese. Per ordine di Michael, Carlo è strangolato dal caporegime Peter Clemenza, padrino di battesimo e precettore mafioso di Santino.\r\n\r\nUsciti dalla guerra di mafia, e una volta riacquistato il potere a New York, i Corleone completano i preparativi per trasferirsi in Nevada, a Las Vegas e a Reno, dove il gioco d\'azzardo, tradizionale attività familiare, si sta espandendo in forma apparentemente legale. Informata da Connie, la quale, sconvolta, ha fatto irruzione nello studio accusando Michael della morte del marito, Kay chiede a Michael se quanto ha gridato la cognata è vero, ma Michael mentendo lo nega, non prima di averle \"ordinato\" di non fargli mai più domande sui suoi affari. La moglie tuttavia capisce la verità quando vede Michael nello studio del padre ricevere dai capiregime i deferenti omaggi dovuti al nuovo padrino.'),
(2, 124, 'Steven Spielberg', 'Jaws', 'images/lo_squalo.jpg', 'Lo Squalo, il film diretto da Steven Spielberg, è ambientato nella cittadina balneare di Amity, nel New England.\r\nNei giorni che precedono la Festa del 4 luglio, la giovane Christine Watkins, scompare dopo essersi tuffata in mare per un bagno di mezzanotte. Il giorno seguente viene rinvenuto sulla battigia il corpo senza vita della ragazza. Le profonde lacerazioni presenti nel corpo martoriato sono compatibili con un attacco di uno squalo.\r\nIl capo della polizia, Martin Brody (Roy Scheider), chiamato ad indagare sul caso, è deciso a chiudere immediatamente la spiaggia per motivi di sicurezza, ma il sindaco Larry Vaughan (Murray Hamilton), si oppone per timore che la notizia della morte della ragazza possa generare un panico collettivo comportando una drastica riduzione del turismo, principale fonte di reddito della città.\r\nVaughan induce anche il medico legale a falsificare gli esiti dell\'autopsia pur di non far trapelare la tragica verità. Brody si trova costretto a sottostare alla volontà del sindaco accettando questa nuova versione della morte di Christine.\r\nMa pochi giorni più tardi un altro bagnante, l\'adolescente Alex Kintner, muore dilaniato da un pescecane.\r\nSi scatena a questo punto una folla caccia allo squalo tra i pescatori e il cacciatore professionista Quint (Robert Shaw). Il ritrovamento di uno squalo tigre, fa credere che l\'incubo sia finalmente terminato, ma il biologo marino Matt Hooper (Richard Dreyfuss), ingaggiato da Brody per ricevere aiuto sul caso, è convinto che non sia lui lo squalo feroce responsabile delle due morti. Effettivamente si tratta di un altro pescecane, il pericoloso squalo purtroppo si aggira ancora tra le acque gremite di bagnanti. Nel giro di poco tempo un altro uomo viene ucciso e un ragazzo, Michel, riesce ad evitare l\'attacco del feroce pescecane solo perché tratto miracolosamente in salvo, seppur svenuto, da alcuni bagnanti.\r\nIl ragazzo salvato è il figlio del poliziotto Brody, che decide a questo punto di mettersi in gioco in prima persona.\r\nIl capo della polizia affronterà il mare insieme a Hooper e al supponente Quint, a bordo dell\'imbarcazione di quest\'ultimo, alla ricerca del pericoloso squalo. Ma l\'impresa si rivelerà decisamente più complicata e azzardata del previsto..'),
(3, 154, 'Quentin Tarantino', 'Pulp Fiction', 'images/pulp.jpg', 'Pulp Fiction, film del 1994 scritto e diretto da Quentin Tarantino, è una storia composta da tre racconti distinti, in ordine non cronologico, che si sviluppano intrecciandosi in una sorta di percorso circolare, con inizio e fine al mattino e nello stesso posto, una caffetteria di Los Angeles chiamata Hawthorne Grill.\r\nNel primo racconto troviamo una coppia di amanti rapinatori, Yolanda (Amanda Plummer) e Gringo (Tim Roth), che derubano la caffetteria. La seconda scena invece è ambientata a bordo di una macchina, dove i due scagnozzi Jules Winnfield (Samuel L. Jackson) e Vincent Vega (John Travolta) al servizio del boss malavitoso Marsellus Wallace (Ving Rhames) sono in viaggio verso l\'appartamento dei ragazzi che hanno rubato una valigetta di proprietà del loro capo, con l\'intenzione di recuperarla e punire i ladri. Quando tornano al locale di Wallace, lo trovano in compagnia del pugile Butch (Bruce Willis), che sta ricevendo istruzioni per andare al tappeto di proposito durante il prossimo incontro.\r\nLa terza scena racconta dell\'appuntamento tra Vincent e Mia (Uma Thurman), moglie di Marsellus, che ha chiesto al suo uomo di portare fuori la ragazza. Prima dell\'incontro, Vincent acquista dell\'eroina, poi porta a cena Mia nel locale anni \'50 Jack Rabbit Slim\'s, dove i due si lanciano in una gara di ballo. Tornati a casa, la serata prende una piega inaspettata quando Mia trova la droga di Vincent e va in overdose; a quel punto inizia la folle corsa di Vincent per tentare di salvarla. Queste naturalmente sono solo le ambientazioni principali e sono moltissime altre le scene che si susseguono in un crescendo di avvenimenti e colpi di scena...'),
(4, 139, 'David Fincher', 'Fight Club', 'images/fight.jpg', 'Fight Club è un film del 1999, diretto da David Fincher e basato sull’omonimo romanzo di Chuck Palahniuk. Il narratore e protagonista della storia (Edward Norton), la cui identità non viene mai rivelata, è un consulente assicurativo per conto di una grande casa automobilistica. Insoddisfatto del lavoro, depresso, insonne, ansioso, egli sembra trovare conforto solo fingendo di essere affetto da una moltitudine di malattie terminali e partecipando agli incontri dei relativi gruppi di supporto. Durante uno di questi incontri, conosce Marla Singer (Helena Bonham Carter), la quale, come il protagonista, frequenta gli incontri pur godendo di buona salute. I due decidono, per quieto vivere, di spartirsi i gruppi ai quali partecipare.\r\nAl ritorno da un viaggio di lavoro, il narratore incontra Tyler Durden (Brad Pitt), un eccentrico venditore di saponette. Quello stesso giorno, giunto a casa, il narratore scopre che il suo appartamento è stato distrutto da un’esplosione causata da una perdita di gas. Disperato, chiama Tyler in cerca di aiuto e i due si incontrano in un bar. Tyler acconsente a ospitare il protagonista nella sua abitazione fatiscente, e tra i due nasce un bizzarro rapporto, fatto di discorsi sovversivi e violenti combattimenti.\r\nQuesta amicizia-simbiosi viene consolidata infine dalla creazione del “Fight Club”, un circolo segreto in cui i membri prendono parte a combattimenti brutali a scopo ricreativo. In poco tempo, il Fight Club diventa un covo di adulti insoddisfatti della vita e della società in cui vivono e la cui unica valvola di sfogo è l’alienazione nella violenza. Il club raduna adepti da tutta la nazione, e nasce il Progetto Mayhem, di stampo anticonsumistico e sovversivo, guidato dalle idee sempre più scellerate di Tyler. Quando il narratore, confuso e preoccupato dalla pericolosità del progetto, tenta di discuterne con Tyler, questi scompare; così il narratore si mette alla ricerca di Tyler, fino a scoprire la sua vera identità.\r\n'),
(5, 149, 'Stanley Kubrick', '2001: A Space Odyssey', 'images/odissea.jpg', '2001: Odissea nello spazio, il film diretto da Stanley Kubrick, è considerato un vero e proprio capolavoro mondiale e rappresenta un punto di svolta non solo per il genere fantascientifico, ma per l\'intera storia del cinema. Quando un gruppo di scimmie trova un misterioso monolite nero, qualcosa in loro muta radicalmente: imparano a maneggiare gli oggetti e a utilizzarli come armi o utensili, segnando dunque il principio della civiltà umana. Milioni di anni dopo, il presidente del Comitato Nazionale Americano per l\'Astronautica, tale dottor Heywood Flyod (William Sylvester), viene inviato in una missione spaziale top secret sulla Luna. Sul satellite terrestre è stato recentemente rinvenuto un oggetto non identificato in prossimità del cratere Tyco, molto simile al monolite con cui sono venuti a contatto gli ominidi.\r\nQuando viene colpito dai primi raggi dell\'alba, l\'artefatto inizia a emettere un segnale radio verso Giove. Proprio su questo pianeta, diciotto mesi dopo - nel 2001-, viene inviata l\'astronave Discovery One con a bordo cinque uomini, tra cui il comandante David Bowman (Keir Dullea) e il suo vice Frank Poole (Gary Lockwood). Il viaggio verso il pianeta gassoso è supervisionato dal supercomputer HAL 9000, un\'intelligenza artificiale in grado di interagire con gli umani. Teoricamente impossibilitato a commettere errori e a omettere dati, la macchina finirà per prendere il controllo dell\'astronave...'),
(6, NULL, 'George Lucas', 'RiffTrax: Star Wars: The Force Awakens', 'images/star.jpg', 'Star Wars - Il risveglio della forza è un film del 2015 diretto da J.J. Abrams, Episodio VII della saga di Guerre Stellari.\r\nLa storia è ambientata circa trent’anni dopo la battaglia di Endor, quando il cavaliere Jedi Luke Skywalker (Mark Hamill) scompare misteriosamente.\r\nIl pilota Poe Dameron (Oscar Isaac) è inviato dalla Resistenza, capeggiata da Leia Organa (Carrie Fisher), su Jakku per recuperare una mappa che conduce al nascondiglio dello Jedi.\r\nIl pilota, tuttavia, si imbatte in Kylo Ren (Adam Driver), oscuro messo del Primo Ordine. Prima di essere catturato, Dameron nasconde la mappa nel droide BB-8 che viene ritrovato dalla giovane Rey (Daisy Ridley) nella zona desertica dove la ragazza vive, in attesa del ritorno dei suoi genitori.\r\nUno degli assalitori, ribattezzato Finn (John Boyega), prova pietà per Poe e, dopo aver tentato di liberarlo, gli promette di recuperare il droide. Finn trova BB-8 e Rey ma i tre vengono attaccati e fuggono a bordo del Millennium Falcon, sepolto tra la sabbia delle dune. La nave spaziale, tuttavia, è abbordata da Han Solo (Harrison Ford) e Chewbecca che da tempo cercavano di ritrovarla. Han rivela ai nuovi arrivati che Luke decise di fuggire senza lasciare traccia, dopo che un suo allievo passò al Lato Oscuro.\r\nSulla Base Starkiller, intanto, il Leader Supremo Snoke (Andy Serkis) ordina a Kylo Ren di uccidere suo padre per abbandonarsi definitivamente all’oscurità e accrescere i suoi poteri. Il Falcon si dirige sul pianeta Takodana dove Rey trova la spada laser appartenente agli Skywalker e ha una visione indotta dalla Forza. L’alleata Maz Kanata (Lupita Nyong\'o) le rivela che lei è la prescelta ma la ragazza non riesce ancora ad accettare il suo destino. Il Primo ordine attacca Takodana e, mentre la Resistenza giunge in soccorso del Falcon, Rey viene catturata da Kylo Ren e trasportata sulla Base Starkiller. Inaspettatamente, la ragazza padroneggia i poteri Jedi e riesce a liberarsi. La Resistenza incarica Fin, Han e Chewbecca di sabotare la Base, piazzando un gran quantitativo di esplosivi al suo interno. Mentre Rey accoglie la Forza e impugna la spada laser degli Skywalker, Kylo Ren sceglie il suo destino...'),
(7, 116, 'Robert Zemeckis', 'Back to the Future', 'images/ritorno.jpg', 'Ritorno al Futuro, è un film fantascientifico del 1985, primo della celebre trilogia. Il film narra la storia di Marty McFly (Micheal J. Fox), un adolescente californiano alle prese con uno scienziato carismatico e un po’ strampalato, Emmett “Doc” Brown (Christopher Lloyd).\r\nDoc invita Marty a raggiungerlo al parcheggio di un grande centro commerciale per aiutarlo a filmare un esperimento. Una volta giunto lì, Marty scopre che l’esperimento è in realtà una macchina del tempo, costruita all’interno di una DeLorean modificata. Lo scienziato rivela che la macchina è alimentata a plutonio e confessa di aver rubato il prezioso elemento ai terroristi libici.\r\nNel tentativo di spiegare a Marty il funzionamento della macchina, Doc seleziona il 5 Novembre 1955 come data di viaggio. Proprio in quel momento, sopraggiungono inaspettatamente i terroristi, i quali sparano allo scienziato. Marty si rifugia dentro la DeLorean e inavvertitamente ne attiva i comandi, e così viaggia indietro nel tempo, fino al 1955. Qui il ragazzo scopre di non avere plutonio a sufficienza per tornare indietro. Così si mette alla ricerca del giovane Doc, l’unico che possa aiutarlo.\r\nStrada facendo incontra George (Crispin Glover), suo futuro padre, bullizzato dal compagno di classe Biff Tannen (Thomas F. Wilson), e, nel seguirlo, finisce con l\'intromettersi nel suo passato. Infatti, Lorraine (Lea Thompson) si invaghisce di Marty, innescando un paradosso temporale pericolosissimo, dal momento che la ragazza è la sua futura madre.\r\nUna volta rintracciato Doc, lo scienziato si mette all’opera per escogitare un piano per riportare Marty “indietro” nel futuro e mette in guardia il ragazzo: dovrà necessariamente fare in modo che i suoi genitori si innamorino quella notte stessa, o verrà cancellato dalla faccia della terra.\r\nA questo primo film sono seguiti Ritorno al Futuro parte II del 1989 e Ritorno al Futuro parte III del 1990.'),
(8, 136, 'Stanley Kubrick', 'A Clockwork Orange', 'images/arancia.jpg', 'Arancia meccanica è un film del 1971 diretto da Stanley Kubrick, tratto dall\'omonimo romanzo di Anthony Burgess.\r\nAmbientato in una futuristica metropoli londinese, è la storia di Alex DeLarge (Malcolm McDowell) e della sua banda criminale di fedeli drughi: un gruppo di giovani violenti e senza scrupoli che girano per la città compiendo furti, stupri e violenze di ogni genere. Vestiti di bianco, con una bombetta nera, anfibi e bastone, i membri della gang di Alex si ritrovano spesso al Korova Milk Bar, un locale dove si può bere del lattepiù, drink a base di latte con mescalina e sostanze stupefacenti.\r\nDopo una serie di crimini impuniti, la leadership di Alex comincia a vacillare e la banda dei drughi non ha più intenzione di accontentarsi delle sue briciole. Così, dopo una rapina andata male, in cui una donna muore colpita dallo stesso Alex, la gang abbandona il suo leader in balìa della polizia, che prima lo arresta e poi lo percuote pesantemente. Dopo un breve processo, Alex è condannato a 14 anni di carcere per omicidio.\r\nPer cercare di ridurre la pena, il protagonista mantiene una buona condotta e decide di sottoporsi al trattamento Ludovico, un innovativo programma di rieducazione promosso dal nuovo governo salito in carica. Con la promessa di una scarcerazione immediata, una volta concluso il percorso di riabilitazione, Alex accetta tutte le condizioni senza esitare. Ma la cura, quasi più atroce della violenza stessa, si rivela fatale per il protagonista che, una volta rientrato nella società, dovrà fare i conti con le vittime del suo passato. Riuscirà a integrarsi nei nuovi panni di bravo ragazzo o sarà inghiottito da un mondo violento e vendicativo che lo vede ancora come un pericolo?'),
(9, 100, 'Alfred Hitchcock', 'Grace Kelly, la donna che visse due volte', 'images/donna.jpg', 'La donna che visse due volte, è un film thriller del 1958, diretto da Alfred Hitchcock, tratto dal romanzo \"D\'entre les morts\" (1954), scritto da Thomas Narcejac e Pierre Boileau.\r\nL\'agente di polizia, John \"Scottie\" Fergus (James Steward), durante un inseguimento sui tetti dei grattacieli di San Francisco, ha un incidente: resta aggrappato ad un cornicione, soffre di vertigini e rimane completamente paralizzato dalla paura. Un suo collega, nel tentativo di salvarlo, precipita nel vuoto e muore. Questo tragico evento cambia la vita di Scottie che lascia la polizia.\r\nUn suo ex compagno di college, ricco costruttore navale, Galvin Elster, gli chiede di assumere l\'incarico di vigilare sulla sua bellissima moglie Madeleine (Kim Novak), la quale, da qualche tempo ha degli atteggiamenti molto particolari, strane ossessioni, incline al suicidio. Il marito teme che stia diventando pazza. La donna crede di essere la reincarnazione della bisnonna materna, Carlotta Valdes, la quale, abbandonata dall\'amante e privata della figlia nata dalla loro relazione, muore suicida a 26 anni, la stessa età di Madeleine. Scottie è scettico, esitante, ma quando Elster gli mostra Madeleine rimane folgorato e accetta l\'incarico.\r\nFra tensioni psicologiche e colpi di scena, si sviluppa una storia complessa che vede Scottie assumere le vesti di un fedele innamorato che disperatamente, cerca di convincere Madeleine ad accettare il suo aiuto per guarire dalle sue ossessioni. Ma tutto il suo impegno non potrà evitare l\'evolversi di incubi e di \"vertigo\" che vedranno Scottie in uno stato di assoluta impotenza.'),
(10, 93, 'Darren Lynn Bousman', 'Saw IV', 'images/saw.jpg', 'Saw IV è un film del 2007 diretto da Darren Lynn Bousman, sequel di Saw III.\r\nDopo aver commesso atroci delitti, Jigsaw (Tobin Bell) è stato ucciso dal cancro. Prima di morire, tuttavia, l\' Enigmista ha scelto Amanda Young (Shawnee Smith) come sua discepola, coinvolgendola nei suoi mortali giochi.\r\nNell’obitorio dove è stato trasportato il corpo del feroce serial killer, i due medici responsabili dell’autopsia rinvengono una cassetta dentro il suo stomaco. Il detective Hoffman (Costas Mandylor) raggiunge l’obitorio per ascoltare le ultime agghiaccianti parole di Jigsaw il quale promette che il suo gioco non è ancora terminato. In un mausoleo non identificato, Trevor (Kevin Rushton) e Art (Justin Louis) si risvegliano legati ad un complesso marchingegno.\r\nAl fine di non permettere ai due di comunicare, a Trevor sono state cucite le palpebre mentre ad Art la bocca.\r\nIl secondo, rendendosi conto che il compagno di sventura porta al collo la chiave per liberarsi dalle catene, cerca disperatamente di afferrarle ma Trevor, non potendo vedere ciò che accade, si dimena e si allontana.\r\nCosì, Art è costretto a compiere un gesto folle per salvarsi la vita. Nel frattempo, la polizia trova il corpo esanime della detective Allison Kerry (Dina Meyer) e gli ispettori Peter Strahm (Scott Patterson) e Lindsay Perez (Athena Karkanis) iniziano a sospettare che Amanda stia agendo con un complice.\r\nIn cerca di informazioni, il detective Mark Hoffman interroga la moglie dell’Enigmista, Jill Tuck (Betsy Russell) …');

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `film_biglietti`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `film_biglietti` (
`film` varchar(255)
,`num_biglietto` bigint(21)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `genere`
--

CREATE TABLE `genere` (
  `id_genere` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `genere`
--

INSERT INTO `genere` (`id_genere`, `nome`) VALUES
(18, 'Adventure, Comedy, Sci-Fi'),
(20, 'Adventure, Sci-Fi'),
(25, 'Adventure, Thriller'),
(17, 'Azione'),
(16, 'Catastrofico'),
(26, 'Comedy'),
(14, 'Comico'),
(11, 'Commedia'),
(24, 'Crime, Drama'),
(19, 'Crime, Drama, Sci-Fi'),
(27, 'Crime, Horror, Mystery, Thriller'),
(10, 'Documentario'),
(23, 'Documentary'),
(21, 'Drama'),
(3, 'Drammatico'),
(8, 'Erotico'),
(7, 'Fantasy'),
(13, 'Giallo'),
(15, 'Grottesco'),
(12, 'Guerra'),
(1, 'Horror'),
(4, 'Romantico'),
(22, 'Short'),
(5, 'Splatter'),
(9, 'Storico'),
(6, 'Thriller');

-- --------------------------------------------------------

--
-- Struttura della tabella `impiegato`
--

CREATE TABLE `impiegato` (
  `cf` varchar(16) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `cognome` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `età` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `impiegato`
--

INSERT INTO `impiegato` (`cf`, `nome`, `cognome`, `password`, `email`, `birthday`, `età`) VALUES
('CGGDHSJFDSSF42EV', 'Giuseppe', 'Colombo', '', '', '2000-06-18', 20),
('CGPENSMNE9SP344M', 'Giuseppe', 'Costa', '', '', '1999-02-01', 21),
('DVEVAOEIFEVC355M', 'Domenico', 'Viola', '', '', '1999-11-03', 21),
('ERNSFDVMAERC389M', 'Ernesto', 'Francavilla', '', '', '1980-12-17', 40),
('FERFEMEFEFSF300V', 'Mariacatena', 'Faraci', '', '', '2000-10-13', 20),
('FGDGDFNGDSFMK332', 'Federico', 'Gullo', '', '', '1999-12-25', 20),
('FGISEFMASPEC354M', 'Giuseppe', 'Finestra', '', '', '1970-06-13', 50),
('FRLSGJRMXEPM372C', 'Lorenzo', 'Fragola', '', '', '1988-08-15', 32),
('FRRLBT00P68F335V', 'Elisabetta', 'Ferrigno', '', '', '2000-09-28', 20),
('FTTELSFMSEIF445V', 'Elide', 'Ferrigno', '', '', '2000-07-23', 20),
('FWUETFWEMJFGWMKE', 'Kevin', 'Marchi', '', '', '1990-05-23', 30),
('GLLERAALBEDNC85M', 'Alberto', 'Gagliolo', '', '', '1982-05-18', 38),
('GRLLNEFMATOF365V', 'Nadia', 'Grillo', '', '', '1977-04-04', 43),
('MCENFLIEFFNC355M', 'Michele', 'Giunta', '', '', '1999-01-01', 21),
('NGGRJAFSMEWC243M', 'Gabriele', 'Nicolosi', '', '', '1976-05-10', 44),
('PASFENTDJSIE344M', 'Silvio', 'Paterno', '', '', '1990-04-19', 30),
('PGHTUCMDGSAI345E', 'Giacomo', 'Pillitteri', '', '', '1976-06-03', 44),
('PLLCHRARKEMF312V', 'Chiara', 'Pillitteri', '', '', '1997-07-15', 23),
('PLLMTP99E01C342M', 'Matteo Pietro', 'Pillitteri', '$2y$10$UrysIxZr/wWWLb1v81w7YuIr8cWa8/ghzKaBYH9TMQ9l6cGSU.y2e', 'pillitterimatteo@hotmail.it', '1999-05-01', 21),
('PNNAUREFMARC345M', 'Nicola', 'Pulvirenti', '', '', '1997-12-10', 23),
('RGESHDSJNFSC376M', 'Gaetano', 'Rizzo', '', '', '1978-02-09', 42),
('RMOSFNEEMFEC356M', 'Mario', 'Rossi', '', '', '1978-02-07', 42),
('RSPPAKFECEFC556M', 'Paolo', 'Russo', '', '', '1980-04-21', 40),
('SCGADUHWEFSD432N', 'Giuseppe', 'Siciliano', '', '', '1999-10-15', 21),
('SIMAUREFMARF345V', 'Marianna', 'Siciliano', '', '', '1985-03-24', 35),
('SPEVKMVDLLEF345V', 'Leila', 'Siciliano', '', '', '1990-09-29', 30),
('SSGIUSSPEAMN345M', 'Giuseppe', 'Siciliano', '', '', '1998-04-17', 22),
('STEERMANRFIE249W', 'Ermes', 'Stellino', '', '', '1980-05-13', 40),
('SVLAJGUEGWGF8I4C', 'Lucia', 'Salvaggio', '', '', '2000-10-30', 20),
('WEFNWDJSCJWEFJ32', 'Tommaso', 'Ruggeri', '', '', '1999-06-23', 21);

--
-- Trigger `impiegato`
--
DELIMITER $$
CREATE TRIGGER `allinea_età` BEFORE INSERT ON `impiegato` FOR EACH ROW BEGIN
	SET new.età = timestampdiff(YEAR, NEW.birthday, CURRENT_DATE);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `impiego`
--

CREATE TABLE `impiego` (
  `id` int(11) NOT NULL,
  `cf` varchar(16) DEFAULT NULL,
  `stipendio` int(11) DEFAULT NULL,
  `inizio` date DEFAULT NULL,
  `cinema` int(11) DEFAULT NULL,
  `fine` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `impiego`
--

INSERT INTO `impiego` (`id`, `cf`, `stipendio`, `inizio`, `cinema`, `fine`) VALUES
(1, 'PLLMTP99E01C342M', 1550, '2014-02-01', 100, NULL),
(40, 'PLLCHRARKEMF312V', 900, '2017-12-15', 100, NULL),
(41, 'GRLLNEFMATOF365V', 900, '2020-01-20', 100, NULL),
(42, 'FRRLBT00P68F335V', 1000, '2015-02-01', 101, NULL),
(43, 'SSGIUSSPEAMN345M', 950, '2018-10-11', 101, NULL),
(44, 'CGPENSMNE9SP344M', 900, '2019-11-22', 102, NULL),
(45, 'MCENFLIEFFNC355M', 1000, '2014-05-03', 102, NULL),
(46, 'FTTELSFMSEIF445V', 950, '2020-05-14', 103, NULL),
(47, 'FRLSGJRMXEPM372C', 900, '2015-02-01', 103, NULL),
(49, 'PNNAUREFMARC345M', 1000, '2019-04-23', 104, NULL),
(51, 'GLLERAALBEDNC85M', 900, '2017-03-30', 109, NULL),
(52, 'RSPPAKFECEFC556M', 1550, '2015-02-27', 102, NULL),
(53, 'CGGDHSJFDSSF42EV', 900, '2019-12-11', 101, NULL),
(55, 'ERNSFDVMAERC389M', 900, '2018-12-15', 100, '2019-05-23'),
(56, 'RMOSFNEEMFEC356M', 1000, '2020-01-12', 100, '2020-06-23'),
(58, 'FGISEFMASPEC354M', 950, '2018-06-11', 101, '2018-07-13'),
(59, 'SIMAUREFMARF345V', 1000, '2019-11-22', 102, '2020-06-05'),
(60, 'SPEVKMVDLLEF345V', 1550, '2015-05-18', 102, '2018-04-30'),
(61, 'RGESHDSJNFSC376M', 950, '2014-05-24', 103, '2015-07-14'),
(62, 'NGGRJAFSMEWC243M', 1000, '2016-06-13', 103, '2020-03-12'),
(63, 'PNNAUREFMARC345M', 1550, '2015-05-18', 104, '2016-12-01'),
(64, 'FERFEMEFEFSF300V', 1550, '2014-01-02', 109, '2014-03-23'),
(65, 'GLLERAALBEDNC85M', 900, '2015-03-02', 109, '2016-04-23'),
(66, 'PGHTUCMDGSAI345E', 900, '2018-12-15', 100, NULL),
(67, 'WEFNWDJSCJWEFJ32', 900, '2016-06-23', 100, NULL),
(68, 'FGDGDFNGDSFMK332', 900, '2019-11-15', 100, NULL),
(69, 'FWUETFWEMJFGWMKE', 900, '1990-05-23', 100, NULL),
(70, 'SCGADUHWEFSD432N', 1000, '2014-03-02', 101, '2017-12-28'),
(72, 'PASFENTDJSIE344M', 900, '2020-12-27', 100, NULL),
(73, 'STEERMANRFIE249W', 900, '2020-11-26', 100, NULL),
(74, 'SVLAJGUEGWGF8I4C', 900, '2020-10-10', 100, NULL);

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `incasso_cinema_film`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `incasso_cinema_film` (
`nome_cinema` varchar(255)
,`titolo_film` varchar(255)
,`incasso_film` double
);

-- --------------------------------------------------------

--
-- Struttura della tabella `lavoratore`
--

CREATE TABLE `lavoratore` (
  `id_lavoratore` int(11) NOT NULL,
  `id_persona` int(11) DEFAULT NULL,
  `categoria` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `lavoratore`
--

INSERT INTO `lavoratore` (`id_lavoratore`, `id_persona`, `categoria`) VALUES
(1, 54, 'Libero professionista'),
(2, 55, 'Operaio');

-- --------------------------------------------------------

--
-- Struttura della tabella `likes_cinema`
--

CREATE TABLE `likes_cinema` (
  `id_persona` int(11) NOT NULL,
  `cod` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `likes_cinema`
--

INSERT INTO `likes_cinema` (`id_persona`, `cod`) VALUES
(50, 100),
(50, 101),
(51, 100),
(51, 101),
(51, 102),
(51, 109),
(51, 111),
(54, 100),
(54, 102),
(54, 103),
(54, 113);

--
-- Trigger `likes_cinema`
--
DELIMITER $$
CREATE TRIGGER `likes_trigger` AFTER INSERT ON `likes_cinema` FOR EACH ROW BEGIN
UPDATE cinema 
SET likes = likes + 1
WHERE cod = new.cod;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `unlikes_trigger` AFTER DELETE ON `likes_cinema` FOR EACH ROW BEGIN
UPDATE cinema 
SET likes = likes - 1
WHERE cod = old.cod;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `num_proiezioni_per_sala`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `num_proiezioni_per_sala` (
`sala` int(11)
,`num_proiezioni` bigint(21)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `persona`
--

CREATE TABLE `persona` (
  `id_persona` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `cognome` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `birthday` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `persona`
--

INSERT INTO `persona` (`id_persona`, `username`, `nome`, `cognome`, `email`, `password`, `birthday`) VALUES
(50, 'Naedd', 'giacomo', 'pillitteri', 'grillonadia77@gmail.re', '$2y$10$GkiwRlqvxDet8njQp60HtuMB4Gw2PM8VFA3cjulruF1RtzYVVHNcS', '1999-05-01'),
(51, 'Betta', 'Elisabetta', 'Ferrigno', 'eliferri@gmail.com', '$2y$10$aQcCL6A8QZtDfhkQNrP8j.WyAXAIk02qU9vgKiPm0n6U0OModOIk.', '2000-09-28'),
(52, 'Gaetta8', 'Gaetano', 'Rizzo', 'gaett@hotmail.it', '$2y$10$WcxadYtxSK.3l6GbAxleL.YYjBGHADU2TFFC8TBN.Dncle2r211qG', '1990-10-10'),
(54, 'GiacLucP', 'Giacomo', 'Pillitteri', 'giacomo@tiscali.com', '$2y$10$uBZ.5/60bRZFptI/0nfeB.yOhgdHxB7qhg8D0qaaU6KrtRx7rMuGS', '1978-06-05'),
(55, 'Mirko', 'Mirko', 'Marino', 'mirco_marino@hotmail.it', '$2y$10$7vFE/srAhID0proRTq8LzeMM33ZmF.taMitkcDPa6q38CCF6/j1Te', '1999-10-12'),
(56, 'Giadone', 'Giuseppe', 'Giadone', 'giadonegiuseppe@hotmail.it', '$2y$10$qEP2QP3qRONp62B1OJckoOHtLyzf7QIBN/8WxVawU7b6sh4sQMU6u', '1999-05-05'),
(57, 'SimNic', 'Simone', 'Nicolosi', 'simnic@gmail.com', '$2y$10$UoriSu0/SwFaeHzIk5N4oetuEDMM4llj1A3gDRttm9FsZLp6jhNXe', '2001-02-13'),
(58, 'LiMat', 'Matteo', 'Lidestri', 'lidestri@hotmail.it', '$2y$10$pvs6o5dC5oDHzOKpeQ7MnO.lOw3GOWlLswRjoL1iplsk1cZdVnajm', '1999-07-23');

-- --------------------------------------------------------

--
-- Struttura della tabella `proiezione`
--

CREATE TABLE `proiezione` (
  `id_proiezione` int(11) NOT NULL,
  `id_sala` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `ora` time DEFAULT NULL,
  `film` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `proiezione`
--

INSERT INTO `proiezione` (`id_proiezione`, `id_sala`, `data`, `ora`, `film`) VALUES
(1, 1, '2020-12-21', '17:00:00', 10),
(2, 2, '2020-12-21', '17:30:00', 5),
(3, 3, '2020-12-21', '21:30:00', 2),
(4, 4, '2020-12-21', '20:30:00', 3),
(5, 5, '2020-12-21', '22:30:00', 4),
(6, 6, '2020-12-22', '18:30:00', 6),
(18, 6, '2020-12-22', '21:00:00', 8),
(7, 7, '2020-12-23', '17:30:00', 7),
(8, 8, '2020-12-23', '17:30:00', 8),
(9, 9, '2020-12-23', '17:30:00', 9),
(10, 10, '2020-12-27', '21:15:00', 1),
(11, 11, '2020-12-27', '17:15:00', 2),
(12, 12, '2020-12-27', '17:30:00', 3),
(13, 13, '2020-12-28', '18:30:00', 4),
(14, 15, '2020-12-28', '19:30:00', 5),
(15, 16, '2020-12-28', '22:30:00', 6),
(16, 17, '2020-12-29', '21:30:00', 7),
(17, 18, '2020-12-30', '21:30:00', 8);

-- --------------------------------------------------------

--
-- Struttura della tabella `sala`
--

CREATE TABLE `sala` (
  `id_sala` int(11) NOT NULL,
  `nome_sala` varchar(255) NOT NULL,
  `numero_posti` int(11) DEFAULT NULL,
  `numero_sala` int(11) DEFAULT NULL,
  `cinema` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `sala`
--

INSERT INTO `sala` (`id_sala`, `nome_sala`, `numero_posti`, `numero_sala`, `cinema`) VALUES
(1, 'Green Dino', 250, 1, 100),
(2, 'Blue Dino', 150, 2, 100),
(3, 'Gray Dino', 350, 3, 100),
(4, 'Red Dino', 450, 4, 100),
(5, 'Orange Dino', 500, 5, 100),
(6, 'Black Dino', 150, 1, 101),
(7, 'Mirror Dino', 250, 2, 101),
(8, 'Violet Dino', 350, 3, 101),
(9, 'Azure Dino', 450, 4, 101),
(10, 'Pink Dino', 500, 5, 101),
(11, 'Coral Dino', 550, 6, 101),
(12, 'Yellow Dino', 600, 7, 101),
(13, 'Golden Dino', 150, 1, 102),
(14, 'Brown Dino', 250, 2, 102),
(15, 'Plum Dino', 350, 3, 102),
(16, 'Magenta Dino', 150, 1, 103),
(17, 'Olive Dino', 250, 2, 103),
(18, 'Silver Dino', 350, 3, 103),
(19, 'Indigo Dino', 450, 4, 103),
(20, 'Acquamarine Dino', 150, 1, 104),
(21, 'Cobalt Dino', 250, 2, 104),
(22, 'Purple Dino', 350, 3, 104),
(23, 'Peach Dino', 450, 4, 104),
(24, 'Cream Dino', 500, 5, 104),
(25, 'Smerald Dino', 150, 1, 109),
(26, '', 250, 2, 109),
(27, '', 350, 3, 109);

-- --------------------------------------------------------

--
-- Struttura della tabella `studente`
--

CREATE TABLE `studente` (
  `id_studente` int(11) NOT NULL,
  `id_persona` int(11) DEFAULT NULL,
  `istituto` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `studente`
--

INSERT INTO `studente` (`id_studente`, `id_persona`, `istituto`) VALUES
(2, 51, 'Università di Catania'),
(3, 52, 'Università di Catania'),
(4, 55, 'Università di Catania'),
(5, 56, 'Università di Milano'),
(6, 57, 'Università di Milano'),
(7, 58, 'Università di Palermo');

-- --------------------------------------------------------

--
-- Struttura della tabella `telefono`
--

CREATE TABLE `telefono` (
  `numero` varchar(10) NOT NULL,
  `cinema` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `telefono`
--

INSERT INTO `telefono` (`numero`, `cinema`) VALUES
('3335342823', 100),
('3427331812', 101),
('3535334533', 102),
('3834781293', 102),
('3314256347', 103),
('3324574282', 104),
('3345673128', 104),
('3335463553', 109),
('3802142365', 109);

-- --------------------------------------------------------

--
-- Struttura della tabella `tipologia`
--

CREATE TABLE `tipologia` (
  `genere` int(11) NOT NULL,
  `film` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `tipologia`
--

INSERT INTO `tipologia` (`genere`, `film`) VALUES
(1, 2),
(1, 10),
(3, 8),
(5, 10),
(6, 9),
(6, 10),
(7, 6),
(7, 7),
(12, 6),
(13, 9),
(15, 8),
(16, 2),
(16, 5),
(17, 1),
(17, 3),
(17, 4),
(17, 5),
(17, 7);

-- --------------------------------------------------------

--
-- Struttura della tabella `titolare`
--

CREATE TABLE `titolare` (
  `direttore` varchar(16) NOT NULL,
  `cinema` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `titolare`
--

INSERT INTO `titolare` (`direttore`, `cinema`) VALUES
('PLLMTP99E01C342M', 100),
('CGGDHSJFDSSF42EV', 101),
('RSPPAKFECEFC556M', 102),
('FRLSGJRMXEPM372C', 103),
('FERFEMEFEFSF300V', 109);

-- --------------------------------------------------------

--
-- Struttura della tabella `users_favourites_movies`
--

CREATE TABLE `users_favourites_movies` (
  `id_favourites` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `locandina` varchar(255) DEFAULT NULL,
  `titolo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `users_favourites_movies`
--

INSERT INTO `users_favourites_movies` (`id_favourites`, `username`, `locandina`, `titolo`) VALUES
(7, 'Betta', 'fight.jpg', 'Fight Club'),
(10, 'Betta', 'star.jpg', 'RiffTrax: Star Wars: The Force Awakens'),
(13, 'Betta', 'arancia.jpg', 'A Clockwork Orange'),
(15, 'GiacLucP', 'star.jpg', 'RiffTrax: Star Wars: The Force Awakens'),
(16, 'GiacLucP', 'saw.jpg', 'Saw IV'),
(17, 'Betta', 'donna.jpg', 'Grace Kelly, la donna che visse due volte');

-- --------------------------------------------------------

--
-- Struttura per vista `cinema_persone`
--
DROP TABLE IF EXISTS `cinema_persone`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cinema_persone`  AS SELECT `c`.`cod` AS `cod_cinema`, `c`.`nome` AS `nome_cinema`, `s`.`id_sala` AS `id_sala`, `p`.`id_proiezione` AS `proiezione`, `b`.`num` AS `num_biglietto`, `b`.`persona` AS `biglietto_di`, `b`.`data_acquisto` AS `data_acquisto` FROM (((`cinema` `c` join `sala` `s` on(`c`.`cod` = `s`.`cinema`)) join `proiezione` `p` on(`s`.`id_sala` = `p`.`id_sala`)) join `biglietto` `b` on(`p`.`id_proiezione` = `b`.`proiezione`)) ;

-- --------------------------------------------------------

--
-- Struttura per vista `film_biglietti`
--
DROP TABLE IF EXISTS `film_biglietti`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `film_biglietti`  AS SELECT `f`.`titolo` AS `film`, count(0) AS `num_biglietto` FROM ((`catena_cinema`.`film` `f` join `catena_cinema`.`proiezione` `p` on(`p`.`film` = `f`.`id_film`)) join `catena_cinema`.`biglietto` `b` on(`p`.`id_proiezione` = `b`.`proiezione`)) GROUP BY `f`.`id_film` ;

-- --------------------------------------------------------

--
-- Struttura per vista `incasso_cinema_film`
--
DROP TABLE IF EXISTS `incasso_cinema_film`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `incasso_cinema_film`  AS SELECT `c`.`nome` AS `nome_cinema`, `f`.`titolo` AS `titolo_film`, count(0) * `b`.`costo` AS `incasso_film` FROM ((((`catena_cinema`.`cinema` `c` join `catena_cinema`.`sala` `s` on(`c`.`cod` = `s`.`cinema`)) join `catena_cinema`.`proiezione` `p` on(`s`.`id_sala` = `p`.`id_sala`)) join `catena_cinema`.`film` `f` on(`p`.`film` = `f`.`id_film`)) join `catena_cinema`.`biglietto` `b` on(`b`.`proiezione` = `p`.`id_proiezione`)) WHERE `b`.`data_acquisto` = '2020-12-29' GROUP BY `c`.`nome`, `f`.`titolo` ;

-- --------------------------------------------------------

--
-- Struttura per vista `num_proiezioni_per_sala`
--
DROP TABLE IF EXISTS `num_proiezioni_per_sala`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `num_proiezioni_per_sala`  AS SELECT `s`.`id_sala` AS `sala`, count(0) AS `num_proiezioni` FROM (`catena_cinema`.`sala` `s` join `catena_cinema`.`proiezione` `p` on(`s`.`id_sala` = `p`.`id_sala`)) GROUP BY `s`.`id_sala` ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `assunzione`
--
ALTER TABLE `assunzione`
  ADD PRIMARY KEY (`cinema`,`ditta`),
  ADD KEY `idx_c` (`cinema`),
  ADD KEY `idx_d` (`ditta`);

--
-- Indici per le tabelle `biglietto`
--
ALTER TABLE `biglietto`
  ADD PRIMARY KEY (`num`,`proiezione`),
  ADD KEY `idx_pro` (`proiezione`),
  ADD KEY `Idx_pers` (`persona`);

--
-- Indici per le tabelle `cinema`
--
ALTER TABLE `cinema`
  ADD PRIMARY KEY (`cod`),
  ADD UNIQUE KEY `città` (`città`);

--
-- Indici per le tabelle `comments_cinema`
--
ALTER TABLE `comments_cinema`
  ADD PRIMARY KEY (`id_comment`),
  ADD KEY `idx_username` (`id_persona`),
  ADD KEY `idx_cinema` (`cod`);

--
-- Indici per le tabelle `ditta_esterna`
--
ALTER TABLE `ditta_esterna`
  ADD PRIMARY KEY (`id_ditta`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indici per le tabelle `film`
--
ALTER TABLE `film`
  ADD PRIMARY KEY (`id_film`),
  ADD UNIQUE KEY `titolo` (`titolo`);

--
-- Indici per le tabelle `genere`
--
ALTER TABLE `genere`
  ADD PRIMARY KEY (`id_genere`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indici per le tabelle `impiegato`
--
ALTER TABLE `impiegato`
  ADD PRIMARY KEY (`cf`);

--
-- Indici per le tabelle `impiego`
--
ALTER TABLE `impiego`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cf` (`cf`,`inizio`,`cinema`),
  ADD KEY `idx_cf` (`cf`),
  ADD KEY `idx_cin` (`cinema`);

--
-- Indici per le tabelle `lavoratore`
--
ALTER TABLE `lavoratore`
  ADD PRIMARY KEY (`id_lavoratore`),
  ADD KEY `idx_id_due` (`id_persona`);

--
-- Indici per le tabelle `likes_cinema`
--
ALTER TABLE `likes_cinema`
  ADD PRIMARY KEY (`id_persona`,`cod`),
  ADD KEY `idx_username` (`id_persona`),
  ADD KEY `idx_cinema` (`cod`);

--
-- Indici per le tabelle `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`id_persona`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indici per le tabelle `proiezione`
--
ALTER TABLE `proiezione`
  ADD PRIMARY KEY (`id_proiezione`),
  ADD UNIQUE KEY `id_sala` (`id_sala`,`data`,`ora`,`film`),
  ADD KEY `idx_sala` (`id_sala`),
  ADD KEY `idx_filmdue` (`film`);

--
-- Indici per le tabelle `sala`
--
ALTER TABLE `sala`
  ADD PRIMARY KEY (`id_sala`),
  ADD UNIQUE KEY `numero_sala` (`numero_sala`,`cinema`),
  ADD KEY `idx_cinema` (`cinema`);

--
-- Indici per le tabelle `studente`
--
ALTER TABLE `studente`
  ADD PRIMARY KEY (`id_studente`),
  ADD KEY `idx_id_uno` (`id_persona`);

--
-- Indici per le tabelle `telefono`
--
ALTER TABLE `telefono`
  ADD PRIMARY KEY (`numero`),
  ADD KEY `idx_ci` (`cinema`);

--
-- Indici per le tabelle `tipologia`
--
ALTER TABLE `tipologia`
  ADD PRIMARY KEY (`genere`,`film`),
  ADD KEY `idx_gen` (`genere`),
  ADD KEY `idx_film` (`film`);

--
-- Indici per le tabelle `titolare`
--
ALTER TABLE `titolare`
  ADD PRIMARY KEY (`direttore`),
  ADD KEY `idx_d` (`direttore`),
  ADD KEY `idx_cinem` (`cinema`);

--
-- Indici per le tabelle `users_favourites_movies`
--
ALTER TABLE `users_favourites_movies`
  ADD PRIMARY KEY (`id_favourites`),
  ADD UNIQUE KEY `username` (`username`,`titolo`),
  ADD KEY `idx_4user` (`username`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `comments_cinema`
--
ALTER TABLE `comments_cinema`
  MODIFY `id_comment` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT per la tabella `ditta_esterna`
--
ALTER TABLE `ditta_esterna`
  MODIFY `id_ditta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT per la tabella `film`
--
ALTER TABLE `film`
  MODIFY `id_film` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT per la tabella `genere`
--
ALTER TABLE `genere`
  MODIFY `id_genere` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT per la tabella `impiego`
--
ALTER TABLE `impiego`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT per la tabella `lavoratore`
--
ALTER TABLE `lavoratore`
  MODIFY `id_lavoratore` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT per la tabella `persona`
--
ALTER TABLE `persona`
  MODIFY `id_persona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT per la tabella `proiezione`
--
ALTER TABLE `proiezione`
  MODIFY `id_proiezione` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT per la tabella `sala`
--
ALTER TABLE `sala`
  MODIFY `id_sala` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT per la tabella `studente`
--
ALTER TABLE `studente`
  MODIFY `id_studente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT per la tabella `users_favourites_movies`
--
ALTER TABLE `users_favourites_movies`
  MODIFY `id_favourites` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `assunzione`
--
ALTER TABLE `assunzione`
  ADD CONSTRAINT `assunzione_ibfk_1` FOREIGN KEY (`cinema`) REFERENCES `cinema` (`cod`),
  ADD CONSTRAINT `assunzione_ibfk_2` FOREIGN KEY (`ditta`) REFERENCES `ditta_esterna` (`id_ditta`);

--
-- Limiti per la tabella `biglietto`
--
ALTER TABLE `biglietto`
  ADD CONSTRAINT `biglietto_ibfk_1` FOREIGN KEY (`proiezione`) REFERENCES `proiezione` (`id_proiezione`);

--
-- Limiti per la tabella `comments_cinema`
--
ALTER TABLE `comments_cinema`
  ADD CONSTRAINT `comments_cinema_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`),
  ADD CONSTRAINT `comments_cinema_ibfk_2` FOREIGN KEY (`cod`) REFERENCES `cinema` (`cod`);

--
-- Limiti per la tabella `impiego`
--
ALTER TABLE `impiego`
  ADD CONSTRAINT `impiego_ibfk_1` FOREIGN KEY (`cf`) REFERENCES `impiegato` (`cf`),
  ADD CONSTRAINT `impiego_ibfk_2` FOREIGN KEY (`cinema`) REFERENCES `cinema` (`cod`);

--
-- Limiti per la tabella `lavoratore`
--
ALTER TABLE `lavoratore`
  ADD CONSTRAINT `lavoratore_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);

--
-- Limiti per la tabella `likes_cinema`
--
ALTER TABLE `likes_cinema`
  ADD CONSTRAINT `likes_cinema_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`),
  ADD CONSTRAINT `likes_cinema_ibfk_2` FOREIGN KEY (`cod`) REFERENCES `cinema` (`cod`);

--
-- Limiti per la tabella `proiezione`
--
ALTER TABLE `proiezione`
  ADD CONSTRAINT `proiezione_ibfk_1` FOREIGN KEY (`id_sala`) REFERENCES `sala` (`id_sala`),
  ADD CONSTRAINT `proiezione_ibfk_2` FOREIGN KEY (`film`) REFERENCES `film` (`id_film`);

--
-- Limiti per la tabella `sala`
--
ALTER TABLE `sala`
  ADD CONSTRAINT `sala_ibfk_1` FOREIGN KEY (`cinema`) REFERENCES `cinema` (`cod`);

--
-- Limiti per la tabella `studente`
--
ALTER TABLE `studente`
  ADD CONSTRAINT `studente_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);

--
-- Limiti per la tabella `telefono`
--
ALTER TABLE `telefono`
  ADD CONSTRAINT `telefono_ibfk_1` FOREIGN KEY (`cinema`) REFERENCES `cinema` (`cod`);

--
-- Limiti per la tabella `tipologia`
--
ALTER TABLE `tipologia`
  ADD CONSTRAINT `tipologia_ibfk_1` FOREIGN KEY (`genere`) REFERENCES `genere` (`id_genere`),
  ADD CONSTRAINT `tipologia_ibfk_2` FOREIGN KEY (`film`) REFERENCES `film` (`id_film`);

--
-- Limiti per la tabella `titolare`
--
ALTER TABLE `titolare`
  ADD CONSTRAINT `titolare_ibfk_1` FOREIGN KEY (`direttore`) REFERENCES `impiegato` (`cf`),
  ADD CONSTRAINT `titolare_ibfk_2` FOREIGN KEY (`cinema`) REFERENCES `cinema` (`cod`);

--
-- Limiti per la tabella `users_favourites_movies`
--
ALTER TABLE `users_favourites_movies`
  ADD CONSTRAINT `users_favourites_movies_ibfk_1` FOREIGN KEY (`username`) REFERENCES `persona` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
