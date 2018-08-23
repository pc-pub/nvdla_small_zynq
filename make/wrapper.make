
.PHONY: wrapper
wrapper:
	$(MAKE) -C nvdla_wrapper OUTDIR=../vmod
	-rm ./vmod/*.json ./vmod/*.fir
