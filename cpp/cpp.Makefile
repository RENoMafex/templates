# Compiler and Flags
CXX ?= g++
CXXFLAGS = $(WARNINGS) -std=$(STANDARD) -O2
STANDARD = c++17
WARNINGS = -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wsign-conversion -Wnull-dereference -Wdouble-promotion -Wformat=2
LDFLAGS =

# Directories
SRC_DIR = src
HDR_DIR = src
BUILD_DIR = build
INSTALLDIR = ~/bin/

# Define pseudotargets
.PHONY: all target install clean cleanall help assemble

# Source, Header and Object files
SRCS = $(wildcard $(SRC_DIR)/*.cpp)
HDRS = $(wildcard $(HDR_DIR)/*.hpp) $(wildcard $(HDR_DIR)/*.h)
OBJS = $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SRCS))

# Output
TARGET = main

# Defaulttarget
all: $(TARGET)

# Compile
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(HDRS) | $(BUILD_DIR)
	@if [ "$@" = "$(firstword $(OBJS))" ]; then \
		echo "\n$(BOLD)$(CYAN)Compiling:$(RESET)"; \
	fi
	@echo "$(YELLOW)$(UNDERLINE)Now Compiling:$(RESET) $(BOLD)$< $(RESET)into $(BOLD)$@$(RESET)"
	@$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo "$(GREEN)$(UNDERLINE)Done compiling$(RESET) $(BOLD)$(notdir $@)$(RESET)"

# Link
$(TARGET): $(OBJS)
	@echo "\n$(BOLD)$(CYAN)Linking: $(BOLD)$(TARGET)$(RESET)"
	$(CXX) $^ -o $@ $(LDFLAGS)
	@echo "$(BOLD)$(GREEN)DONE BUILDING EXECUTABLE$(RESET)"

# Make the build directory if needed
$(BUILD_DIR):
	@echo "\n$(BOLD)$(CYAN)Making build directory:$(RESET)"
	mkdir -p $(BUILD_DIR)

# Install target
install: $(TARGET)
	@echo "\n$(BOLD)$(CYAN)Installing $(TARGET) at $(INSTALLDIR):$(RESET)"
	@cp -fv $(TARGET) $(INSTALLDIR) || sudo mv -iv $(TARGET) $(INSTALLDIR)

# Clean Object files
clean:
	@echo "\n$(BOLD)$(CYAN)Removing object files and build directory:$(RESET)"
	@rm -rfv $(BUILD_DIR)

# Clean out file and objects
cleanall: clean
	@echo "\n$(BOLD)$(CYAN)Removing executable:$(RESET)"
	@rm -rfv $(TARGET)

# help target
help:
	@echo
	@echo "The following are the valid targets for this Makefile:"
	@echo "... $(BOLD)all$(RESET)       the default if no target is provided(usually the same as \
	\"$(UNDERLINE)$(TARGET)$(RESET)\" and \"$(UNDERLINE)target$(RESET)\")"
	@echo "... $(BOLD)target$(RESET)    make the executable"
	@echo "... $(BOLD)install$(RESET)   make and move the executable to $(INSTALLDIR)"
	@echo "... $(BOLD)clean$(RESET)     removes the build directory and its contents like object files"
	@echo "... $(BOLD)cleanall$(RESET)  removes all of the above and also the executable inside this folder"
	@echo
	@echo "also the following are valid targets:"
	@echo "$(BOLD)$(TARGET) $(OBJS)$(RESET)"

# Some ASCII Escapes as constants
override RESET = \033[0m
override BOLD = \033[1m
override ITALIC = \033[36m
override UNDERLINE = \033[4m
override SWAPBGFG = \033[7m
override SWAPFGBG = $(SWAPBGFG)
override RED = \033[31m
override GREEN = \033[32m
override YELLOW = \033[33m
override BLUE = \033[34m
override MAGENTA = \033[35m
override CYAN = \033[36m
override WHITE = \033[37m

target: all
