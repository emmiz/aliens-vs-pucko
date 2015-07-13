drop database a11emmjo;
create database a11emmjo CHARACTER SET latin1;
use a11emmjo;

-- *** Mina tabeller *********************************************************************************************************************

CREATE TABLE planet(																-- Skapade en ny tabell över planet för att spara prestanda som sedan både skepp, alien och vapen länkar till eftersom de alla härstammar ifrån en planet.
	nr TINYINT AUTO_INCREMENT,
	namn VARCHAR(20) UNIQUE NOT NULL,
	PRIMARY KEY(nr)
) ENGINE=INNODB;

CREATE TABLE skepp(
	skeppID CHAR(4) CHECK(skeppID LIKE '[0-9][0-9][0-9][0-9]'),						-- Bytte idnr till 4 istället för 5 siffror. Skapade en check som ser till att skeppID består av 4 siffror.
	sittPlatser SMALLINT DEFAULT '1' CHECK(sittPlatser>=1 AND sittPlatser<=5000),	-- Bytte från int till smallint eftersom det räcker för maxvärdet 5000. Tog bort notnull eftersom jag satt en default.
	tillverkningsPlanet TINYINT NOT NULL,											-- Bytte ut så att det nu länkar till tabellen planet.
	PRIMARY KEY(skeppID),
	FOREIGN KEY(tillverkningsPlanet) REFERENCES planet(nr)							-- La in foreign key till tabellen planet.
) ENGINE=INNODB;

CREATE TABLE ras(
	nr SMALLINT,																	-- La till nr som nyckel istället för att undvika upprepning av rasnamnet i alla tabeller. Var tvungen att ta bort AUTO_INCREMENT eftersom min procedur annars inte fungerade för att uppdatera alien med (ras).
	namn VARCHAR(20) UNIQUE NOT NULL,
	PRIMARY KEY(nr)
) ENGINE=INNODB;

CREATE TABLE farlighet(																-- Skapade en ny tabell över farlighet för att spara prestanda som sedan både alien och vapen länkar till eftersom de båda har samma grader av farlighet.
	nr TINYINT(1),
	typ VARCHAR(20) DEFAULT 'Neutral',
	PRIMARY KEY(nr)
) ENGINE=INNODB;

CREATE TABLE alien(
	alienID CHAR(25),
	namn VARCHAR(20) NOT NULL,
	farlighet TINYINT(1) NOT NULL,													-- Bytte ut så att det nu länkar till tabellen farlighet.
	ras SMALLINT NOT NULL,
	PRIMARY KEY(alienID),
	FOREIGN KEY(farlighet) REFERENCES farlighet(nr),								-- La in foreign key till tabellen farlighet.
	FOREIGN KEY(ras) REFERENCES ras(nr)
) ENGINE=INNODB;

CREATE TABLE oRegAlien(
	alienID CHAR(25),
	idKod CHAR(13) CHECK(idKod LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]'),
	PRIMARY KEY(alienID,idKod),
	FOREIGN KEY(alienID) REFERENCES alien(alienID)	
) ENGINE=INNODB;

