      ******************************************************************
      * Author:    Jan-Henrik Horwege
      * Date:      2026-06-08
      * Purpose:   Einfacher Taschenrechner mit + - * /
      *            Unterstuetzt Dezimalzahlen und negative Werte
      *            Eingabe als String
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
       01 FORMEL           PIC X(20).
       01 TEIL1            PIC X(10).
       01 TEIL2            PIC X(10).
       01 OPERATOR         PIC X.
       01 POS              PIC 9(2).
       01 FORMEL-LEN       PIC 9(2).
       01 LEN1             PIC 9(2).
       01 LEN2             PIC 9(2).

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


      *---------------------------------------------------------------*
       PROCEDURE DIVISION.
      *---------------------------------------------------------------*

       MAIN-PROCEDURE.
           DISPLAY "Formel eingeben: "
           ACCEPT FORMEL

      *    Komma zu Punkt
           INSPECT FORMEL REPLACING ALL "," BY "."

           MOVE FUNCTION LENGTH(FUNCTION TRIM(FORMEL)) TO FORMEL-LEN
           MOVE SPACES TO OPERATOR
           MOVE SPACES TO TEIL1
           MOVE SPACES TO TEIL2

           PERFORM VARYING POS FROM 1 BY 1 UNTIL POS > FORMEL-LEN
               IF FORMEL(POS:1) = "+" OR FORMEL(POS:1) = "*" OR
                   FORMEL(POS:1) = "/"

                   MOVE FORMEL(POS:1) TO OPERATOR

                   COMPUTE LEN1 = POS - 1
                   COMPUTE LEN2 = FORMEL-LEN - POS

                   MOVE FORMEL(1:LEN1) TO TEIL1
                   MOVE FORMEL(POS + 1:LEN2) TO TEIL2

                   EXIT PERFORM

               ELSE
                   IF FORMEL(POS:1) = "-" AND POS > 1

                       MOVE FORMEL(POS:1) TO OPERATOR

                       COMPUTE LEN1 = POS - 1
                       COMPUTE LEN2 = FORMEL-LEN - POS

                       MOVE FORMEL(1:LEN1) TO TEIL1
                       MOVE FORMEL(POS + 1:LEN2) TO TEIL2

                       EXIT PERFORM

                   END-IF
               END-IF
           END-PERFORM

           IF OPERATOR = SPACE OR TEIL1 = SPACES OR TEIL2 = SPACES
               DISPLAY "Ungueltige Formel!"
               STOP RUN
           END-IF

           COMPUTE ZAHL1 = FUNCTION NUMVAL(TEIL1)
           COMPUTE ZAHL2 = FUNCTION NUMVAL(TEIL2)

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
      ** add other procedures here
       END PROGRAM CALCULATOR.
