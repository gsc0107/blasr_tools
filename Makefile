SHELL=/bin/bash -e -E

.PHONY=all

COMMONMK = ../git_blasr_common.mk
ifneq ($(shell ls $(COMMONMK) 2>/dev/null || echo -n notfound), notfound)
include $(COMMONMK)
endif

GIT_BLASR_LIBPATH = ../libcpp
PB_BLASR_LIBPATH = ../../lib/cpp

# Determine where is PBINCROOT, either from github or PacBio SMRTAnalysis package.
PBINCROOT ?= $(shell cd $(GIT_BLASR_LIBPATH) 2>/dev/null && pwd || echo -n notfound)
ifeq ($(PBINCROOT), notfound)
	PBINCROOT = $(shell cd $(PB_BLASR_LIBPATH) 2>/dev/null && pwd || echo -n notfound)
	ifeq ($(PBINCROOT), notfound)
		$(error please check your blasr lib exists.)
	endif
endif


HDFINC ?= ../../../../assembly/seymour/dist/common/include
HDFLIB ?= ../../../../assembly/seymour/dist/common/lib

INCDIRS = -I$(PBINCROOT)/alignment \
		  -I$(PBINCROOT)/hdf \
		  -I$(PBINCROOT)/pbdata \
		  -I$(PBINCROOT) \
		  -I$(HDFINC) 


LIBDIRS = -L$(PBINCROOT)/alignment \
		  -L$(PBINCROOT)/hdf \
		  -L$(PBINCROOT)/pbdata \
		  -L$(HDFINC) \
		  -L$(HDFLIB)

CXXFLAGS := -std=c++0x -Wall -Wuninitialized -Wno-div-by-zero \
			-pedantic -c -fmessage-length=0 -MMD -MP -w -fpermissive

SRCS := $(wildcard *.cpp)
OBJS := $(SRCS:.cpp=.o)
DEPS := $(SRCS:.cpp=.d)
LIBS := -lblasr -lpbihdf -lpbdata -lhdf5_cpp -lhdf5 -lz -lpthread -lrt -ldl
# -lhdf5, -lhdf5_cpp, -lz required for HDF5
# -lpthread for multi-threading
# -lrt for clock_gettime
# -ldl for dlopen dlclose 

exe = loadPulses pls2fasta samtoh5 samtom4 samFilter toAfg \
      sawriter sdpmatcher sa2bwt bwt2sa alchemy excrep evolve bsdb simpleShredder swMatcher \
      samodify sals printTupleCountTable cmpH5StoreQualityByContext

all : OPTIMIZE = -O3
debug : OPTIMIZE = -O -ggdb -g3
profile : OPTIMIZE = -Os -pg 

all debug profile: $(exe)

loadPulses: LoadPulses.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

LoadPulses.o: LoadPulses.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

pls2fasta: PulseToFasta.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

PulseToFasta.o: PulseToFasta.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

samtoh5: SamToCmpH5.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SamToCmpH5.o: SamToCmpH5.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

samtom4: SamToM4.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SamToM4.o: SamToM4.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

samFilter: SamFilter.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SamFilter.o: SamFilter.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

toAfg: ToAfg.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

ToAfg.o: ToAfg.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

sawriter: SAWriter.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SAWriter.o: SAWriter.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

sdpmatcher: SDPMatcher.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SDPMatcher.o: SDPMatcher.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

sa2bwt: SuffixArrayToBWT.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SuffixArrayToBWT.o: SuffixArrayToBWT.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

bwt2sa: BwtToSuffixArray.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

BwtToSuffixArray.o:BwtToSuffixArray.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

alchemy: BasH5Simulator.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

BasH5Simulator.o: BasH5Simulator.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

excrep: ExciseRepeats.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

ExciseRepeats.o: ExciseRepeats.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

evolve: Evolve.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

Evolve.o: Evolve.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

bsdb: BuildSequenceDB.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

BuildSequenceDB.o: BuildSequenceDB.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

simpleShredder: SimpleShredder.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SimpleShredder.o: SimpleShredder.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

swMatcher: SWMatcher.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SWMatcher.o: SWMatcher.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

samodify: SAModify.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SAModify.o: SAModify.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

sals: SALS.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

SALS.o: SALS.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

printTupleCountTable: PrintTupleCountTable.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

PrintTupleCountTable.o: PrintTupleCountTable.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

cmpH5StoreQualityByContext: StoreQualityByContextFromCmpH5.o
	$(CXX) $(LIBDIRS) $(OPTIMIZE) -static -o $@ $^ $(LIBS)

StoreQualityByContextFromCmpH5.o: StoreQualityByContextFromCmpH5.cpp
	$(CXX) $(CXXFLAGS) $(OPTIMIZE) $(INCDIRS) -o $@ $<

.INTERMEDIATE: $(OBJS)

clean: 
	rm -f $(exe)
	rm -f $(OBJS) $(DEPS)

-include $(DEPS)
