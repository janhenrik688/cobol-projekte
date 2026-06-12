      ******************************************************************
      * Author:    Jan-Henrik Horwege
      * Date:      2026-06-05
      * Purpose:   Einfacher Taschenrechner mit + - * /
      *            Unterst�tzt Dezimalzahlen und negative Werte
      * Tectonics: cobc
      ******************************************************************

       IDENTIFICATION DIVISION.
      *---------------------------------------------------------------*
       PROGRAM-ID. CALCULATOR.
      *---------------------------------------------------------------*

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.

       DATA DIVISION.
      *---------------------------------------------------------------*

       FILE SECTION.
      *-----------------------

       WORKING-STORAGE SECTION.
      * Eingabestring (wird als Text gelesen und spaeter umgewandelt)
       01 INPUT-STR        PIC X(10).
      * Rechenvariablen
      * S = signed (erlaubt negative Zahlen)
      * V = implizites Dezimaltrennzeichen (zwei Nachkommastellen)
       01 ZAHL1            PIC S9(3)V99 VALUE 0.
       01 ZAHL2            PIC S9(3)V99 VALUE 0.

      * Ergebnisvariable mit mehr Stellen vor dem Komma
       01 ERGEBNIS         PIC S9(5)V99 VALUE 0.

      * Anzeigeformat:
      * -Z = fuehrende Leerzeichen statt Nullen, mit Vorzeichen
      * .99 = sichtbare Nachkommastellen
       01 ERGEBNIS-ANZEIGE PIC -Z(5).99.

      * Speichert die gewaehlte Rechenoperation (+ - * /)
       01 OPERATOR         PIC X.

      *---------------------------------------------------------------*
       PROCEDURE DIVISION.
      *---------------------------------------------------------------*

      **
      * Hauptprogramm:
      * 1. Zahlen einlesen
      * 2. Eingabe bereinigen (Komma zu Punkt)
      * 3. Umwandlung in numerische Werte
      * 4. Operation ausfuehren
      * 5. Ergebnis anzeigen
      **

           DISPLAY "Bitte erste Zahl eingeben: "
           ACCEPT INPUT-STR
           INSPECT INPUT-STR REPLACING ALL "," BY "."
           COMPUTE ZAHL1 = FUNCTION NUMVAL(INPUT-STR)

           DISPLAY "Bitte zweite Zahl eingeben: "
           ACCEPT INPUT-STR
           INSPECT INPUT-STR REPLACING ALL "," BY "."
           COMPUTE ZAHL2 = FUNCTION NUMVAL(INPUT-STR)

           DISPLAY "Operation waehlen (+ - * /): "
           ACCEPT OPERATOR

           EVALUATE OPERATOR
               WHEN "+"
                   COMPUTE ERGEBNIS = ZAHL1 + ZAHL2
               WHEN "-"
                   COMPUTE ERGEBNIS = ZAHL1 - ZAHL2
               WHEN "*"
                   COMPUTE ERGEBNIS = ZAHL1 * ZAHL2
               WHEN "/"
                   IF ZAHL2 = 0
                       DISPLAY "Fehler: Division durch 0!"
                       STOP RUN
                   END-IF
                   COMPUTE ERGEBNIS = ZAHL1 / ZAHL2
               WHEN OTHER
                   DISPLAY "Ungueltige Operation!"
                   STOP RUN
           END-EVALUATE

           MOVE ERGEBNIS TO ERGEBNIS-ANZEIGE

           DISPLAY "Ergebnis: " ERGEBNIS-ANZEIGE

           STOP RUN.
      
       END PROGRAM CALCULATOR.
