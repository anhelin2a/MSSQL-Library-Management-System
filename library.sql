/*
		Struktura pliku:
		A - tworzenie bazy danych i tabel
		B - dodanie ograniczeń
		C - wstawienie danych
		D - procedury wyporzyczenia książki
		E - statystyka wyporzyczeń 
*/


/* *********************************************************************************************************************************************************** */
--	A - tworzenie bazy danych i tabel
/* *********************************************************************************************************************************************************** */
CREATE DATABASE Library

IF DB_ID('Library') IS NULL
BEGIN 
	CREATE DATABASE Library
END

USE Library

CREATE TABLE [Czytelnicy] (
	[CzytelnikID] int IDENTITY(1,1) NOT NULL,
	[Imię] nvarchar(50) NOT NULL,
	[Nazwisko] nvarchar(50) NOT NULL,
	[DokumentID] nvarchar(5) NOT NULL,
	[NumerDokumentu] int NOT NULL,
	[Pesel] nvarchar(11) NOT NULL UNIQUE,
	[DataUrodzenia] date,
	[MiejsceUrodzenia] int,
	[NrTelefonu] nvarchar(9) NOT NULL UNIQUE,
	[KodZamieszkania] nvarchar(6) NOT NULL,
	[TypNazwy] nvarchar(5) NOT NULL,     -- na przykład "ul.", "al.", "pl." itp
	[UlZamieszkania] nvarchar(50) NOT NULL,
	[NrUlicy] int NOT NULL,
	[NrMieszkania] int NOT NULL,
	[IlośćWyporzyczonychPozycji] int NOT NULL,
	PRIMARY KEY ([CzytelnikID])
);

CREATE TABLE [Województwa] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[Nazwa] int NOT NULL UNIQUE,
	PRIMARY KEY ([ID])
);

CREATE TABLE [Biblioteki] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[Nazwa] nvarchar(50) NOT NULL,
	[Ulica] nvarchar(50) NOT NULL,
	[KodPocztowy] nvarchar(6) NOT NULL,
	[Miasto] nvarchar(50) NOT NULL,
	[Województwo] int NOT NULL,
	[RejestrWyporzyczeń] int NOT NULL,
	PRIMARY KEY ([ID])
);

CREATE TABLE [Wyporzyczenia] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[Rejestr] int NOT NULL,
	[CzytelnikID] int NOT NULL,
	[TerminZwrotu] datetime NOT NULL,
	[TerminOddania] datetime NOT NULL,
	[CzasWyporzyczenia] datetime NOT NULL,
	[EgzemplarzID] int NOT NULL,
	PRIMARY KEY ([ID])
);

CREATE TABLE [Wydawnictwa] (
	[WydawnictwoID] int IDENTITY(1,1) NOT NULL,
	[Nazwa] nvarchar(50) NOT NULL,
	PRIMARY KEY ([WydawnictwoID])
);

CREATE TABLE [Publikacje] (
	[IDPublikacji] int IDENTITY(1,1) NOT NULL,
	[Tytuł] nvarchar(50) NOT NULL,
	[Autor] int NOT NULL,
	[Wydawnictwo] int NOT NULL,
	[Kategoria] int NOT NULL,
	[NrSzafki] int NOT NULL,
	[IlośćEgzemplarzy] int NOT NULL DEFAULT 0,
	[RokWydania] datetime NOT NULL,
	[MiejsceWydania] nvarchar(50) NOT NULL,
	PRIMARY KEY ([IDPublikacji])
);

CREATE TABLE [Kategorie] (
	[IDKategorii] int IDENTITY(1,1) NOT NULL,
	[Nazwa] nvarchar(50) NOT NULL,
	[KategoriaNadrzędna] int,
	PRIMARY KEY ([IDKategorii])
);

CREATE TABLE [Egzemplarze] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[IDpublikacji] int NOT NULL,
	[Stan] int NOT NULL DEFAULT 1, -- 0 kiedy jest uszkodzona bądź zaginęła, 2 jeżeli wypożyczona
	PRIMARY KEY ([ID])
);

