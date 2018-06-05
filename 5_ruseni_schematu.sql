drop procedure odstranit_schuzku_skupinek;
drop procedure pridat_schuzku_skupinek;
drop procedure odstranit_sv_smireni;
drop procedure pridat_sv_smireni;
drop procedure odstranit_msi;
drop procedure pridat_msi;
drop procedure odstranit_spravce;
drop procedure pridat_spravce;
drop procedure odstranit_kostel;
drop procedure pridat_kostel;
drop procedure odstranit_farnost;
drop procedure pridat_farnost;

drop view LektoriAFarnosti;
drop view SpravciAZpovediStatistiky;
drop view SpravciAZpovedi;
drop view FarnostiASpravci;
drop view FarnostiAKostely;
drop view Udalosti_SchuzkySkupinek;
drop view Udalosti_SvatostiSmireni;
drop view Udalosti_Mse;
drop view MseVeFarnostech;
drop view MsePodleLektoru;


delete from SchuzkySkupinek;
drop table SchuzkySkupinek;

delete from SvatostiSmireni;
drop table SvatostiSmireni;

delete from Mse;
drop table Mse;

delete from Cteni;
drop table Cteni;

delete from Lektori;
drop table Lektori;

delete from Udalosti;
drop table Udalosti;

delete from Spravci;
drop table Spravci;

delete from Kostely;
drop table Kostely;

delete from Farnosti;
drop table Farnosti;


