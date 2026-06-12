# ============================================================================
# Configuration
# ============================================================================
COBOL_BIN = C:\Program Files (x86)\OpenCobolIDE\GnuCOBOL\bin\cobc.exe
COBOL_CONFIG = C:\Program Files (x86)\OpenCobolIDE\GnuCOBOL\config
BIN_DIR = bin
OUT_DIR = out


# Compiler-Flags
COBOL_FLAGS = -x

# Exportiere die Umgebungsvariable
export COB_CONFIG_DIR := $(COBOL_CONFIG)

# ============================================================================
# Ziele (Programme .cbl Dateien
# ============================================================================
PROGRAMS = \
    $(BIN_DIR)/1_STRING_REVERSE.exe \
    $(BIN_DIR)/2_CALCULATOR.exe \
    $(BIN_DIR)/3_CALCULATOR_EXTENDED.exe \
    $(BIN_DIR)/4_BUNDESLIGA_FILEPROCESSING.exe


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
	@echo ""

# ============================================================================
# All Target
# ============================================================================
.PHONY: all
all: $(PROGRAMS)
	@echo ""
	@echo [OK] Alle Programme kompiliert

# ============================================================================
# Compile Rules (Jetzt heißen die Regeln wie die Ausgabedateien!)
# ============================================================================

# Ordner erstellen
$(BIN_DIR):
	@if not exist $(BIN_DIR) mkdir $(BIN_DIR)
$(OUT_DIR):
	@if not exist $(OUT_DIR) mkdir $(OUT_DIR)

# Generische Compile-Regel: .cbl zu .exe
$(BIN_DIR)/%.exe: %.cbl | $(BIN_DIR)
	@echo [Kompiliere] $<
	@"$(COBOL_BIN)" $(COBOL_FLAGS) -o $@ $<

# Kurzwahl für jedes Programm
1: $(BIN_DIR)/1_STRING_REVERSE.exe
2: $(BIN_DIR)/2_CALCULATOR.exe
3: $(BIN_DIR)/3_CALCULATOR_EXTENDED.exe
4: $(BIN_DIR)/4_BUNDESLIGA_FILEPROCESSING.exe

# Run Targets
run1: $(BIN_DIR)/1_STRING_REVERSE.exe
	@.\$(BIN_DIR)\1_STRING_REVERSE.exe

run2: $(BIN_DIR)/2_CALCULATOR.exe
	@.\$(BIN_DIR)\2_CALCULATOR.exe

run3: $(BIN_DIR)/3_CALCULATOR_EXTENDED.exe
	@.\$(BIN_DIR)\3_CALCULATOR_EXTENDED.exe

run4: $(BIN_DIR)/4_BUNDESLIGA_FILEPROCESSING.exe | $(OUT_DIR)
	@.\$(BIN_DIR)\4_BUNDESLIGA_FILEPROCESSING.exe

# ============================================================================
# Clean Target
# ============================================================================
.PHONY: clean
clean:
	@echo [Clean] Loesche bin und out Verzeichnisse
	@if exist $(BIN_DIR) rmdir /s /q $(BIN_DIR)
	@if exist $(OUT_DIR) rmdir /s /q $(OUT_DIR)
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
	@if exist $(BIN_DIR) dir /b $(BIN_DIR)\*.exe 2>nul || echo Keine Programme kompiliert
	@echo ""
	@echo Output-Dateien:
	@if exist $(OUT_DIR) dir /b $(OUT_DIR)\* 2>nul || echo Keine Output-Dateien gefunden


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