CREATE TABLE [Autorzy] (
	[AutorID] int IDENTITY(1,1) NOT NULL,
	[Imię] nvarchar(50) NOT NULL,
	[Nazwisko] nvarchar(50) NOT NULL,
	[DataUrodzenia] datetime NOT NULL,
	[MiejsceZamieszkania] nvarchar(50) NOT NULL,
	PRIMARY KEY ([AutorID])
);

CREATE TABLE [AutorzyPuplikacje] (
	[AutorID] int NOT NULL,
	[PublikacjaID] int NOT NULL,
	PRIMARY KEY ([AutorID], [PublikacjaID])
);


/* *********************************************************************************************************************************************************** */
--	B - dodanie ograniczeń
/* *********************************************************************************************************************************************************** */


ALTER TABLE [Czytelnicy] ADD CONSTRAINT [Czytelnicy_fk7] FOREIGN KEY ([MiejsceUrodzenia]) REFERENCES [Województwa]([ID]);

ALTER TABLE [Biblioteki] ADD CONSTRAINT [Biblioteki_fk5] FOREIGN KEY ([Województwo]) REFERENCES [Województwa]([ID]);
ALTER TABLE [Wyporzyczenia] ADD CONSTRAINT [Wyporzyczenia_fk1] FOREIGN KEY ([Rejestr]) REFERENCES [Biblioteki]([RejestrWyporzyczeń]);

ALTER TABLE [Wyporzyczenia] ADD CONSTRAINT [Wyporzyczenia_fk2] FOREIGN KEY ([CzytelnikID]) REFERENCES [Czytelnicy]([CzytelnikID]);

ALTER TABLE [Wyporzyczenia] ADD CONSTRAINT [Wyporzyczenia_fk6] FOREIGN KEY ([EgzemplarzID]) REFERENCES [Egzemplarze]([ID]);

ALTER TABLE [Publikacje] ADD CONSTRAINT [Publikacje_fk3] FOREIGN KEY ([Wydawnictwo]) REFERENCES [Wydawnictwa]([WydawnictwoID]);

ALTER TABLE [Publikacje] ADD CONSTRAINT [Publikacje_fk4] FOREIGN KEY ([Kategoria]) REFERENCES [Kategorie]([IDKategorii]);
ALTER TABLE [Kategorie] ADD CONSTRAINT [Kategorie_fk2] FOREIGN KEY ([KategoriaNadrzędna]) REFERENCES [Kategorie]([IDKategorii]);
ALTER TABLE [Egzemplarze] ADD CONSTRAINT [Egzemplarze_fk1] FOREIGN KEY ([IDpublikacji]) REFERENCES [Publikacje]([IDPublikacji]);

ALTER TABLE [AutorzyPuplikacje] ADD CONSTRAINT [AutorzyPuplikacje_fk0] FOREIGN KEY ([AutorID]) REFERENCES [Autorzy]([AutorID]);

ALTER TABLE [AutorzyPuplikacje] ADD CONSTRAINT [AutorzyPuplikacje_fk1] FOREIGN KEY ([PublikacjaID]) REFERENCES [Publikacje]([IDPublikacji]);


/* *********************************************************************************************************************************************************** */
--	B - wstawienie danych
/* *********************************************************************************************************************************************************** */

-- Tabela Województwa

INSERT INTO [Województwa] ([Nazwa]) VALUES ('Mazowieckie');
INSERT INTO [Województwa] ([Nazwa]) VALUES ('Śląskie');
INSERT INTO [Województwa] ([Nazwa]) VALUES ('Małopolskie');
INSERT INTO [Województwa] ([Nazwa]) VALUES ('Pomorskie');
INSERT INTO [Województwa] ([Nazwa]) VALUES ('Dolnośląskie');
INSERT INTO [Województwa] ([Nazwa]) VALUES ('Wielkopolskie');
INSERT INTO [Województwa] ([Nazwa]) VALUES ('Podkarpackie');
INSERT INTO [Województwa] ([Nazwa]) VALUES ('Lubelskie');
INSERT INTO [Województwa] ([Nazwa]) VALUES ('Podlaskie');
INSERT INTO [Województwa] ([Nazwa]) VALUES ('Warmińsko-Mazurskie');



-- Tabela Biblioteki

INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Główna', 'Marszałkowska 1', '00-001', 'Warszawa', 1, 100);
INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Śląska', 'Korfantego 2', '40-001', 'Katowice', 2, 200);
INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Krakowska', 'Wielicka 3', '30-001', 'Kraków', 3, 300);
INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Gdańska', 'Długa 4', '80-001', 'Gdańsk', 4, 400);
INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Wrocławska', 'Wita Stwosza 5', '50-001', 'Wrocław', 5, 500);
INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Poznańska', 'Święty Marcin 6', '60-001', 'Poznań', 6, 600);
INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Rzeszowska', '3 Maja 7', '35-001', 'Rzeszów', 7, 700);
INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Lubelska', 'Krakowskie Przedmieście 8', '20-001', 'Lublin', 8, 800);
INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Białostocka', 'Lipowa 9', '15-001', 'Białystok', 9, 900);
INSERT INTO [Biblioteki] ([Nazwa], [Ulica], [KodPocztowy], [Miasto], [Województwo], [RejestrWyporzyczeń])
VALUES ('Biblioteka Olsztyńska', 'Stare Miasto 10', '10-001', 'Olsztyn', 10, 1000);



-- Tabela Czytelnicy

INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Zofia', 'Kamińska', 'P', 56789, '12345678912', '1995-04-04', 4, '111111111', '03-001', 'ul.', 'Krucza', 4, 4, 4);
INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Krzysztof', 'Lewandowski', 'D', 67890, '23456789023', '1988-05-05', 5, '222222222', '04-001', 'al.', 'Niepodległości', 5, 5, 2);
INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Marek', 'Nowicki', 'P', 78901, '34567890134', '1990-06-06', 6, '333333333', '05-001', 'pl.', 'Konstytucji', 6, 6, 3);
INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Jolanta', 'Szymańska', 'D', 89012, '45678901245', '1992-07-07', 7, '444444444', '06-001', 'ul.', 'Szpitalna', 7, 7, 1);
INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Patryk', 'Olszewski', 'P', 90123, '56789012356', '1987-08-08', 8, '555555555', '07-001', 'al.', 'Jana Pawła II', 8, 8, 5);
INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Agnieszka', 'Zielińska', 'D', 12345, '67890123467', '1989-09-09', 9, '666666666', '08-001', 'pl.', 'Narutowicza', 9, 9, 6);
INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Tomasz', 'Lis', 'P', 23456, '78901234578', '1986-10-10', 10, '777777777', '09-001', 'ul.', 'Mokotowska', 10, 10, 7);
INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Ewa', 'Dąbrowska', 'D', 34567, '89012345689', '1985-11-11', 1, '888888888', '10-001', 'al.', 'Puławska', 11, 11, 8);
INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Karol', 'Kaczmarek', 'P', 45678, '90123456790', '1991-12-12', 2, '999999999', '11-001', 'pl.', 'Stary Rynek', 12, 12, 9);
INSERT INTO [Czytelnicy] ([Imię], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IlośćWyporzyczonychPozycji])
VALUES ('Monika', 'Pawlak', 'D', 56789, '01234567801', '1993-01-13', 3, '000000000', '12-001', 'ul.', 'Grochowska', 13, 13, 10);



-- Tabela Kategorie

INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('Fiction', NULL);
INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('Non-Fiction', NULL);
INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('Science Fiction', 1);
INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('Fantasy', 1);
INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('Biography', 2);
INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('History', 2);
INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('Romance', 1);
INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('Mystery', 1);
INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('Thriller', 1);
INSERT INTO [Kategorie] ([Nazwa], [KategoriaNadrzędna]) VALUES ('Children', 1);



-- Tabela Autorzy

INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Stanisław', 'Lem', '1921-09-12', 'Kraków');
INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Andrzej', 'Sapkowski', '1948-06-21', 'Wrocław');
INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Olga', 'Tokarczuk', '1962-01-29', 'Wałbrzych');
INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Henryk', 'Sienkiewicz', '1846-05-05', 'Wola Okrzejska');
INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Adam', 'Mickiewicz', '1798-12-24', 'Zaosie');
INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Bolesław', 'Prus', '1847-08-20', 'Hrubieszów');
INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Maria', 'Konopnicka', '1842-05-23', 'Suwałki');
INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Juliusz', 'Słowacki', '1809-09-04', 'Krzemieniec');
INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Czesław', 'Miłosz', '1911-06-30', 'Szetejnie');
INSERT INTO [Autorzy] ([Imię], [Nazwisko], [DataUrodzenia], [MiejsceZamieszkania]) VALUES ('Jan', 'Kochanowski', '1530-06-24', 'Sycyna');



