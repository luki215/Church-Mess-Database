-- Pro manipulaci se mší jako s událostí
create view Udalosti_Mse as
(
	SELECT U.Nazev, U.Konani, U.Kostel_ID, M.Cteni1, M.Cteni2, M.Primluvy 
	FROM Udalosti U
	JOIN Mse M ON (U.UdalostDetail_ID = M.ID and U.Typ = 1)
)
go

-- Pro manipulaci se sv. smíøení jako s událostí
create view Udalosti_SvatostiSmireni as
(
	SELECT U.Nazev, U.Konani, U.Kostel_ID, S.Delka, S.Zpovednik_ID 
	FROM Udalosti U
	JOIN SvatostiSmireni S ON (U.UdalostDetail_ID = S.ID and U.Typ = 2)
)
go

-- Pro manipulaci se schùzkami skupinek jako s událostí
create view Udalosti_SchuzkySkupinek as
(
	SELECT U.Nazev, U.Konani, U.Kostel_ID, S.Popis 
		FROM Udalosti U
		JOIN SchuzkySkupinek S ON (U.UdalostDetail_ID = S.ID and U.Typ = 3)
)
go


-- seznam mší pro farnosti
create view MseVeFarnostech as 
(
	SELECT F.ID as Farnost_ID, F.Jmeno as FarnostJmeno, M.*  
	FROM Farnosti F JOIN Kostely K on ( K.FaronstID = F.ID )
	JOIN Udalosti_Mse M on (K.ID = M.Kostel_ID)
)
go
select * from MseVeFarnostech;


-- Mše na kterých lektoøi ètou