CREATE TABLE regAlien(
	alienID CHAR(25),
	pNr CHAR(11) CHECK(idKod LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	planet TINYINT NOT NULL,														-- Bytte ut så att det nu länkar till tabellen planet.
	PRIMARY KEY(alienID,pNr),
	FOREIGN KEY(alienID) REFERENCES alien(alienID),
	FOREIGN KEY(planet) REFERENCES planet(nr)										-- La in foreign key till tabellen planet.
) ENGINE=INNODB;

CREATE TABLE vapen(																	-- Delade upp denna till tabellen vapenAgare.
	vapenID CHAR(5),																-- Bytte idnr till 5 istället för 4 siffror.
	tillverkningsPlanet TINYINT NOT NULL,											-- Bytte ut så att det nu länkar till tabellen planet.
	farlighet TINYINT(1) NOT NULL,													-- Bytte ut så att det nu länkar till tabellen farlighet.
	PRIMARY KEY(vapenID),
	FOREIGN KEY(tillverkningsPlanet) REFERENCES planet(nr),							-- La in foreign key till tabellen planet.
	FOREIGN KEY(farlighet) REFERENCES farlighet(nr)									-- La in foreign key till tabellen farlighet.
) ENGINE=INNODB;

CREATE TABLE vapenAgarAlien(
	vapen CHAR(5),																	-- Bytte idnr till 5 istället för 4 siffror.
	alien CHAR(25),
	PRIMARY KEY(vapen,alien),
	FOREIGN KEY(vapen) REFERENCES vapen(vapenID),
	FOREIGN KEY(alien) REFERENCES alien(alienID)
) ENGINE=INNODB;

CREATE TABLE vapenAgarSkepp(
	vapen CHAR(5),																	-- Bytte idnr till 5 istället för 4 siffror.
	skepp CHAR(4),																	-- Bytte idnr till 4 istället för 5 siffror.
	PRIMARY KEY(vapen,skepp),
	FOREIGN KEY(vapen) REFERENCES vapen(vapenID),
	FOREIGN KEY(skepp) REFERENCES skepp(skeppID)
) ENGINE=INNODB;

CREATE TABLE butiker(																-- Skapade en ny tabell över butiker för att spara prestanda som sedan tabellen vapenButiker länkar till.
	nr TINYINT AUTO_INCREMENT,
	namn VARCHAR(20),
	planet TINYINT,
	PRIMARY KEY(nr),
	FOREIGN KEY(planet) REFERENCES planet(nr)
) ENGINE=INNODB;

CREATE TABLE vapenButiker(
	vapenID CHAR(5),																-- Bytte idnr till 5 istället för 4 siffror.
    butik TINYINT,																	-- Bytte ut så att det nu länkar till tabellen butiker.
    PRIMARY KEY(vapenID,butik),
    FOREIGN KEY(vapenID) REFERENCES vapen(vapenID),
	FOREIGN KEY(butik) REFERENCES butiker(nr)										-- La in foreign key till tabellen butiker.
) ENGINE=INNODB;

CREATE TABLE skeppsCrew(
	skeppID CHAR(4),																-- Bytte idnr till 4 istället för 5 siffror.
	alienID CHAR(25),
    PRIMARY KEY(skeppID,alienID),
    FOREIGN KEY(skeppID) REFERENCES skepp(skeppID),
    FOREIGN KEY(alienID) REFERENCES alien(alienID)    
) ENGINE=INNODB;

CREATE TABLE bekantskap(
	alien1 CHAR(25),
	alien2 CHAR(25),
	PRIMARY KEY(alien1,alien2),
	FOREIGN KEY(alien1) REFERENCES alien(alienID),
	FOREIGN KEY(alien2) REFERENCES alien(alienID)
) ENGINE=INNODB;

CREATE TABLE omReg(
	oRegAlien CHAR(25),
	idKod CHAR(13),
	regAlien CHAR(25),
	pNr CHAR(11),
	PRIMARY KEY(oRegAlien,idKod,regAlien,pNr),
	FOREIGN KEY(oRegAlien,idKod) REFERENCES oRegAlien(alienID,idKod),
	FOREIGN KEY(regAlien,pNr) REFERENCES regAlien(alienID,pNr)
)ENGINE=INNODB;

CREATE TABLE skeppKannetecken(
	skeppID CHAR(4),																-- Bytte idnr till 4 istället för 5 siffror.
	tecken VARCHAR(20),																-- Bytte till 20 istället för 30 för det kändes bättre.
	PRIMARY KEY(skeppID,tecken),
	FOREIGN KEY(skeppID) REFERENCES skepp(skeppID)
) ENGINE=INNODB;

CREATE TABLE rasKannetecken(
	rasNamn SMALLINT,
	tecken VARCHAR(20),																-- Bytte till 20 istället för 30 för det kändes bättre.
	PRIMARY KEY(rasNamn,tecken),
	FOREIGN KEY(rasNamn) REFERENCES ras(nr)
) ENGINE=INNODB;

CREATE TABLE alienKannetecken(
	alienID CHAR(25),
	tecken VARCHAR(20),																-- Bytte till 20 istället för 30 för det kändes bättre.
	PRIMARY KEY(alienID,tecken),
	FOREIGN KEY(alienID) REFERENCES alien(alienID)
) ENGINE=INNODB;


-- *** Mina triggers *********************************************************************************************************************

-- En trigger som säkerställer att man inte kan mata in fler än 15 vapen på en alien.
DELIMITER //
CREATE TRIGGER vapenAgarGrans BEFORE INSERT ON vapenAgarAlien
FOR EACH ROW BEGIN
	IF((SELECT COUNT(*) FROM vapenAgarAlien WHERE alien=NEW.alien)=15) THEN -- Om den alien som ingår i inputen redan finns med 15 ggr skall inputen inte köras,
		UPDATE vapen SET En_alien_kan_inte_aga_mer_an_femton_vapen=0; 		-- utan istället försöker triggern göra en omöjlig input vilket resulterar i att ett felemeddelande istället skrivs ut och ingen input görs.
	END IF;
END;
// DELIMITER ;

-- En trigger som förhindrar att en oreggad alien kan kopplas till fler än en reggad alien och tvärtom.
DELIMITER //
CREATE TRIGGER inteMerAnEn BEFORE INSERT ON omReg
FOR EACH ROW BEGIN
	IF(EXISTS(SELECT * FROM omReg WHERE oRegAlien=NEW.oRegAlien) OR EXISTS(SELECT * FROM omReg WHERE regAlien=NEW.regAlien)) THEN
		UPDATE oRegAlien SET En_registrerad_alien_kan_inte_kopplas_samman_med_fler_an_en_oregistrerad_alien=0;
	END IF;
END;
// DELIMITER ;

-- En trigger som ser till att man matar in korrekt form på skeppets id. (4 siffror)
DELIMITER //
CREATE TRIGGER korrektSkeppID BEFORE INSERT ON skepp
FOR EACH ROW BEGIN
	IF(NEW.skeppID NOT REGEXP '[0-9][0-9][0-9][0-9]') THEN
		UPDATE planet SET Ett_skepps_IDnr_måste_bestå_av_fyra_siffor=0;
	END IF;
END;
// DELIMITER ;
-- INSERT INTO skepp(skeppID,sittPlatser,tillverkningsPlanet) VALUES('000a','5','1'); Test för att kontrollera att triggern funkar.


-- Ytterligare triggers jag skulle kunna göra:
-- Korrekt antal sittplatser i skeppet.
-- Korrekt form på aliens id.
-- Korrekt form på oreg aliens id.
-- Korrekt form på reg aliens id.
-- Korrekt form på vapnets id. (5 siffror)
-- Kontroll så att ett vapen som ingår i vapenAgarSkepp inte kan ingå i vapenAgarAlien och tvärtom.
-- Kontroll så man inte kan mata in samma relation fast omvänd i bekantskap.
-- Kontroll av antalet raderingar av alien en användare gjort. (Max 3 får man göra.)
-- Kontroll av antalet raderingar av skepp en användare gjort. (Max 3 får man göra.)
-- Logg över vem som utfört otillåten åtgärd i databasen.


-- *** Populering av min databas *********************************************************************************************************

INSERT INTO planet(namn) VALUES('Saturnus');
INSERT INTO planet(namn) VALUES('Mars');

INSERT INTO skepp(skeppID,sittPlatser,tillverkningsPlanet) VALUES('0001','3','1');
INSERT INTO skepp(skeppID,sittPlatser,tillverkningsPlanet) VALUES('0002','5','1');

INSERT INTO ras(nr,namn) VALUES('1','Velociraptor');
INSERT INTO ras(nr,namn) VALUES('2','Transformer');
INSERT INTO ras(nr,namn) VALUES('3','Avatar');
INSERT INTO ras(nr,namn) VALUES('4','Cybertron');
INSERT INTO ras(nr,namn) VALUES('5','Gremlin');
INSERT INTO ras(nr,namn) VALUES('6','Reptoid');

INSERT INTO farlighet(nr,typ) VALUES('1','Harmlös');
INSERT INTO farlighet(nr,typ) VALUES('2','Halvt harmlös');
INSERT INTO farlighet(nr,typ) VALUES('3','Ofarlig');
INSERT INTO farlighet(nr,typ) VALUES('4','Neutral');
INSERT INTO farlighet(nr,typ) VALUES('5','Svagt farlig');
INSERT INTO farlighet(nr,typ) VALUES('6','Farlig');
INSERT INTO farlighet(nr,typ) VALUES('7','Extremt farlig');
INSERT INTO farlighet(nr,typ) VALUES('8','Spring för livet');

INSERT INTO alien(alienID,namn,farlighet,ras) VALUES('4564532956326565652989721','Kiwi','1','2');
INSERT INTO alien(alienID,namn,farlighet,ras) VALUES('2639030553209298880632016','Mango','2','2');

INSERT INTO oRegAlien(alienID,idKod) VALUES('4564532956326565652989721','120924-121212');
INSERT INTO oRegAlien(alienID,idKod) VALUES('2639030553209298880632016','120924-255255');

INSERT INTO regAlien(alienID,pNr,planet) VALUES('4564532956326565652989721','120925-1564','1');
INSERT INTO regAlien(alienID,pNr,planet) VALUES('2639030553209298880632016','120925-9873','2');

INSERT INTO vapen(vapenID,tillverkningsPlanet,farlighet) VALUES('00001','2','2');
INSERT INTO vapen(vapenID,tillverkningsPlanet,farlighet) VALUES('00002','1','2');
INSERT INTO vapen(vapenID,tillverkningsPlanet,farlighet) VALUES('00003','2','1');
INSERT INTO vapen(vapenID,tillverkningsPlanet,farlighet) VALUES('00004','1','1');
INSERT INTO vapen(vapenID,tillverkningsPlanet,farlighet) VALUES('00005','1','1');
INSERT INTO vapen(vapenID,tillverkningsPlanet,farlighet) VALUES('00006','2','2');

INSERT INTO vapenAgarAlien(vapen,alien) VALUES('00001','2639030553209298880632016');
INSERT INTO vapenAgarAlien(vapen,alien) VALUES('00002','2639030553209298880632016');
INSERT INTO vapenAgarAlien(vapen,alien) VALUES('00002','4564532956326565652989721');
INSERT INTO vapenAgarAlien(vapen,alien) VALUES('00006','4564532956326565652989721');

INSERT INTO vapenAgarSkepp(vapen,skepp) VALUES('00003','0001');
INSERT INTO vapenAgarSkepp(vapen,skepp) VALUES('00004','0002');

INSERT INTO butiker(namn,planet) VALUES('Kwais rymdvapen','1');
INSERT INTO butiker(namn,planet) VALUES('Rhondas bang-bang','2');

INSERT INTO vapenButiker(vapenID,butik) VALUES('00001','2');
INSERT INTO vapenButiker(vapenID,butik) VALUES('00002','1');

INSERT INTO skeppsCrew(skeppID,alienID) VALUES('0001','2639030553209298880632016');
INSERT INTO skeppsCrew(skeppID,alienID) VALUES('0002','4564532956326565652989721');

INSERT INTO bekantskap(alien1,alien2) VALUES('2639030553209298880632016','4564532956326565652989721');

INSERT INTO omReg(oRegAlien,idKod,regAlien,pNr) VALUES('4564532956326565652989721','120924-121212','4564532956326565652989721','120925-1564');
INSERT INTO omReg(oRegAlien,idKod,regAlien,pNr) VALUES('2639030553209298880632016','120924-255255','2639030553209298880632016','120925-9873');

INSERT INTO skeppKannetecken(skeppID,tecken) VALUES('0001','Rund');
INSERT INTO skeppKannetecken(skeppID,tecken) VALUES('0002','Grön');

INSERT INTO rasKannetecken(rasNamn,tecken) VALUES('1','Blåröd');
INSERT INTO rasKannetecken(rasNamn,tecken) VALUES('2','Kantig');

INSERT INTO alienKannetecken(alienID,tecken) VALUES('4564532956326565652989721','Brun');
INSERT INTO alienKannetecken(alienID,tecken) VALUES('2639030553209298880632016','Orange');


-- *** Mina indexeringar *****************************************************************************************************************

-- Sortera alien efter farlighet - Vilka aliens har högsta farlighet och är därmed viktigast att snabbt sätta in en operation på om en observation av dem rings in?
-- INDEX FOR QUERY SELECT * FROM alien ORDER BY farlighet;
CREATE INDEX farlighetPaAlien ON alien(farlighet DESC) USING BTREE;

-- Sortera alla existerande raser i bokstavsordning.
-- INDEX FOR QUERY SELECT * FROM ras ORDER BY namn;
CREATE INDEX alienRaser ON ras(namn ASC) USING BTREE;



-- *** Mina vyer *************************************************************************************************************************

-- Ta fram all info om specifik alien. Dock inte vilka de känner:					-- I vilken ordning skrivs raden ut? Hur tar man bort dublettinfo?
CREATE VIEW alltOmEnAlien AS
-- SELECT alien.alienID AS ID,oRegAlien.idKod AS Kod,regAlien.pNr AS Pnr,alien.namn AS Namn,ras.namn AS Ras,alienKannetecken.tecken AS Kännetecken,planet.namn AS Planet,farlighet.typ AS Farlighet		-- Fick plocka bort denna rad iom att jag fick problem med åäö i min dotnet.
SELECT alien.alienID,oRegAlien.idKod,regAlien.pNr,alien.namn,ras.namn AS Ras,alienKannetecken.tecken,planet.namn AS Planet,farlighet.typ
FROM alien,farlighet,ras,oRegAlien,regAlien,planet,alienKannetecken
WHERE alien.farlighet=farlighet.nr AND
      alien.ras=ras.nr AND
      alien.alienID=oRegAlien.alienID AND
      alien.alienID=regAlien.alienID AND
      regAlien.planet=planet.nr AND
      alien.alienID=alienKannetecken.alienID;

-- Ta fram all info om specifikt skepp:
CREATE VIEW alltOmEttSkepp AS
SELECT skepp.skeppID AS ID,planet.namn AS TillverkningsPlanet,skeppKannetecken.tecken AS Kännetecken
FROM skepp,planet,skeppKannetecken
WHERE skepp.tillverkningsPlanet=planet.nr AND
      skepp.skeppID=skeppKannetecken.skeppID;

-- Ta fram all info om specifikt vapen:
CREATE VIEW alltOmEttVapen AS
-- SELECT vapen.vapenID AS ID,planet.namn AS "Produceras på",butiker.namn AS Inköpsbutik,farlighet.typ AS Farlighet		-- Fick plocka bort denna rad iom att jag fick problem med åäö i min dotnet.
SELECT vapen.vapenID,planet.namn AS planetnamn,butiker.namn,farlighet.typ
FROM vapen,planet,farlighet,butiker,vapenButiker
WHERE vapen.tillverkningsPlanet=planet.nr AND
      vapen.farlighet=farlighet.nr AND
      vapen.vapenID=vapenButiker.vapenID AND
      vapenButiker.butik=butiker.nr
ORDER BY vapenID ASC;


-- *** Mina procedurer och ev tillhörande tabeller ***************************************************************************************

-- Loggtabeller som behövs till hemligstamplaRas-proceduren nedan. Alla nycklar e borttagna för att man skall
-- kunna logga en borttagning av samma ras flera ggr och onödig info i alien-tabellen kopieras inte eftersom
-- datan i alien-tabellen aldrig raderas.
CREATE TABLE rasLogg(
	tid DATETIME,
	nr SMALLINT,
	namn VARCHAR(20)
) ENGINE=INNODB;

CREATE TABLE alienLogg(
	tid DATETIME,
	alienID CHAR(25),
	ras SMALLINT NOT NULL
) ENGINE=INNODB;

CREATE TABLE rasKanneteckenLogg(
	tid DATETIME,
	rasNamn SMALLINT,
	tecken VARCHAR(20)
) ENGINE=INNODB;

-- Denna procedur används för att hemligstämpla en ras, dvs. byta ut alla länkar i refererande tabeller
-- så att det pekar på rasen hemligstämplad och sedan raderas den ras i rastabellen som skall hemligstämplas.
DELIMITER //
CREATE PROCEDURE hemligstamplaRas(num SMALLINT) -- Proceduren kräver ett heltal som input i call'en.
BEGIN
	IF(NOT EXISTS(SELECT * FROM ras WHERE namn='Hemligstämplad')) THEN -- Om rasen hemligstämplad inte finns så skapas den.
		INSERT INTO ras(nr,namn) VALUE('0','Hemligstämplad');
	END IF;
	
	INSERT INTO rasLogg(tid,nr,namn) -- Här måste allt kopieras eftersom det raderas.
	SELECT now(),nr,namn
	FROM ras
	WHERE ras.nr=num;

	INSERT INTO alienLogg(tid,alienID,ras) -- Här räcker det med att kopiera ras och nyckel.
	SELECT now(),alienID,ras
	FROM alien
	WHERE alien.ras=num;

	INSERT INTO rasKanneteckenLogg(tid,rasNamn,tecken)
	SELECT now(),rasNamn,tecken
	FROM rasKannetecken
	WHERE rasKannetecken.rasNamn=num;

	UPDATE alien -- Eventuella länkar till den ras som skall hemligstämplas uppdateras.
	SET alien.ras=0
	WHERE alien.ras=num;

	UPDATE rasKannetecken -- Eventuella länkar till den ras som skall hemligstämplas uppdateras.
	SET rasKannetecken.rasNamn=0
	WHERE rasKannetecken.rasNamn=num;

	DELETE FROM ras WHERE nr=num; -- Den ras som skall hemligstämplas raderas från ras-tabellen.
END;
// DELIMITER ;

-- CALL hemligstamplaRas(2); -- Denna call kräver ett hårdkodat heltal som argument för att kunna testköra proceduren hemligstamplaRas.


-- Denna procedur raderar en alien och alla eventuella länkar till denna i andra tabeller.
-- Om ett vapen endast ägs av denna alien raderas även vapnet och alla länkar till detta
-- i andra tabeller eftersom ett vapen som inte ägs av någon inte får finnas i databasen.
DELIMITER //
CREATE PROCEDURE raderaAlien(id CHAR(25))
BEGIN
	DELETE FROM alienKannetecken WHERE alienID=id;
	DELETE FROM omReg WHERE oRegAlien=id;
	DELETE FROM bekantskap WHERE alien1=id OR alien2=id;
	DELETE FROM skeppsCrew WHERE alienID=id;

	-- En temporär tabell skapas för att man sedan skall kunna spara idnr på alla de vapen
	-- som den enbart den aktuella alien (som skall raderas) äger. Detta för att man måste
	-- radera i rätt ordning mellan tabellerna och om man raderar i agarAlien kan man inte
	-- sedan få fram vilket vapen som skall raderas i vapen-tabellen.
	CREATE TABLE temp(nr CHAR(5));
	INSERT INTO temp(nr) SELECT vapen FROM vapenAgarAlien WHERE alien=id AND vapen NOT IN (SELECT vapen FROM vapenAgarAlien WHERE NOT alien=id);
	DELETE FROM vapenButiker WHERE vapenID IN (SELECT * FROM temp);
	DELETE FROM vapenAgarAlien WHERE alien=id;
	DELETE FROM vapen WHERE vapenID IN (SELECT * FROM temp);
	DROP TABLE temp;

	DELETE FROM regAlien WHERE alienID=id;
	DELETE FROM oRegAlien WHERE alienID=id;
	DELETE FROM alien WHERE alienID=id;
END;
// DELIMITER ;

-- CALL raderaAlien('2639030553209298880632016'); -- Denna call kräver en hårdkodad teckensträng som argument för att kunna testköra proceduren raderaAlien.

-- Ytterligare procedurer jag skulle kunna göra:
-- Administratören skall kunna öka antalet raderingar som någon skall få kunna göra på aliens.
-- Återställ en ras som hemligstämplats.
-- Radera ett skepp


-- *** Mina användarkonton ***************************************************************************************************************

-- CREATE USER 'emmaadmin'@'localhost' IDENTIFIED BY 'admin';


/* Denna select används för att kontrollera att min användare har skapats.
Select *
from mysql.user
where user = 'emmaadmin';
*/