-- Tabela Wydawnictwa

INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo Literackie');
INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo Znak');
INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo Prószyński i S-ka');
INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo W.A.B.');
INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo Albatros');
INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo Rebis');
INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo Fabryka Słów');
INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo Amber');
INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo Iskry');
INSERT INTO [Wydawnictwa] ([Nazwa]) VALUES ('Wydawnictwo Akapit Press');



-- Tabela Publikacje 

INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Solaris', 1, 1, 3, 101, 10, '1961-01-01', 'Warszawa');
INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Wiedźmin', 2, 7, 4, 102, 8, '1993-01-01', 'Warszawa');
INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Bieguni', 3, 2, 2, 103, 6, '2007-01-01', 'Warszawa');
INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Quo Vadis', 4, 3, 6, 104, 5, '1896-01-01', 'Warszawa');
INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Pan Tadeusz', 5, 4, 6, 105, 7, '1834-01-01', 'Warszawa');
INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Lalka', 6, 5, 6, 106, 9, '1890-01-01', 'Warszawa');
INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Rota', 7, 8, 6, 107, 6, '1908-01-01', 'Warszawa');
INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Kordian', 8, 3, 2, 108, 8, '1834-01-01', 'Warszawa');
INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Dolina Issy', 9, 6, 2, 109, 7, '1955-01-01', 'Warszawa');
INSERT INTO [Publikacje] ([Tytuł], [Autor], [Wydawnictwo], [Kategoria], [NrSzafki], [IlośćEgzemplarzy], [RokWydania], [MiejsceWydania])
VALUES ('Pieśń Świętojańska', 10, 9, 2, 110, 6, '1586-01-01', 'Warszawa');



-- Tabela Egzemplarze

INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (1, 1);
INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (1, 1);
INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (1, 1);
INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (1, 1);
INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (1, 1);
INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (1, 1);
INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (2, 1);
INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (2, 1);
INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (2, 1);
INSERT INTO [Egzemplarze] ([IDpublikacji], [Stan]) VALUES (2, 1);


-- Tabela Wyporzyczenia

INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (100, 1, '2024-05-01 00:00:00', NULL, '2024-04-01 00:00:00', 1);
INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (100, 2, '2024-05-02 00:00:00', NULL, '2024-04-02 00:00:00', 2);
INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (200, 3, '2024-05-03 00:00:00', NULL, '2024-04-03 00:00:00', 3);
INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (200, 4, '2024-05-04 00:00:00', NULL, '2024-04-04 00:00:00', 4);
INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (300, 5, '2024-05-05 00:00:00', NULL, '2024-04-05 00:00:00', 5);
INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (300, 6, '2024-05-06 00:00:00', NULL, '2024-04-06 00:00:00', 6);
INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (400, 7, '2024-05-07 00:00:00', NULL, '2024-04-07 00:00:00', 7);
INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (400, 8, '2024-05-08 00:00:00', NULL, '2024-04-08 00:00:00', 8);
INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (500, 9, '2024-05-09 00:00:00', NULL, '2024-04-09 00:00:00', 9);
INSERT INTO [Wyporzyczenia] ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWyporzyczenia], [EgzemplarzID])
VALUES (500, 10, '2024-05-10 00:00:00', NULL, '2024-04-10 00:00:00', 10);



/* *********************************************************************************************************************************************************** */
--	D - procedury wyporzyczenia książki
/* *********************************************************************************************************************************************************** */


