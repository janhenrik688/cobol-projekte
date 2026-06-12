      ******************************************************************
      * Author:    Jan-Henrik Horwege
      * Date:      2026-06-12
      * Purpose:   Bundesliga Tabelle aus CSV erstellen
      *            Sortierung: Punkte > Tordifferenz
      * Tectonics: cobc
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. BUNDESLIGA.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *    Eingabedatei:           CSV mit Spielen 
      *    Format:                 Heim;Auswaerts;Tore;Tore
           SELECT INPUT-FILE ASSIGN TO "bundesliga_resultate.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
      *    Ausgabedatei:           CSV mit Tabelle 
      *    Format:                 Platz;Team;Spiele;Tore;Gegentore;
      *                            Tordiff;Punkte
           SELECT OUTPUT-FILE ASSIGN TO "out/bundesliga_tabelle.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD                PIC X(100).
       
       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD               PIC X(150).
       
       WORKING-STORAGE SECTION.
       01  WS-EOF                      PIC X VALUE 'N'.
       01  WS-TEAMS.
           05  WS-TEAM                 OCCURS 30 TIMES.
               10  WS-NAME             PIC X(30).
               10  WS-GAMES            PIC 99 VALUE 0.
               10  WS-GOALS-SCORED     PIC 9(4) VALUE 0.
               10  WS-GOALS-CONCEDED   PIC 9(4) VALUE 0.
               10  WS-SCORE            PIC 9(4) VALUE 0.
      
       01  WS-TEAM-COUNT               PIC 99 VALUE 0.
       01  WS-I                        PIC 99.
       01  WS-J                        PIC 99.
      *    Status-Flag: Team in Liste gefunden (1) oder nicht (0)
       01  WS-FOUND                    PIC 9.
           88  WS-TEAM-FOUND           value 1.      
           88  WS-TEAM-NOT-FOUND       value 0.
                 
       01  WS-TEMP-HOME                PIC X(30).
       01  WS-TEMP-AWAY                PIC X(30).
       01  WS-TEMP-HOME-GOALS          PIC 9(4).
       01  WS-TEMP-AWAY-GOALS          PIC 9(4).
       01  WS-TEMP-GOAL-DIFF           PIC S9(4).
       01  WS-J-START                  PIC 99.
       
       01  WS-TEMP-TEAM.
           05  WS-TEMP-NAME            PIC X(30).
           05  WS-TEMP-GAMES           PIC 99.
           05  WS-TEMP-GOALS-SCORED    PIC 9(4).
           05  WS-TEMP-GOALS-CONCEDED  PIC 9(4).
           05  WS-TEMP-POINTS          PIC 9(4).
       
       01  WS-OUT-LINE.
           05  WS-OUT-RANK             PIC 99.
           05  FILLER                  PIC X VALUE ';'.
           05  WS-OUT-NAME             PIC X(30).
           05  FILLER                  PIC X VALUE ';'.
           05  WS-OUT-GAMES            PIC 99.
           05  FILLER                  PIC X VALUE ';'.
           05  WS-OUT-GOALS-SCORED     PIC 9(4).
           05  FILLER                  PIC X VALUE ';'.
           05  WS-OUT-GOALS-CONCEDED   PIC 9(4).
           05  FILLER                  PIC X VALUE ';'.
           05  WS-OUT-GOAL-DIFF        PIC -ZZ9.
           05  FILLER                  PIC X VALUE ';'.
           05  WS-OUT-POINTS           PIC 99.
       
       PROCEDURE DIVISION.
      *       Hauptprogramm
      *       1. Datei einlesen
      *       2. Daten in WS-TEAMS strukturieren
      *       3. Teams sortieren (Punkte > Tordifferenz)
      *       4. Ausgabe in CSV-Format

           DISPLAY "Verarbeite Bundesliga-Ergebnisse...".
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
       
      *    CSV-Zeile verarbeiten
      *    - Unstring: Zeile in Bestandteile zerlegen
      *    - Teamnamen trimmen (Leerzeichen entfernen)
      *    - Daten in WS-TEAMS aktualisieren
       PROCESS-CSV-LINE.
           MOVE SPACES TO WS-TEMP-HOME.
           MOVE SPACES TO WS-TEMP-AWAY.
           MOVE 0 TO WS-TEMP-HOME-GOALS.
           MOVE 0 TO WS-TEMP-AWAY-GOALS.
      *    CSV-Format: Heim;Auswaerts;Tore;Tore     
           UNSTRING INPUT-RECORD DELIMITED BY ";"
               INTO 
                   WS-TEMP-HOME 
                   WS-TEMP-AWAY   
                   WS-TEMP-HOME-GOALS 
                   WS-TEMP-AWAY-GOALS
           END-UNSTRING.
           
           MOVE FUNCTION TRIM(WS-TEMP-HOME) TO WS-TEMP-HOME.
           MOVE FUNCTION TRIM(WS-TEMP-AWAY) TO WS-TEMP-AWAY.
           
           PERFORM ADD-TO-HOME-TEAM.
           PERFORM ADD-TO-AWAY-TEAM.
       
      * Heimteam verarbeiten.
      * Sucht Team in WS-TEAMS
      * Wenn gefunden:         Statistik aktualisieren
      *                        Punkte vergeben 
      *                        Sieg=3, Unentschieden=1, Niederlage=0
      * Wenn nicht gefunden:   Neues Team anlegen
       ADD-TO-HOME-TEAM.
           SET WS-TEAM-NOT-FOUND TO TRUE.
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-TEAM-COUNT
               IF WS-NAME(WS-I) = WS-TEMP-HOME
                   SET WS-TEAM-FOUND TO TRUE
                   ADD 1 TO WS-GAMES(WS-I)
                   ADD WS-TEMP-HOME-GOALS TO WS-GOALS-SCORED(WS-I)
                   ADD WS-TEMP-AWAY-GOALS TO WS-GOALS-CONCEDED(WS-I)
                   IF WS-TEMP-HOME-GOALS > WS-TEMP-AWAY-GOALS
                       ADD 3 TO WS-SCORE(WS-I)
                   ELSE
                       IF WS-TEMP-HOME-GOALS = WS-TEMP-AWAY-GOALS
                           ADD 1 TO WS-SCORE(WS-I)
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.
           
           IF WS-TEAM-NOT-FOUND 
               ADD 1 TO WS-TEAM-COUNT
               MOVE WS-TEMP-HOME TO WS-NAME(WS-TEAM-COUNT)
               MOVE 1 TO WS-GAMES(WS-TEAM-COUNT)
               
               MOVE WS-TEMP-HOME-GOALS 
               TO WS-GOALS-SCORED(WS-TEAM-COUNT)

               MOVE WS-TEMP-AWAY-GOALS 
               TO WS-GOALS-CONCEDED(WS-TEAM-COUNT)

               IF WS-TEMP-HOME-GOALS > WS-TEMP-AWAY-GOALS
                   MOVE 3 TO WS-SCORE(WS-TEAM-COUNT)
               ELSE
                   IF WS-TEMP-HOME-GOALS = WS-TEMP-AWAY-GOALS
                       MOVE 1 TO WS-SCORE(WS-TEAM-COUNT)
                   ELSE
                       MOVE 0 TO WS-SCORE(WS-TEAM-COUNT)
                   END-IF
               END-IF
           END-IF.
       
       ADD-TO-AWAY-TEAM.
           SET WS-TEAM-NOT-FOUND TO TRUE.
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-TEAM-COUNT
               IF WS-NAME(WS-I) = WS-TEMP-AWAY
                   SET WS-TEAM-FOUND TO TRUE
                   ADD 1 TO WS-GAMES(WS-I)
                   ADD WS-TEMP-AWAY-GOALS TO WS-GOALS-SCORED(WS-I)
                   ADD WS-TEMP-HOME-GOALS TO WS-GOALS-CONCEDED(WS-I)
                   IF WS-TEMP-AWAY-GOALS > WS-TEMP-HOME-GOALS
                       ADD 3 TO WS-SCORE(WS-I)
                   ELSE
                       IF WS-TEMP-AWAY-GOALS = WS-TEMP-HOME-GOALS
                           ADD 1 TO WS-SCORE(WS-I)
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.
           
           IF WS-TEAM-NOT-FOUND
               ADD 1 TO WS-TEAM-COUNT
               MOVE WS-TEMP-AWAY TO WS-NAME(WS-TEAM-COUNT)
               MOVE 1 TO WS-GAMES(WS-TEAM-COUNT)

               MOVE WS-TEMP-AWAY-GOALS 
               TO WS-GOALS-SCORED(WS-TEAM-COUNT)

               MOVE WS-TEMP-HOME-GOALS 
               TO WS-GOALS-CONCEDED(WS-TEAM-COUNT)

               IF WS-TEMP-AWAY-GOALS > WS-TEMP-HOME-GOALS
                   MOVE 3 TO WS-SCORE(WS-TEAM-COUNT)
               ELSE
                   IF WS-TEMP-AWAY-GOALS = WS-TEMP-HOME-GOALS
                       MOVE 1 TO WS-SCORE(WS-TEAM-COUNT)
                   ELSE
                       MOVE 0 TO WS-SCORE(WS-TEAM-COUNT)
                   END-IF
               END-IF
           END-IF.
       
       SORT-TEAMS.
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I >= WS-TEAM-COUNT
               COMPUTE WS-J-START = WS-I + 1
               PERFORM VARYING WS-J FROM WS-J-START BY 1
                   UNTIL WS-J > WS-TEAM-COUNT
                   
                   IF WS-SCORE(WS-I) < WS-SCORE(WS-J)
                       PERFORM SWAP-TEAM
                   ELSE
                       IF WS-SCORE(WS-I) = WS-SCORE(WS-J)
                           COMPUTE WS-TEMP-GOAL-DIFF = 
                               (WS-GOALS-SCORED(WS-I) 
                               - WS-GOALS-CONCEDED(WS-I)) 
                               - (WS-GOALS-SCORED(WS-J) 
                               - WS-GOALS-CONCEDED(WS-J))
                           IF WS-TEMP-GOAL-DIFF < 0
                               PERFORM SWAP-TEAM
                           END-IF
                       END-IF
                   END-IF
               END-PERFORM
           END-PERFORM.
       
       SWAP-TEAM.
           MOVE WS-TEAM(WS-I) TO WS-TEMP-TEAM.
           MOVE WS-TEAM(WS-J) TO WS-TEAM(WS-I).
           MOVE WS-TEMP-TEAM  TO WS-TEAM(WS-J).
       
       OUTPUT-RESULTS.
           OPEN OUTPUT OUTPUT-FILE.
           
           MOVE "Platz;Team;Spiele;Tore;Gegentore;Tordiff;Punkte"
               TO OUTPUT-RECORD.
           WRITE OUTPUT-RECORD.
           
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-TEAM-COUNT
               COMPUTE WS-TEMP-GOAL-DIFF = 
                   (WS-GOALS-SCORED(WS-I) 
                   - WS-GOALS-CONCEDED(WS-I))
               
               MOVE WS-I TO WS-OUT-RANK
               MOVE FUNCTION TRIM(WS-NAME(WS-I)) TO WS-OUT-NAME
               MOVE WS-GAMES(WS-I) TO WS-OUT-GAMES
               MOVE WS-GOALS-SCORED(WS-I) TO WS-OUT-GOALS-SCORED
               MOVE WS-GOALS-CONCEDED(WS-I) TO WS-OUT-GOALS-CONCEDED
               
               MOVE WS-TEMP-GOAL-DIFF TO WS-OUT-GOAL-DIFF
               
               MOVE WS-SCORE(WS-I) TO WS-OUT-POINTS
               MOVE WS-OUT-LINE TO OUTPUT-RECORD
               WRITE OUTPUT-RECORD
           END-PERFORM.
           
           CLOSE OUTPUT-FILE.
           DISPLAY "Bundesliga-Tabelle erfolgreich erstellt!".
           DISPLAY "Datei: bundesliga_tabelle.csv".
           
       