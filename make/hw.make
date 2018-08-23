
HW_OUT_PATH = vmod/hw
HW_OUT_DIRS = $(shell find $(HW_OUT_PATH) -type d)
HW_TARGETS = $(foreach dir, $(HW_OUT_DIRS), $(wildcard $(dir)/*.v))

HW_SRC_PATHES = nvdla_hw/vmod nvdla_hw/spec
HW_SRC_DIRS = $(foreach dir, $(HW_SRC_PATHES), $(foreach sub, $(shell find $(HW_OUT_PATH) -type d), $(dir)/$(sub)))
HW_SRCS = $(foreach dir, $(HW_SRC_DIRS), $(wildcard $(dir)/*))

# $(info Hardware targes: $(HW_TARGETS))
# $(info Hardware sources: $(HW_SRCS))

.PHONY: hw
hw: $(HW_OUT_PATH) $(HW_TARGETS)

$(HW_TARGETS): $(HW_SRCS) | gen_hw cp_hw filt_hw

.PHONY: gen_hw
gen_hw:
	$(MAKE) -C nvdla_hw
	cd nvdla_hw && ./tools/bin/tmake vmod
	
.PHONY: cp_hw
cp_hw: $(HW_OUT_PATH) 
	cp -rf ./nvdla_hw/outdir/nv_small/vmod/* ./vmod/hw/

.PHONY: rm_hw
rm_hw: $(HW_OUT_PATH)
	-rm -r ./vmod/hw/*

.PHONY: filt_hw
filt_hw: 
	-rm -r ./vmod/hw/rams/model
	-rm -r ./vmod/hw/rams/synth
	python3 ./utils/dep_scan/scan_folder.py -d -j8 -tNV_nvdla $(HW_OUT_PATH)
	-find ./vmod -name "*.vcp" | xargs rm

$(HW_OUT_PATH):
	mkdir -p $@