CREATE PROCEDURE SprawdzCzyUzytkownikIstnieje
    @NumerDokumentu INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Czytelnicy
        WHERE NumerDokumentu = @NumerDokumentu
    )
    BEGIN
        RETURN 1 -- Użytkownik istnieje
    END
    ELSE
    BEGIN
        RETURN 0 -- Użytkownik nie istnieje
    END
END


CREATE PROCEDURE DodajUzytkownika
    @Imie NVARCHAR(50),
    @Nazwisko NVARCHAR(50),
    @DokumentID NVARCHAR(5),
    @NumerDokumentu INT,
    @Pesel NVARCHAR(11),
    @DataUrodzenia DATE,
    @MiejsceUrodzenia INT,
    @NrTelefonu NVARCHAR(9),
    @KodZamieszkania NVARCHAR(6),
    @TypNazwy NVARCHAR(5),
    @UlZamieszkania NVARCHAR(50),
    @NrUlicy INT,
    @NrMieszkania INT
    
AS
BEGIN
    -- Sprawdzenie, czy użytkownik z takim numerem dokumentu już istnieje
    DECLARE @CzyIstnieje INT
    EXEC @CzyIstnieje = SprawdzCzyUzytkownikIstnieje @NumerDokumentu
    
    IF @CzyIstnieje = 1
    BEGIN
        RETURN 2 -- Użytkownik z takim numerem dokumentu już istnieje
    END
    
    -- Dodanie nowego użytkownika
    INSERT INTO Czytelnicy ([Imie], [Nazwisko], [DokumentID], [NumerDokumentu], [Pesel], [DataUrodzenia], [MiejsceUrodzenia], [NrTelefonu], [KodZamieszkania], [TypNazwy], [UlZamieszkania], [NrUlicy], [NrMieszkania], [IloscWypozyczonychPozycji])
    VALUES (@Imie, @Nazwisko, @DokumentID, @NumerDokumentu, @Pesel, @DataUrodzenia, @MiejsceUrodzenia, @NrTelefonu, @KodZamieszkania, @TypNazwy, @UlZamieszkania, @NrUlicy, @NrMieszkania, 0)

    RETURN 0 -- Sukces
END


CREATE PROCEDURE WypozyczKsiazke
    @CzytelnikID INT,
    @IDPublikacji INT,
    @TerminZwrotu DATETIME
AS
BEGIN
    -- Sprawdzenie, czy użytkownik istnieje
    DECLARE @CzyIstnieje INT
    EXEC @CzyIstnieje = SprawdzCzyUzytkownikIstnieje @CzytelnikID
    
    IF @CzyIstnieje = 0
    BEGIN
        RETURN 1 -- Użytkownik nie istnieje
    END
    
    -- Sprawdzenie, czy użytkownik nie ma już 5 wypożyczonych książek
    DECLARE @IloscWypozyczonych INT
    SELECT @IloscWypozyczonych = IloscWypozyczonychPozycji 
    FROM Czytelnicy 
    WHERE CzytelnikID = @CzytelnikID
    
    IF @IloscWypozyczonych >= 5
    BEGIN
        RETURN 2 -- Użytkownik ma już 5 wypożyczonych książek
    END
    
    -- Sprawdzenie, czy jest dostępny egzemplarz publikacji
    DECLARE @WolnyEgzemplarz INT
    SELECT TOP 1 @WolnyEgzemplarz = ID 
    FROM Egzemplarze 
    WHERE IDPublikacji = @IDPublikacji AND Stan = 1
    
    IF @WolnyEgzemplarz IS NULL
    BEGIN
        RETURN 3 -- Brak wolnego egzemplarza
    END
    
    -- Aktualizacja stanu egzemplarza
    UPDATE Egzemplarze 
    SET Stan = 2 -- Wypożyczony
    WHERE ID = @WolnyEgzemplarz
    
    -- Dodanie rekordu wypożyczenia
    INSERT INTO Wypozyczzenia ([Rejestr], [CzytelnikID], [TerminZwrotu], [TerminOddania], [CzasWypozyczenia], [EgzemplarzID])
    VALUES (1, @CzytelnikID, @TerminZwrotu, NULL, GETDATE(), @WolnyEgzemplarz)
    
    -- Zaktualizowanie liczby wypożyczonych książek przez użytkownika
    UPDATE Czytelnicy 
    SET IloscWypozyczonychPozycji = IloscWypozyczonychPozycji + 1 
    WHERE CzytelnikID = @CzytelnikID
    
    RETURN 0 -- Sukces
