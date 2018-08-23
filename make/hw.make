
HW_OUT_PATH = vmod/hw
HW_OUT_DIRS = $(shell find $(HW_OUT_PATH) -type d)
HW_TARGETS = $(foreach dir, $(HW_OUT_DIRS), $(wildcard $(dir)/*.v))

HW_SRC_PATHES = nvdla_hw/vmod nvdla_hw/spec
HW_SRC_DIRS = $(foreach dir, $(HW_SRC_PATHES), $(foreach sub, $(shell find $(HW_OUT_PATH) -type d), $(dir)/$(sub)))
HW_SRCS = $(foreach dir, $(HW_SRC_DIRS), $(wildcard $(dir)/*))

$(info Hardware targes: $(HW_TARGETS))
$(info Hardware sources: $(HW_SRCS))

.PHONY hw
hw: $(HW_TARGETS)

$(HW_TARGETS): $(HW_SRCS)
    make -C nvdla_hw
    cd nvdla_hw && ./tools/bin/tmake vmod

