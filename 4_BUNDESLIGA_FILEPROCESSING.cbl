       IDENTIFICATION DIVISION.
       PROGRAM-ID. BUNDESLIGA.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO "bundesliga_resultate.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE ASSIGN TO "bundesliga_tabelle.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD           PIC X(100).
       
       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD          PIC X(150).
       
       WORKING-STORAGE SECTION.
       01  WS-EOF                 PIC X VALUE 'N'.
       01  WS-TEAMS.
           05  WS-TEAM OCCURS 30 TIMES.
               10  WS-NAME        PIC X(30).
               10  WS-SPIELE      PIC 99 VALUE 0.
               10  WS-TORE        PIC 99 VALUE 0.
               10  WS-GEGENTORE   PIC 99 VALUE 0.
               10  WS-PUNKTE      PIC 99 VALUE 0.
       
       01  WS-TEAM-COUNT          PIC 99 VALUE 0.
       01  WS-I                   PIC 99.
       01  WS-J                   PIC 99.
       01  WS-FOUND               PIC 9 VALUE 0.
       01  WS-HOME                PIC X(30).
       01  WS-AWAY                PIC X(30).
       01  WS-HOME-G              PIC 99.
       01  WS-AWAY-G              PIC 99.
       01  WS-DIFF                PIC S99.
       
       01  WS-TEMP-NAME           PIC X(30).
       01  WS-TEMP-SPIELE         PIC 99.
       01  WS-TEMP-TORE           PIC 99.
       01  WS-TEMP-GEGENTORE      PIC 99.
       01  WS-TEMP-PUNKTE         PIC 99.
       
       01  WS-OUT-DIFF-STR        PIC X(3).
       01  WS-DIFF-ABS            PIC 99.
       
       01  WS-OUT-LINE.
           05  WS-OUT-PLATZ       PIC 99.
           05  FILLER             PIC X VALUE ';'.
           05  WS-OUT-NAME        PIC X(30).
           05  FILLER             PIC X VALUE ';'.
           05  WS-OUT-SPIELE      PIC 99.
           05  FILLER             PIC X VALUE ';'.
           05  WS-OUT-TORE        PIC 99.
           05  FILLER             PIC X VALUE ';'.
           05  WS-OUT-GEGENTORE   PIC 99.
           05  FILLER             PIC X VALUE ';'.
           05  WS-OUT-DIFF-NUM    PIC X(3).
           05  FILLER             PIC X VALUE ';'.
           05  WS-OUT-PUNKTE      PIC 99.
       
       PROCEDURE DIVISION.
           OPEN INPUT INPUT-FILE.
           
           PERFORM UNTIL WS-EOF = 'Y'
               READ INPUT-FILE
                   AT END 
                       MOVE 'Y' TO WS-EOF
                   NOT AT END 
                       PERFORM PROCESS-CSV-LINE
               END-READ
           END-PERFORM.
           
           CLOSE INPUT-FILE.
           PERFORM SORT-TEAMS.
           PERFORM OUTPUT-RESULTS.
           STOP RUN.
       
       PROCESS-CSV-LINE.
           MOVE SPACES TO WS-HOME.
           MOVE SPACES TO WS-AWAY.
           MOVE 0 TO WS-HOME-G.
           MOVE 0 TO WS-AWAY-G.
           
           UNSTRING INPUT-RECORD DELIMITED BY ";"
               INTO WS-HOME WS-AWAY WS-HOME-G WS-AWAY-G
           END-UNSTRING.
           
           MOVE FUNCTION TRIM(WS-HOME) TO WS-HOME.
           MOVE FUNCTION TRIM(WS-AWAY) TO WS-AWAY.
           
           PERFORM ADD-TO-HOME-TEAM.
           PERFORM ADD-TO-AWAY-TEAM.
       
       ADD-TO-HOME-TEAM.
           MOVE 0 TO WS-FOUND.
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-TEAM-COUNT
               IF WS-NAME(WS-I) = WS-HOME
                   MOVE 1 TO WS-FOUND
                   ADD 1 TO WS-SPIELE(WS-I)
                   ADD WS-HOME-G TO WS-TORE(WS-I)
                   ADD WS-AWAY-G TO WS-GEGENTORE(WS-I)
                   IF WS-HOME-G > WS-AWAY-G
                       ADD 3 TO WS-PUNKTE(WS-I)
                   ELSE
                       IF WS-HOME-G = WS-AWAY-G
                           ADD 1 TO WS-PUNKTE(WS-I)
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.
           
           IF WS-FOUND = 0
               ADD 1 TO WS-TEAM-COUNT
               MOVE WS-HOME TO WS-NAME(WS-TEAM-COUNT)
               MOVE 1 TO WS-SPIELE(WS-TEAM-COUNT)
               MOVE WS-HOME-G TO WS-TORE(WS-TEAM-COUNT)
               MOVE WS-AWAY-G TO WS-GEGENTORE(WS-TEAM-COUNT)
               IF WS-HOME-G > WS-AWAY-G
                   MOVE 3 TO WS-PUNKTE(WS-TEAM-COUNT)
               ELSE
                   IF WS-HOME-G = WS-AWAY-G
                       MOVE 1 TO WS-PUNKTE(WS-TEAM-COUNT)
                   ELSE
                       MOVE 0 TO WS-PUNKTE(WS-TEAM-COUNT)
                   END-IF
               END-IF
           END-IF.
       
       ADD-TO-AWAY-TEAM.
           MOVE 0 TO WS-FOUND.
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-TEAM-COUNT
               IF WS-NAME(WS-I) = WS-AWAY
                   MOVE 1 TO WS-FOUND
                   ADD 1 TO WS-SPIELE(WS-I)
                   ADD WS-AWAY-G TO WS-TORE(WS-I)
                   ADD WS-HOME-G TO WS-GEGENTORE(WS-I)
                   IF WS-AWAY-G > WS-HOME-G
                       ADD 3 TO WS-PUNKTE(WS-I)
                   ELSE
                       IF WS-AWAY-G = WS-HOME-G
                           ADD 1 TO WS-PUNKTE(WS-I)
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.
           
           IF WS-FOUND = 0
               ADD 1 TO WS-TEAM-COUNT
               MOVE WS-AWAY TO WS-NAME(WS-TEAM-COUNT)
               MOVE 1 TO WS-SPIELE(WS-TEAM-COUNT)
               MOVE WS-AWAY-G TO WS-TORE(WS-TEAM-COUNT)
               MOVE WS-HOME-G TO WS-GEGENTORE(WS-TEAM-COUNT)
               IF WS-AWAY-G > WS-HOME-G
                   MOVE 3 TO WS-PUNKTE(WS-TEAM-COUNT)
               ELSE
                   IF WS-AWAY-G = WS-HOME-G
                       MOVE 1 TO WS-PUNKTE(WS-TEAM-COUNT)
                   ELSE
                       MOVE 0 TO WS-PUNKTE(WS-TEAM-COUNT)
                   END-IF
               END-IF
           END-IF.
       
       SORT-TEAMS.
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I >= WS-TEAM-COUNT
               PERFORM VARYING WS-J FROM WS-I BY 1
                   UNTIL WS-J >= WS-TEAM-COUNT
                   IF WS-PUNKTE(WS-I) < WS-PUNKTE(WS-J)
                       PERFORM SWAP-TEAM
                   ELSE
                       IF WS-PUNKTE(WS-I) = WS-PUNKTE(WS-J)
                           COMPUTE WS-DIFF = 
                               (WS-TORE(WS-I) - 
                                WS-GEGENTORE(WS-I)) -
                               (WS-TORE(WS-J) - 
                                WS-GEGENTORE(WS-J))
                           IF WS-DIFF < 0
                               PERFORM SWAP-TEAM
                           END-IF
                       END-IF
                   END-IF
               END-PERFORM
           END-PERFORM.
       
       SWAP-TEAM.
           MOVE WS-NAME(WS-I) TO WS-TEMP-NAME.
           MOVE WS-SPIELE(WS-I) TO WS-TEMP-SPIELE.
           MOVE WS-TORE(WS-I) TO WS-TEMP-TORE.
           MOVE WS-GEGENTORE(WS-I) TO WS-TEMP-GEGENTORE.
           MOVE WS-PUNKTE(WS-I) TO WS-TEMP-PUNKTE.
           
           MOVE WS-NAME(WS-J) TO WS-NAME(WS-I).
           MOVE WS-SPIELE(WS-J) TO WS-SPIELE(WS-I).
           MOVE WS-TORE(WS-J) TO WS-TORE(WS-I).
           MOVE WS-GEGENTORE(WS-J) TO WS-GEGENTORE(WS-I).
           MOVE WS-PUNKTE(WS-J) TO WS-PUNKTE(WS-I).
           
           MOVE WS-TEMP-NAME TO WS-NAME(WS-J).
           MOVE WS-TEMP-SPIELE TO WS-SPIELE(WS-J).
           MOVE WS-TEMP-TORE TO WS-TORE(WS-J).
           MOVE WS-TEMP-GEGENTORE TO WS-GEGENTORE(WS-J).
           MOVE WS-TEMP-PUNKTE TO WS-PUNKTE(WS-J).
       
       OUTPUT-RESULTS.
           OPEN OUTPUT OUTPUT-FILE.
           
           MOVE 
               "Platz;Team;Spiele;Tore;Gegentore;Tordiff;Punkte"
               TO OUTPUT-RECORD.
           WRITE OUTPUT-RECORD.
           
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-TEAM-COUNT
               COMPUTE WS-DIFF = WS-TORE(WS-I) - 
                   WS-GEGENTORE(WS-I)
               MOVE WS-I TO WS-OUT-PLATZ
               MOVE FUNCTION TRIM(WS-NAME(WS-I)) 
                   TO WS-OUT-NAME
               MOVE WS-SPIELE(WS-I) TO WS-OUT-SPIELE
               MOVE WS-TORE(WS-I) TO WS-OUT-TORE
               MOVE WS-GEGENTORE(WS-I) TO WS-OUT-GEGENTORE
               IF WS-DIFF < 0
                   COMPUTE WS-DIFF-ABS = WS-DIFF * -1
                   MOVE FUNCTION CONCATENATE("-"
                       FUNCTION TRIM(WS-DIFF-ABS))
                       TO WS-OUT-DIFF-NUM
               ELSE
                   MOVE WS-DIFF TO WS-OUT-DIFF-NUM
               END-IF
               MOVE WS-PUNKTE(WS-I) TO WS-OUT-PUNKTE
               MOVE WS-OUT-LINE TO OUTPUT-RECORD
               WRITE OUTPUT-RECORD
           END-PERFORM.
           
           CLOSE OUTPUT-FILE.
           DISPLAY "Bundesliga-Tabelle erfolgreich erstellt!"
           DISPLAY "Datei: bundesliga_tabelle.csv".
