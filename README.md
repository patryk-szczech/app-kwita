📘 KWITARIUSZ SZKOŁY
Specyfikacja MVP – wersja 1.0

(Windows, Electron + SQLite, licencja jednorazowa)

1️⃣ ZAŁOŻENIA OGÓLNE

Aplikacja desktopowa na Windows

Praca offline

Maks. 600 uczniów

Jedna placówka = jedna licencja

Rozliczenie po faktycznej obecności

Dane przechowywane lokalnie (RODO-friendly)

2️⃣ STRUKTURA APLIKACJI (EKRANY)
🏠 Dashboard

bieżący miesiąc

liczba uczniów

suma należności

suma wpłat

lista zaległości

👥 Uczniowie

Lista uczniów

imię, nazwisko

grupa

status (aktywny / wypisany)

Karta ucznia

dane ucznia

przypisani rodzice

historia obecności

rozliczenia miesięczne

saldo

👨‍👩‍👧 Rodzice

imię i nazwisko

email

telefon

lista dzieci

zbiorcze saldo

🧩 Grupy

nazwa grupy

typ: przedszkole / szkoła

liczba uczniów

💰 Stawki

Dla każdej grupy:

Śniadanie

II śniadanie

Obiad

Podwieczorek

Pełna

Zasady:

stawka dzienna

historia zmian stawek

zmiana stawki NIE wpływa wstecz

📅 Obecności

widok kalendarza miesięcznego

obecny / nieobecny

dni wolne i święta (globalne)

tylko dni obecne są liczone do opłat

💳 Rozliczenia

automatyczne wyliczanie:

liczba dni obecnych × stawki

miesięczne zestawienie

saldo:

do zapłaty

nadpłata

zaległość

📄 Dokumenty

rachunek PDF

numeracja:

rok/miesiąc/numer

możliwość ponownego wygenerowania

⚙️ Ustawienia

dane placówki

rok szkolny

dni wolne

numeracja dokumentów

kopia zapasowa (eksport pliku bazy)

3️⃣ LOGIKA ROZLICZEŃ (KLUCZOWA)

System zlicza dni obecne

Pomija:

weekendy

dni wolne

Dla każdego dnia:

sumuje wybrane kategorie

Generuje miesięczne rozliczenie

Po zaksięgowaniu wpłaty:

aktualizuje saldo

4️⃣ STRUKTURA BAZY DANYCH (SQLite)

Główne tabele:

students

parents

student_parents

groups

rates

attendance

monthly_charges

payments

documents

settings

holidays

Każda tabela:

ID

daty utworzenia

brak fizycznego usuwania (status)

5️⃣ LICENCJA (TECHNICZNIE)

klucz licencyjny

przypisany do:

nazwy placówki

identyfikatora komputera

walidacja offline

brak abonamentu
