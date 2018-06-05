
/*
*   Farnosti
*/

-- Přidat farnost
create procedure pridat_farnost
    @nazev varchar(80)
as 
    begin TRY
        insert into Farnosti(Jmeno) values (@nazev)
    end TRY
    begin CATCH
        throw 60008, 'Farnost se nepodařilo přidat, pravděpodobně již existuje jiná se stejným jménem', 0;
    end CATCH
go

-- Odstranit farnost - pozor na kostely, správce
create procedure odstranit_farnost
    @nazev varchar(80)
as
    begin tran
        begin TRY
            declare @farnost_id INTEGER;
            select @farnost_id = ID from Farnosti where Jmeno = @nazev;
            if @farnost_id IS null
                throw 60008, 'Farnost neexistuje', 0;
            if exists (SELECT * FROM Spravci where Farnost_ID = @farnost_id )
                throw 60008, 'Farnost má správce', 0;
            if exists (SELECT * FROM Kostely where Farnost_ID = @farnost_id )
                throw 60008, 'Farnost má kostely', 0;
            delete from Farnosti where Jmeno = @nazev;
        end TRY
        begin CATCH
            ROLLBACK tran;
            throw;
        end CATCH
    commit
go

/*
*   Kostely
*/

-- Přidat kostel
-- @params název farnosti, název kostela, souřadnice kostela - šířka & délka
create procedure pridat_kostel
    @farnost varchar(80),
    @nazev varchar(80),
    @lat FLOAT,
    @lng FLOAT
as 
    begin tran
        begin TRY
            declare @farnost_id INTEGER;
            select @farnost_id = ID from Farnosti where Jmeno = @farnost;
            if @farnost_id IS null
                throw 60008, 'Farnost neexistuje', 0;
            if exists (SELECT * FROM Kostely where Farnost_ID = @farnost_id and Jmeno = @nazev )
                throw 60008, 'Kostel s daným jménem již ve farnosti existuje', 0;
            if not (@lat <= 90 and @lat >= 0 and @lng <= 90 and @lng >= 0)
                throw 60008, 'Neplatné souřadnice', 0;
            insert into Kostely(Farnost_ID, Jmeno, PolohaLat, PolohaLng) VALUES
                (@farnost_id, @nazev, @lat, @lng);
        end TRY
        begin CATCH
            ROLLBACK tran;
            throw;
        end CATCH
    commit
go
-- Odstranit kostel i s udalostmi
create procedure odstranit_kostel
    @farnost varchar(80),
    @nazev varchar(80)
as
    begin tran
        begin TRY
            declare @farnost_id INTEGER, @kostel_id INTEGER;
            select @farnost_id = ID from Farnosti where Jmeno = @farnost;
            if @farnost_id IS null
                throw 60008, 'Farnost neexistuje', 0;

            select @kostel_id = ID from Kostely where Jmeno = @nazev and Farnost_ID = @farnost_id
            if @kostel_id IS null
                throw 60008, 'Kostel s daným jménem ve farnosti neexistuje', 0;
            delete from Kostely where ID = @kostel_id; 
        end TRY
        begin CATCH
            ROLLBACK tran;
            throw;
        end CATCH
    commit

go


/*
*   Správci
*/

-- Přidat správce
create procedure pridat_spravce
    @farnost VARCHAR(80),
    @jmeno VARCHAR(80),
    @farar BIT = 0
as
     begin tran
        begin TRY
            declare @farnost_id INTEGER;
            select @farnost_id = ID from Farnosti where Jmeno = @farnost;
            if @farnost_id IS null
                throw 60008, 'Farnost neexistuje', 0;
            INSERT INTO Spravci(Jmeno, Farar, Farnost_ID) VALUES
                (@jmeno, @farar, @farnost_id)  
        end TRY
        begin CATCH
            ROLLBACK tran;
            throw;
        end CATCH
    commit
go
-- Odstranit správce
create procedure odstranit_spravce
    @id INTEGER
AS
    begin tran
        begin TRY
            if exists(SELECT * FROM Udalosti_SvatostiSmireni where Zpovednik_ID = @id )
                throw 60008, 'Spravce ma neodstranene svatosti smireni', 0;      
            delete from Spravci where ID = @id;           
        end TRY
        begin CATCH
            ROLLBACK tran;
            throw;
        end CATCH
    commit
go 

/*
*   Události
*/
-- přidat mši
create procedure pridat_msi
    @kostel_id INTEGER, 
    @datum_a_cas DATETIME2,
    @nazev varchar(20), 
    @cteni1 varchar(20),
    @lektor1_ID INTEGER,
    @cteni2 varchar(20),
    @lektor2_ID INTEGER,
    @primluvy_nazev varchar(20),
    @lektor_primluvy_ID INTEGER
