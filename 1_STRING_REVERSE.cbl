      ******************************************************************
      * Author:    Jan-Henrik Horwege
      * Date:      2026-06-05
      * Purpose:   training
      * Tectonics: cobc
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. STRING-SAVE-PRINT-REVERSE.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.

       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01 USER-TEXT        PIC X(30) VALUE SPACES.
       01 REVERSED-TEXT    PIC X(30) VALUE SPACES.
       01 I                PIC 99.
       01 LEN              PIC 99.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           DISPLAY "Bitte geben Sie einen Text ein: "
           ACCEPT USER-TEXT

           *> Länge des Textes bestimmen (ohne Leerzeichen am Ende)
           MOVE FUNCTION LENGTH(FUNCTION TRIM(USER-TEXT)) TO LEN

           *> String umkehren
           MOVE SPACES TO REVERSED-TEXT
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LEN
               MOVE USER-TEXT(LEN - I + 1:1) TO REVERSED-TEXT(I:1)
           END-PERFORM

           *> Ausgabe
           DISPLAY "Sie haben eingegeben: " FUNCTION TRIM(USER-TEXT)
           DISPLAY "---------------------------------------------------"
           DISPLAY "Umgekehrt: " FUNCTION TRIM(REVERSED-TEXT)

           STOP RUN.

       END PROGRAM STRING-SAVE-PRINT-REVERSE.
