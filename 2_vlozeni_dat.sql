
-- Farnosti

INSERT INTO Farnosti(Jmeno) VALUES 
    ('Dobrá'), 
    ('Frýdek-Místek'),
    ('Praha');

-- Kostely
INSERT INTO Kostely(Jmeno, PolohaLat, PolohaLng, Farnost_ID) VALUES
    ('Sv. Jiří', 49.6735104, 18.4139472, 1),
    ('Sv. Antonína', 49.9735104, 18.5139472, 1),
    ('Sv. Ignáce', 50.1735104, 19.1139472, 2),
    ('Sv. Pavla', 50.3735104, 19.1439472, 2);

-- Správci
INSERT INTO Spravci(Jmeno, Farar, Farnost_ID) VALUES
    ('Marek Kozak', 1, 1),
    ('Lukáš Březina', 0, 1),
    ('Karel Lakatoš', 1, 2),
    ('Helena Skarková', 0, 2);

-- Lektoři
INSERT INTO Lektori(Jmeno) VALUES
    ('Lukáš Březina'), 
    ('Anežka Nováková'),
    ('Patrícia Kubíčková'),
    ('Karel Karel'),
    ('Jonáš Pavel');

-- Čtení
INSERT INTO Cteni(Nazev, Lektor_ID) VALUES 
    ('1Pt 4,7-13', 1),
    ('Dt 5,12-15', 1),
    ('2Kor 4,6-11', 2),
    (null, 2),
    (null, 3),
    (null, 2),
    (null, 1), 
    ('Ez 17,22-24', 2),
    ('2Kor 5,6-10', 1);


INSERT INTO Mse (Cteni1, Cteni2, Primluvy) VALUES 
    (1, 3, 4),
    (2, 8, 6),
    (7, 9, 5);

INSERT INTO SvatostiSmireni (Delka, Zpovednik_ID) VALUES
    (90, 1),
    (90, 3),
    (120, 1),
    (120, 3);

INSERT INTO SchuzkySkupinek (Popis) VALUES
	('Přijďte na další schůzku skupinek tentokrát se super tématem téma'),
	('Přijďte na další schůzku skupinek tentokrát se super tématem téma3'),
	('Přijďte na další schůzku skupinek tentokrát se super tématem téma2'),
	('Přijďte na další schůzku skupinek tentokrát se super tématem téma1');


INSERT INTO Udalosti(Konani, Kostel_ID, Nazev, Typ, UdalostDetail_ID) VALUES
-- Mse
('2018-06-05 08:00:00', 1, null, 1, 1),
('2018-06-05 10:30:00', 2, null, 1, 2),
('2018-06-07 18:00:00', 3, null, 1, 3),
-- Sv. smireni
('2018-06-05 06:30:00', 1, 'Jarni zpoved', 2, 1),
('2018-06-05 11:30:00', 1, 'Jarni zpoved', 2, 2),
('2018-06-05 15:00:00', 2, null, 2, 3),
('2018-06-08 15:00:00', 3, null, 2, 4),
-- Schuzky skupinek
('2018-06-05 06:30:00', 1, 'Uterky', 3, 1),
('2018-06-05 11:30:00', 1, 'Mamky', 3, 2),
('2018-06-05 15:00:00', 2, 'Detske skupinky', 3, 3),
('2018-06-08 15:00:00', 3, null, 3, 4);