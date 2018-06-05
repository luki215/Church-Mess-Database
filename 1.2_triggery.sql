-- pohlidani ze ve farnosti je maximalne jen jeden farar
CREATE TRIGGER jeden_farar_ve_farnosti
ON Spravci
After INSERT, UPDATE
AS
BEGIN
	if exists(
		-- Všecky položky, kde je počet farářů > 1
		 SELECT *
		 FROM 
		 	-- Farnost ID + Kolik má farářů
			 (
				SELECT F.ID, COUNT(S.ID) as Pocet
				FROM Farnosti F INNER JOIN Spravci S ON (F.ID = S.Farnost_ID)
				WHERE S.Farar = 1
				GROUP BY F.ID
			 ) AS FarnostiAPoctyFararu
		WHERE Pocet > 1
	)
	begin -- existuje farnost se dvemi spravci
		RAISERROR( 'Farnost nemuze mit 2 farare!', 15, 1);
		ROLLBACK TRANSACTION --zahajena updatem
	end;
END;

GO
-- nelze přiřadit čtení jako čtení1 a zároveň čtení2 nebo přímluvy 
CREATE TRIGGER unikatni_cteni
ON Mse
AFTER INSERT, UPDATE
AS
BEGIN
	if exists(
		SELECT * FROM INSERTED 
		where Cteni1 = Cteni2 OR
			  Cteni2 = Primluvy OR
			  Primluvy = Cteni1
	)	
	begin -- jedno cteni pouzito dvakrat
		RAISERROR( 'Ctení nemuze byt pouzito dvakrat!', 15, 1);
		ROLLBACK TRANSACTION --zahajena updatem
	end;
END;