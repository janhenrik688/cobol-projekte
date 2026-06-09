# COBOL Training

Eine strukturierte Sammlung von COBOL-Übungsprogrammen zur Erarbeitung der Kernkonzepte der Sprache – von einfachen String-Operationen bis hin zur dateibasierten Verarbeitung realer Datensätze.

## Kurzbeschreibung

Dieses Projekt dient als praktisches Trainingslager für die COBOL-Entwicklung unter modernen Bedingungen. Es demonstriert, wie historisch gewachsene Business-Logik mit modernen Entwicklungswerkzeugen (VS Code) und einem automatisierten Build-System (`make`) kombiniert werden kann. Die Module decken verschiedene Schwierigkeitsgrade ab: von mathematischen Grundoperationen über erweiterte Logik bis hin zur sequenziellen Dateiverarbeitung von CSV-Strukturen.

---

## Projektstruktur & Enthaltene Programme

Alle Programme liegen als Quellcode (`.cbl`) im Hauptverzeichnis vor. Die kompilierten Programme (`.exe`) werden ebenfalls direkt im Hauptverzeichnis erzeugt und sind über die `.gitignore` vom Git-Repository ausgeschlossen.

* **`1_STRING_REVERSE.cbl`** – Grundlagen der String-Verarbeitung und Zeichenketten-Invertierung.
* **`2_CALCULATOR.cbl`** – Implementierung grundlegender arithmetischer Operationen (Grundrechenarten).
* **`3_CALCULATOR_EXTENDED.cbl`** – Erweiterter Taschenrechner mit erweiterter Kontrollfluss-Logik und Fehlerbehandlung.
* **`4_BUNDESLIGA_FILEPROCESSING.cbl`** – Fortgeschrittene Dateiverarbeitung (File Section). Liest und verarbeitet Datensätze aus einer externen CSV-Datei.
* **`5_TEST.cbl`** – Eine Sandbox-Umgebung für isolierte Syntax- und Logiktests.
* **`bundesliga_resultate.csv`** – Die Testdatenbasis für das Fileprocessing-Programm.

---

## Voraussetzungen

Um das Projekt zu bauen und auszuführen, werden folgende Werkzeuge benötigt:

1.  **GnuCOBOL Compiler (`cobc`)** – Getestet mit der GnuCOBOL-Umgebung (z. B. via OpenCobolIDE-Verzeichnisstruktur).
2.  **GNU Make** – Steuert das Build-System über die PowerShell / Eingabeaufforderung.

*Hinweis:* Die Pfade zum Compiler (`COBOL_BIN`) und den Konfigurationsdateien (`COBOL_CONFIG`) sind direkt im `Makefile` hinterlegt und müssen bei Systemwechseln ggf. dort angepasst werden.

---

## Build-System & Bedienung

Das Projekt nutzt ein maßgeschneidertes `Makefile` zur einfachen Kompilierung über das Terminal.

### Zentrale Befehle

* **Hilfe anzeigen (Standard):**
    ```bash
    make
    # oder
    make help
    ```
* **Alle Programme kompilieren:**
    ```bash
    make all
    ```
* **Projekt aufräumen (Löscht alle .exe-Dateien):**
    ```bash
    make clean
    ```
* **Vollständiger Clean- und Build-Durchlauf:**
    ```bash
    make rebuild
    ```
* **Projekt- und Compiler-Status prüfen:**
    ```bash
    make status
    make info
    ```

### Einzelne Programme kompilieren
Jedes Programm besitzt ein nummeriertes Kurztarget. Um beispielsweise nur den Taschenrechner zu bauen, reicht:
```bash
make 2

### Ausführung
Nach dem erfolgreichen Kompilieren kann das gewünschte Programm einfach direkt über die PowerShell oder Eingabeaufforderung gestartet werden:

PowerShell
.\2_CALCULATOR.exe

Wichtig für das Bundesliga-Programm: Stellen Sie sicher, dass die Datei bundesliga_resultate.csv im selben Verzeichnis liegt, wenn Sie .\4_BUNDESLIGA_FILEPROCESSING.exe ausführen.