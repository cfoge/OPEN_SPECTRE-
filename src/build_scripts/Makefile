# name of PSU block diagram TCL file
PROCNAME = test
TARGET_DEVICE = xc7z020clg400-1
BUILD_DIR=build_dir_$(basename $<)
TCL_PATH = vivado

     
BD_SET    = read_bd ../$(PROCDIR)/${PROCNAME}.srcs/sources_1/bd/${PROCNAME}/
BD_LIST   := $(foreach dcpi, $(BD), "$(BD_SET)$(dcpi)")
DCP_SET   = read_checkpoint ../$(PROCDIR)/
DCP_LIST  := $(foreach dcpi, $(DCP), "$(DCP_SET)$(dcpi)")
BD  = $(PROCNAME).bd
DCP = $(PROCNAME).dcp
# we use VHDL 
NO_SYNTH = 0
VHDL_EN  = 1

hello:
	echo "Hello, World"
	echo "This line will print if the file hello does not exist."

psu: 
	@echo **************************************
	@echo "    Now Building PSU" ${PROCNAME}:
	@echo **************************************
	@rm -f ${PROCNAME}.hwdef
	@vivado -mode batch -source $(TCL_PATH)/generate_bd.tcl -tclargs ${PROCNAME} $(TARGET_DEVICE) $(NO_SYNTH) $(VHDL_EN)
	@cp ${PROCNAME}.srcs/sources_1/bd/${PROCNAME}/${BD} .


# remove anything we might have created (ominous)
.phony: clean
clean:
	@rm -fr build_dir_* NA
	@rm -fr edit_*
	@rm -f  *.hwdef *.dcp *.bd $(PROJECT)_dcplist.tcl # *.ngc *.vhd
	@rm -f *.log *.jou
	@rm -fr *.srcs *.cache *.runs *.xpr *.hw *.ip_user_files .Xil $(PROCNAME).gen  $(PROCNAME).sim
	@rm -f *.hdf *.bd *.os *.upd *.xsa