
.PHONY: wrapper
wrapper:
	$(MAKE) -C nvdla_wrapper OUTDIR=${VMOD_OUT_PATH}
	-rm ${VMOD_OUT_PATH}/*.json ${VMOD_OUT_PATH}/*.fir