END


CREATE PROCEDURE OddajKsiazke
    @EgzemplarzID INT,
    @CzytelnikID INT,
    @CzyUszkodzona BIT, -- 1 jeśli uszkodzona/zaginiona, 0 jeśli w dobrym stanie
AS
BEGIN
    DECLARE @WypozyczenieID INT
    DECLARE @IloscWypozyczonych INT

    -- Sprawdzenie, czy egzemplarz był wypożyczony
    SELECT TOP 1 @WypozyczenieID = ID 
    FROM Wyporzyczenia 
    WHERE EgzemplarzID = @EgzemplarzID 
      AND CzytelnikID = @CzytelnikID 
      AND TerminOddania IS NULL
    
    IF @WypozyczenieID IS NULL
    BEGIN
        RETURN 1 -- Brak aktywnego wypożyczenia dla tego egzemplarza
    END
    
    -- Ustawienie daty oddania i zaktualizowanie egzemplarza
    UPDATE Wyporzyczenia 
    SET TerminOddania = GETDATE() 
    WHERE ID = @WypozyczenieID
    
    IF @CzyUszkodzona = 1
    BEGIN
        -- Jeśli książka jest uszkodzona lub zaginiona, ustawiamy stan na 0
        UPDATE Egzemplarze 
        SET Stan = 0 
        WHERE ID = @EgzemplarzID
    END
    ELSE
    BEGIN
        -- Jeśli książka jest w dobrym stanie, ustawiamy stan na 1
        UPDATE Egzemplarze 
        SET Stan = 1 
        WHERE ID = @EgzemplarzID
    END
    
    -- Zmniejszenie liczby wypożyczonych pozycji dla użytkownika
    UPDATE Czytelnicy 
    SET IloscWypozyczonychPozycji = IloscWypozyczonychPozycji - 1 
    WHERE CzytelnikID = @CzytelnikID
    
    RETURN 0 -- Sukces
END



/* *********************************************************************************************************************************************************** */
--	E - statystyka wyporzyczeń 
/* *********************************************************************************************************************************************************** */

WITH WypozyczeniaKategorii AS (
    SELECT 
        Publikacje.IDPublikacji,
        Publikacje.Tytuł,
        Publikacje.Kategoria,
        Kategorie.Nazwa AS NazwaKategorii,
        COUNT(Wyporzyczenia.ID) AS LiczbaWyporzyczen
    FROM 
        Wyporzyczenia
    JOIN 
        Egzemplarze ON Wyporzyczenia.EgzemplarzID = Egzemplarze.ID
    JOIN 
        Publikacje ON Egzemplarze.IDPublikacji = Publikacje.IDPublikacji
    JOIN 
        Kategorie ON Publikacje.Kategoria = Kategorie.IDKategorii
    GROUP BY 
        Publikacje.IDPublikacji, Publikacje.Tytuł, Publikacje.Kategoria, Kategorie.Nazwa
)
SELECT 
    Kategoria, 
    NazwaKategorii, 
    Tytuł, 
    MAX(LiczbaWyporzyczen) AS NajczesciejWypozyczanaLiczba
FROM 
    WypozyczeniaKategorii
GROUP BY 
    Kategoria, NazwaKategorii, Tytuł
ORDER BY 
    Kategoria, NajczesciejWypozyczanaLiczba DESC


SELECT 
    Kategorie.IDKategorii, 
    Kategorie.Nazwa AS NazwaKategorii, 
    COUNT(Wyporzyczenia.ID) AS LiczbaWyporzyczen
FROM 
    Wyporzyczenia
JOIN 
    Egzemplarze ON Wyporzyczenia.EgzemplarzID = Egzemplarze.ID
JOIN 
    Publikacje ON Egzemplarze.IDPublikacji = Publikacje.IDPublikacji
JOIN 
    Kategorie ON Publikacje.Kategoria = Kategorie.IDKategorii
GROUP BY 
    Kategorie.IDKategorii, Kategorie.Nazwa
ORDER BY 
    Kategorie.IDKategorii