AS
begin tran
        begin TRY
            -- zkontrolovat, že všichni lektoři existují            
            if  (select count(*) from 
                    (SELECT * FROM Lektori where ID = @lektor1_ID or ID = @lektor2_ID or ID = @lektor_primluvy_ID ) 
                    as vnitrni
                ) != 3
                throw 60008, 'Neplatne ID lektora', 0;
            declare @cteni1_ID integer, @cteni2_ID integer, @primluvy_id integer;

            -- vlozime cteni 1 a jeho id ulozime do @cteni1_ID
            INSERT into Cteni(Lektor_ID, Nazev) VALUES
                (@lektor1_ID, @cteni1);
            SELECT @cteni1_ID = SCOPE_IDENTITY();

            -- cteni 2
            INSERT into Cteni(Lektor_ID, Nazev) VALUES
                (@lektor2_ID, @cteni2);
            SELECT @cteni2_ID = SCOPE_IDENTITY();
            
            -- primluvy
            INSERT into Cteni(Lektor_ID, Nazev) VALUES 
                (@lektor_primluvy_ID, @primluvy_nazev);
            SELECT @primluvy_ID = SCOPE_IDENTITY();

            -- Vložíme do mší a id mše uložíme do @mse_ID
            declare @mse_ID integer;
            INSERT INTO Mse(Cteni1, Cteni2, Primluvy) VALUES ( @cteni1_ID, @cteni2_ID, @primluvy_id );
            SELECT @mse_ID = SCOPE_IDENTITY();            
            -- vložíme mši do událostí
            INSERT INTO Udalosti(Konani,Kostel_ID,Nazev, Typ, UdalostDetail_ID) VALUES 
                (@datum_a_cas, @kostel_id, @nazev, 1, @mse_ID);
                    
        end TRY
        begin CATCH
            ROLLBACK tran;
            throw;
        end CATCH
    COMMIT

go

-- odstranit mši
create procedure odstranit_msi
    @mse_id INTEGER
AS
    -- odstranění z tabulky mší
    delete from Mse where ID = @mse_id;
    -- odstranění z tabulky událostí
    delete from Udalosti where Typ = 1 and UdalostDetail_ID = @mse_id;
go 

-- přidávání svátostí smíření
create procedure pridat_sv_smireni
    @kostel_id INTEGER, 
    @zpovednik_id INTEGER, 
    @datum_a_cas DATETIME2,
    @nazev varchar(20), 
    @delka integer
AS
    begin tran
        -- Vložíme do sv smireni a id mše uložíme do @sv_ID
        declare @sv_ID integer;
        INSERT INTO SvatostiSmireni(Delka, Zpovednik_ID) VALUES ( @delka, @zpovednik_id );
        SELECT @sv_ID = SCOPE_IDENTITY();            
        -- vložíme sv smíření do událostí
        INSERT INTO Udalosti(Konani,Kostel_ID,Nazev, Typ, UdalostDetail_ID) VALUES 
            (@datum_a_cas, @kostel_id, @nazev, 2, @sv_ID);
    commit
go

-- odstranit sv. smireni
create procedure odstranit_sv_smireni
    @sv_smireni_id INTEGER
AS
    -- odstranění z tabulky sv. smíření
    delete from SvatostiSmireni where ID = @sv_smireni_id;
    -- odstranění z tabulky událostí
    delete from Udalosti where Typ = 2 and UdalostDetail_ID = @sv_smireni_id;
go 


-- přidávání schůzek skupinek
create procedure pridat_schuzku_skupinek
    @kostel_id INTEGER,  
    @datum_a_cas DATETIME2,
    @nazev varchar(20), 
    @popis varchar(MAX)
AS
    begin tran
        -- Vložíme do sv smireni a id mše uložíme do @skup_ID
        declare @skup_ID integer;
        INSERT INTO SchuzkySkupinek(Popis) VALUES ( @popis );
        SELECT @skup_ID = SCOPE_IDENTITY();            
        -- vložíme sv smíření do událostí
        INSERT INTO Udalosti(Konani,Kostel_ID,Nazev, Typ, UdalostDetail_ID) VALUES 
            (@datum_a_cas, @kostel_id, @nazev, 3, @skup_ID);
    commit;
go

-- odstranit schuzku skupinek
create procedure odstranit_schuzku_skupinek
    @schuzka_ID INTEGER
AS
    -- odstranění z tabulky sv. smíření
    delete from SchuzkySkupinek where ID = @schuzka_ID;
    -- odstranění z tabulky událostí
    delete from Udalosti where Typ = 3 and UdalostDetail_ID = @schuzka_ID;
go 