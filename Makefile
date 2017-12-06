# Copyright (C) 2015-2017 Joonas Javanainen <joonas.javanainen@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

NAME := naughtyemu

WLA ?= wla-gb
WLALINK ?= wlalink

SRC_PATH := src
INC_PATH := include
BUILD_PATH := build

TARGETS := $(shell find $(SRC_PATH) -type f -name '*.s' -printf '%P\n')
SRCS := $(addprefix $(SRC_PATH)/, $(TARGETS))
DEPS := $(addprefix $(BUILD_PATH)/, $(TARGETS:.s=.d))
INCS := $(addprefix $(INC_PATH)/, $(shell find $(INC_PATH) -type f -name '*.s' -printf '%P\n'))
OBJS := $(addprefix $(BUILD_PATH)/, $(TARGETS:.s=.o))

all: $(BUILD_PATH)/$(NAME).gb

-include $(DEPS)

$(BUILD_PATH):
	@mkdir $(BUILD_PATH)

$(OBJS): | $(BUILD_PATH)

$(DEPS): | $(BUILD_PATH)

$(BUILD_PATH)/flags: force | $(BUILD_PATH)
	@echo '${WLAFLAGS}' | cmp -s - $@ || echo '${WLAFLAGS}' > $@

$(BUILD_PATH)/%.o: $(SRC_PATH)/%.s $(BUILD_PATH)/flags
	@mkdir -p $(dir $@)
	@$(WLA) -I $(abspath $(INC_PATH)) $(WLAFLAGS) -M -o $@ $< > $(@:%.o=%.d)
	@$(WLA) -I $(abspath $(INC_PATH)) $(WLAFLAGS) -o $@ $<

$(BUILD_PATH)/$(NAME).link: $(OBJS)
	$(file >$@,[objects])
	$(foreach F,$^,$(file >>$@,$(F)))

$(BUILD_PATH)/$(NAME).gb: $(BUILD_PATH)/$(NAME).link
	@$(WLALINK) -S $< $(abspath $@)

clean:
	@rm -rf $(BUILD_PATH)

tags: $(SRCS) $(INCS)
	@ctags --recurse=yes --languages=asm --langmap=asm:.s $(SRC_PATH) $(INC_PATH)

.PHONY: clean all check tags force
