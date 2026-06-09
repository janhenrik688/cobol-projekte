# ============================================================================
# Configuration
# ============================================================================
COBOL_BIN = C:\Program Files (x86)\OpenCobolIDE\GnuCOBOL\bin\cobc.exe
COBOL_CONFIG = C:\Program Files (x86)\OpenCobolIDE\GnuCOBOL\config

# Compiler-Flags
COBOL_FLAGS = -x

# Exportiere die Umgebungsvariable
export COB_CONFIG_DIR := $(COBOL_CONFIG)

# ============================================================================
# Ziele (Programme .cbl Dateien
# ============================================================================
PROGRAMS = \
    1_STRING_REVERSE.exe \
    2_CALCULATOR.exe \
    3_CALCULATOR_EXTENDED.exe \
    4_BUNDESLIGA_FILEPROCESSING.exe \
	5_TEST.exe

# ============================================================================
# Default Target
# ============================================================================
.PHONY: help
help:
	@echo COBOL Build System
	@echo ==================
	@echo ""
	@echo Verfuegbare Targets:
	@echo   make all          - Alle Programme kompilieren
	@echo   make clean        - Aufraeumen
	@echo   make rebuild      - clean + all
	@echo   make status       - Projekt-Status anzeigen
	@echo   make info         - System-Informationen
	@echo ""
	@echo Einzeltargets:
	@echo   make 1 = 1_STRING_REVERSE
	@echo   make 2 = 2_CALCULATOR
	@echo   make 3 = 3_CALCULATOR_EXTENDED
	@echo   make 4 = 4_BUNDESLIGA_FILEPROCESSING
	@echo   make 5 = 5_TEST
	@echo ""

# ============================================================================
# All Target
# ============================================================================
.PHONY: all
all: $(PROGRAMS)
	@echo ""
	@echo [OK] Alle Programme kompiliert

# ============================================================================
# Compile Rules
# ============================================================================
1: 1_STRING_REVERSE.cbl
	@echo [Kompiliere] 1_STRING_REVERSE.cbl
	@"$(COBOL_BIN)" $(COBOL_FLAGS) 1_STRING_REVERSE.cbl -o 1_STRING_REVERSE.exe

2: 2_CALCULATOR.cbl
	@echo [Kompiliere] 2_CALCULATOR.cbl
	@"$(COBOL_BIN)" $(COBOL_FLAGS) 2_CALCULATOR.cbl -o 2_CALCULATOR.exe

3: 3_CALCULATOR_EXTENDED.cbl
	@echo [Kompiliere] 3_CALCULATOR_EXTENDED.cbl
	@"$(COBOL_BIN)" $(COBOL_FLAGS) 3_CALCULATOR_EXTENDED.cbl -o 3_CALCULATOR_EXTENDED.exe

4: 4_BUNDESLIGA_FILEPROCESSING.cbl
	@echo [Kompiliere] 4_BUNDESLIGA_FILEPROCESSING.cbl
	@"$(COBOL_BIN)" $(COBOL_FLAGS) 4_BUNDESLIGA_FILEPROCESSING.cbl -o 4_BUNDESLIGA_FILEPROCESSING.exe

5: 5_TEST.cbl
	@echo [Kompiliere] 5_TEST.cbl
	@"$(COBOL_BIN)" $(COBOL_FLAGS) 5_TEST.cbl -o 5_TEST.exe

# ============================================================================
# Clean Target
# ============================================================================
.PHONY: clean
clean:
	@echo [Clean] Loeschen von kompilierten Dateien
	@if exist *.exe del /q *.exe
	@echo [OK] Aufgeraeumt

# ============================================================================
# Rebuild Target
# ============================================================================
.PHONY: rebuild
rebuild: clean all
	@echo [OK] Rebuild abgeschlossen

# ============================================================================
# Status Target
# ============================================================================
.PHONY: status
status:
	@echo COBOL Project Status
	@echo ====================
	@echo ""
	@echo Quellcode-Dateien:
	@dir /b *.cbl 2>nul || echo Keine COBOL-Dateien gefunden
	@echo ""
	@echo Kompilierte Programme:
	@dir /b *.exe 2>nul || echo Keine Programme kompiliert
	@echo ""

# ============================================================================
# Info Target
# ============================================================================
.PHONY: info
info:
	@echo Projekt-Informationen
	@echo =====================
	@echo ""
	@echo COBOL Compiler: $(COBOL_BIN)
	@echo Config Verzeichnis: $(COBOL_CONFIG)
	@echo COB_CONFIG_DIR: $(COB_CONFIG_DIR)
	@echo ""
