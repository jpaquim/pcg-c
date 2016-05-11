# 
# PCG Random Number Generation for C.
# 
# Original work Copyright 2014 Melissa O'Neill <oneill@pcg-random.org>
# Modified work Copyright 2016 João Paquim
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# For additional information about the PCG random number generation scheme,
# including its license and other licensing options, visit
# 
#     http://www.pcg-random.org
#

# Simplified Makefile for library compilation

TGT_LIB = pcg_random
TGT_LIB_A = lib$(TGT_LIB).a

prefix ?= install
INST_INC := $(prefix)/include/$(TGT_LIB)
INST_LIB := $(prefix)/lib
INST_CLN := $(INST_INC) $(INST_LIB)/$(TGT_LIB_A)

SRC = $(wildcard src/*.c)
OBJ = $(SRC:src/%.c=build/%.o)

CPPFLAGS += -Iinclude
CFLAGS += -O3 -std=c99

$(TGT_LIB_A): $(OBJ)
	@echo archiving: $(TGT_LIB_A)
	@$(AR) -rcs $@ $^
	@echo successfully built: $@

build/%.o: src/%.c
	@mkdir -p build
	@echo compiling: $< '->' $@
	@$(CC) $(CPPFLAGS) $(CFLAGS) -c -MMD -MP $< -o $@

-include build/*.d

install: $(TGT_LIB_A)
	@echo installing to $(prefix)
	@mkdir -p $(INST_INC)
	@mkdir -p $(INST_LIB)
	@install -m 0644 include/* $(INST_INC)
	@install -m 0644 $^ $(INST_LIB)
	@echo successfully installed: $(INST_CLN)
	@echo $(INST_CLN) >> .uninstall

uninstall:
	@$(RM) -r $(shell cat .uninstall) .uninstall
	@echo successfully uninstalled: $(TGT_LIB)

clean clean-all:
	@echo cleaning: build $(TGT_LIB_A)
	@$(RM) -r build $(TGT_LIB_A)

.PHONY: install clean clean-all
