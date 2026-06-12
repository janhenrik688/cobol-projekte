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

       01 OUTPUT-LINE       PIC X(60) VALUE SPACES.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           DISPLAY "Bitte geben Sie einen Text ein: "
           ACCEPT USER-TEXT

           *> L�nge des Textes bestimmen (ohne Leerzeichen am Ende)
           MOVE FUNCTION LENGTH(FUNCTION TRIM(USER-TEXT)) TO LEN

           *> String umkehren
           MOVE SPACES TO REVERSED-TEXT
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LEN
               MOVE USER-TEXT(LEN - I + 1:1) TO REVERSED-TEXT(I:1)
           END-PERFORM

           *> Ausgabe
           MOVE SPACES TO OUTPUT-LINE
           STRING
               "Umgekehrter Text: " 
               FUNCTION TRIM(REVERSED-TEXT(1:LEN))
               DELIMITED BY SIZE
           INTO OUTPUT-LINE
           END-STRING

           DISPLAY "Sie haben eingegeben: " FUNCTION TRIM(USER-TEXT)
           DISPLAY "---------------------------------------------------"
           DISPLAY "Der umgekehrte Text lautet: " 
           FUNCTION TRIM(REVERSED-TEXT)
           DISPLAY OUTPUT-LINE

           STOP RUN.

       END PROGRAM STRING-SAVE-PRINT-REVERSE.
