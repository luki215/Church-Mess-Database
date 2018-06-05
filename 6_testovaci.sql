/* Farnosti */

-- farnosti na začátku
SELECT * FROM farnosti;
-- přidání nové farnosti
execute pridat_farnost 'Frýdlant n. O.'
-- nelze pridat farnost se stejnym jmenem => chyba
execute pridat_farnost 'Frýdlant n. O.'
-- mame frydlant pouze 1x
SELECT * FROM farnosti;
-- odstraneni nezname farnosti => chyba
execute odstranit_farnost "asd"
-- odstranit farnost s kostely nebo spravci => chyba
execute odstranit_farnost "Dobrá"
-- odstrani prazdnou farnost
execute odstranit_farnost 'Frýdlant n. O.'
-- frydlant už neni
SELECT * FROM farnosti;

/* 
*   Kostely
*/

-- Kostely předtím
select * from FarnostiAKostely;
-- Nelze přidat kostel do neexistující farnosti => chyba
execute pridat_kostel 'asd', 'Sv. Václava', 50.123, 60.231;
-- Nelze přidat kostel stejného jména do farnosti => chyba
execute pridat_kostel 'Dobrá', 'Sv. Jiří', 49, 20;
-- Nevezme nevalidní souřadnice kostela => chyba
execute pridat_kostel 'Dobrá', 'Sv. Jiří 2', -1, 20;
execute pridat_kostel 'Dobrá', 'Sv. Jiří 2', 92, 20;
execute pridat_kostel 'Dobrá', 'Sv. Jiří 2', 49, -2;
execute pridat_kostel 'Dobrá', 'Sv. Jiří 2', 49, 92;
-- přidá kostel pokud je vše validní
execute pridat_kostel 'Dobrá', 'Sv. Jiří 2', 50, 50;
-- Kostel je přidaný
SELECT * FROM FarnostiAKostely;
-- Nelze odstranit z neplatné farnosti => chyba
execute odstranit_kostel 'asd', 'dsa';
-- Nelze z farnosti odstranit kostel, který neexistuje => chyba 
execute odstranit_kostel 'Dobrá', 'Sv. Jiří 3';
-- Odstraní Kostel 
execute odstranit_kostel 'Dobrá', 'Sv. Jiří 2';
-- Kostely již bez Jiřího 2
SELECT * FROM FarnostiAKostely;

/*
*   Správci
*/

SELECT * From FarnostiASpravci;
-- nelze přidat správce do neexistující farnosti => chyba
execute pridat_spravce 'asd', 'Pepa Pepa';
-- nelze přidat 2 faráře o farnosti => chyba
execute pridat_spravce 'Dobrá', 'Marek Kozak', 1;
-- přidá faráře
execute pridat_spravce 'Praha', 'Pražský farář', 1;
-- přidá normál správce
execute pridat_spravce 'Praha', 'Pražský správce';
-- Nyní má Praha faráře a správce
SELECT * FROM FarnostiASpravci;

-- výpis správců a počty jejich sv. smířeními (pokud mají detaily ) 
SELECT * FROM SpravciAZpovediStatistiky;
-- nelze odstranit spravce se zpovedmi => chyba
execute odstranit_spravce 1;
-- bez zpovedi ale lze
execute odstranit_spravce 2;
-- nyní už tam není
SELECT * FROM SpravciAZpovediStatistiky;

/*
*   Mše
*/
-- mše původní
SELECT * FROM Udalosti_Mse;
-- pohlídá si, že zadáváme validní lektory => chyba
execute pridat_msi 1, '2018-06-12 10:30:00.0000000', 'Svatební obřad', '1Pt 4,7-13', 15, null, 2, 'za rodinu Králikovu', 3;
-- jinak přidá mši
execute pridat_msi 1, '2018-06-12 10:30:00.0000000', 'Svatební obřad', '1Pt 4,7-13', 1, null, 2, 'za rodinu Králikovu', 3;
-- a mše se objeví
SELECT * FROM Udalosti_Mse;
-- taky ji lze odstranit
execute odstranit_msi 1;
-- mše je odstraněna
SELECT * FROM Udalosti_Mse;

/* Sv. smíření */
-- původní sv. smíření
SELECT * FROM Udalosti_SvatostiSmireni;
-- přidá sv. smíření
execute pridat_sv_smireni 1, 1, '2018-06-12 10:30:00.0000000', null, 30;
-- přidáno
SELECT * FROM Udalosti_SvatostiSmireni;
-- odstrani sv. smíření
execute odstranit_sv_smireni 1;
-- je odstraněna
SELECT * FROM Udalosti_SvatostiSmireni;

/* Schůzky skupinek */
-- původní schůzky skupinek
SELECT * FROM Udalosti_SchuzkySkupinek;
-- přidá schůzku skupinek
execute pridat_schuzku_skupinek 1, '2018-06-12 10:30:00.0000000', 'Dětské spolčo', 'Dnes na téma škola';
-- přidáno
SELECT * FROM Udalosti_SchuzkySkupinek;
-- odstrani schůzku skupinek
execute odstranit_schuzku_skupinek 1;
-- je odstraněna
SELECT * FROM Udalosti_SchuzkySkupinek;

