-- Vypis vsech msi s detaily
create view Udalosti_Mse as
(
	SELECT M.ID, U.Nazev, U.Konani, U.Kostel_ID, M.Cteni1, M.Cteni2, M.Primluvy 
	FROM Udalosti U
	INNER JOIN Mse M ON (U.UdalostDetail_ID = M.ID and U.Typ = 1)
)

go

-- Vypis vsech sv. smireni s detaily
create view Udalosti_SvatostiSmireni as
(
	SELECT S.ID, U.Nazev, U.Konani, U.Kostel_ID, S.Delka, S.Zpovednik_ID 
	FROM Udalosti U
	INNER JOIN SvatostiSmireni S ON (U.UdalostDetail_ID = S.ID and U.Typ = 2)
)
go

-- Vypis vsech schuzek skupinek s detaily
create view Udalosti_SchuzkySkupinek as
(
	SELECT S.ID, U.Nazev, U.Konani, U.Kostel_ID, S.Popis 
		FROM Udalosti U
		INNER JOIN SchuzkySkupinek S ON (U.UdalostDetail_ID = S.ID and U.Typ = 3)
)
go


-- seznam msi pro farnosti
create view MseVeFarnostech as 
(
	SELECT F.ID as Farnost_ID, F.Jmeno as FarnostJmeno, M.*  
	FROM Farnosti F JOIN Kostely K on ( K.Farnost_ID = F.ID )
	INNER JOIN Udalosti_Mse M on (K.ID = M.Kostel_ID)
)
go


-- Mse + kde a kdy lektori ctou
create view MsePodleLektoru AS
(	SELECT L.ID as LektorID, L.Jmeno as LektorJmeno, U.Konani, F.Jmeno as FarnostJmeno, K.Jmeno as KostelJmeno  
	FROM Lektori L JOIN Cteni C ON (L.ID = C.Lektor_ID)
		INNER JOIN Mse M ON (M.Cteni1 = C.ID or M.Cteni2 = C.ID or M.primluvy = C.ID)
		INNER JOIN Udalosti U ON (U.UdalostDetail_ID = M.ID and U.Typ = 1)
		INNER JOIN Kostely K On (U.Kostel_ID = K.ID)
		INNER JOIN Farnosti F ON (K.Farnost_ID = F.ID)
)

go


-- Kostely a farnosti
create view FarnostiAKostely AS
(
	SELECT F.Jmeno as FarnostJmeno, K.Jmeno as KostelJmeno, K.PolohaLat, K.PolohaLng
	FROM Kostely K INNER JOIN Farnosti F ON (K.Farnost_ID = F.ID)
)
go


-- Spravci s farnosti
create view FarnostiASpravci AS
(
	SELECT F.Jmeno as FarnostJmeno, S.Jmeno as SpravceJmeno, S.Farar
	FROM Farnosti F INNER JOIN Spravci S ON (S.Farnost_ID = F.ID)
)
go 

-- Sv. smireni podle spravcu
create view SpravciAZpovedi AS
(
	SELECT S.ID as Spravce_ID, S.Jmeno, S.Farar, S.Farnost_ID, U.Nazev, U.Konani, U.Kostel_ID, U.Delka 
	FROM Spravci S INNER JOIN Udalosti_SvatostiSmireni U ON (S.ID = U.Zpovednik_ID)
)
go 

-- Správci a statistiky zpovědí
create view SpravciAZpovediStatistiky as
(
	SELECT S.ID, S.Jmeno, count(U.ID) as PocetZpovidani, ISNULL(sum(U.delka), 0) as DelkaZpovidaniMinuty FROM Spravci S 
	LEFT JOIN Udalosti_SvatostiSmireni U on (S.ID = U.Zpovednik_ID)
	GROUP BY S.ID, S.Jmeno
)
go
-- seznam lektorů s farnostmi kde četli
create view LektoriAFarnosti AS
(
	SELECT DISTINCT L.ID, L.Jmeno as LektorJmeno, F.Jmeno as FarnostJmeno
	FROM Lektori L 
		LEFT OUTER JOIN Cteni C ON (C.Lektor_ID = L.ID)
		INNER JOIN Mse M On(C.ID = M.Cteni1 or C.ID = M.Cteni2 or C.ID = M.Primluvy)
		INNER JOIN Udalosti U ON(U.UdalostDetail_ID = M.ID and U.Typ = 1)
		INNER JOIN Kostely K ON(K.ID = U.Kostel_ID)
		INNER JOIN Farnosti F ON(K.Farnost_ID = F.ID)
)


-- Ostatni obrazovky podle me primo 
-- z tabulek  + techhle pohledu- skoda na to psat
-- dalsi pohledy