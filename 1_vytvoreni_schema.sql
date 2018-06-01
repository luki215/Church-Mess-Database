/* 
Máme farnost(1). Každá farnost má M správců(2), z nichž právě jeden musí být farář (integritní omezení).
Ke každé farnosti patří M kostelů (3). V těchto kostelích se konají události(4) různých druhů - pro tuto aplikaci jen Mše, 
svátost smíření a schůzka skupinek. Události obecně mají jen datum a čas konání + M kostelů, ke kterým se vztahují.
Dále máme lektory (5), kteří jsou přiřazeni k M čtením (6). Ke každé mši patří 3 různá čtení, kdy každé z nich musí 
mít přiřazeno právě jednoho lektora. 
*/


/* 
*
*  Tabulky
*
*/

create table Farnosti(
	ID INTEGER IDENTITY CONSTRAINT Farnosti_PK PRIMARY KEY,
	Jmeno VARCHAR(80) CONSTRAINT Farnosti_UNIQ_Jmeno UNIQUE NOT NULL
);

create table Kostely(
	ID INTEGER IDENTITY CONSTRAINT Kostely_PK PRIMARY KEY,
	Jmeno VARCHAR(80) NOT NULL,
	PolohaLat FLOAT NOT NULL,
	PolohaLng FLOAT NOT NULL,

	-- Patří k farnosti
	FaronstID INTEGER NOT NULL CONSTRAINT Kostely_FK_Faronst REFERENCES Farnosti(ID)
      ON DELETE NO ACTION,
	
	-- Unikátní jméno kostela ve farnosti
	constraint Kostely_UNIQ_FaronstID_Jmeno unique(FaronstID, Jmeno)
);


create table Spravci(
	ID INTEGER IDENTITY CONSTRAINT Spravci_PK PRIMARY KEY,

	Jmeno VARCHAR(40) NOT NULL,
	Farar BIT DEFAULT 0 NOT NULL,

	-- Spravují faronst
	FaronstID INTEGER NOT NULL CONSTRAINT Spravci_FK_Faronst REFERENCES Farnosti(ID)
      ON DELETE NO ACTION
);

-- TODO zkontrolovat farare prave jednou




create table Udalosti(
	ID INTEGER IDENTITY CONSTRAINT Udalosti_PK PRIMARY KEY,
	-- Typ udalosti = polymorfni sloupecek
	-- 1 = Mse
	-- 2 = SvatostiSmireni
	-- 3 = SchuzkySkupinek
	Typ Integer NOT NULL INDEX Udalosti_Typ_IDX,
	UdalostDetail_ID INTEGER NOT NULL INDEX Udalosti_UdalostDetail_IDX,
	Konani DATETIME2 NOT NULL INDEX Udalosti_Konani_IDX,
	Nazev VARCHAR(40),

	-- patří ke kostelu, pokud se kostel smaže, události již nemá smysl uchovávat
	Kostel_ID INTEGER NOT NULL CONSTRAINT Udalosti_FK_Kostel REFERENCES Kostely(ID)
		ON DELETE CASCADE
	);


create table Lektori(
	ID Integer IDENTITY CONSTRAINT Lektori_PK PRIMARY KEY,
	Jmeno Varchar(40) NOT NULL
);

create table Cteni(
	ID INTEGER IDENTITY CONSTRAINT Cteni_PK PRIMARY KEY,
	-- volitelně co se čte - např Ex 24,3-8
	Nazev VARCHAR(20),
	-- Lektor, který čte
	Lektor_ID INTEGER NOT NULL CONSTRAINT Cteni_FK_Lektor REFERENCES Lektori(ID)
		ON DELETE NO ACTION
);

-- Typ 1 v udalostech
create table Mse(
	ID INTEGER IDENTITY CONSTRAINT Mse_PK PRIMARY KEY,
	Cteni1 INTEGER NOT NULL CONSTRAINT Mse_FK_Cteni1 REFERENCES Cteni(ID)
		ON DELETE NO ACTION,	
	Cteni2 INTEGER NOT NULL CONSTRAINT Mse_FK_Cteni2 REFERENCES Cteni(ID)
		ON DELETE NO ACTION,
	Primluvy INTEGER NOT NULL CONSTRAINT MSE_FK_Primluvy REFERENCES CTENI(ID)
		ON DELETE NO ACTION	
);

-- Typ 2 v udalostech
create table SvatostiSmireni(
	ID INTEGER IDENTITY CONSTRAINT SvatostiSmireni_PK PRIMARY KEY,
	-- jak dlouho se zpovida - v minutach
	Delka INTEGER NOT NULL,
	-- kdo zpovida
	Zpovednik_ID INTEGER NOT NULL CONSTRAINT SvatostiSmireni_FK_Sprace REFERENCES Spravci(ID)
		ON DELETE NO ACTION,

	CONSTRAINT SvatostSmireniDelkaKladna check(Delka>0)
);


-- Typ 3 v udalostech
create table SchuzkySkupinek(
	ID INTEGER IDENTITY CONSTRAINT SchuzkySkupinek_PK PRIMARY KEY,
	Popis VARCHAR(MAX)
);



/*
*
*	Pohledy
*
*/

