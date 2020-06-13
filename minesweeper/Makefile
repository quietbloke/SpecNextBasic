APP := minesweeper

ECHO := echo
FIND := find

BANKSRCDIR := src/bank
OBJDIR := build

EMU := mono ../../../CSpect/CSpect.exe -w3 -vsync -s28 -esc -60 -tv -basickeys -zxnext -nextrom -mmc=../../../CSpect/systemnext.img
TXTTOBAS = ../../../txt2nextbasic.py 
HDFMONKEY = ../../../hdfmonkey

BANKSOURCES != find src/bank -type f -name "*.bas" | sort

BANKOBJECTS = $(BANKSOURCES:$(BANKSRCDIR)/%.bas=$(OBJDIR)/bank/%.bas) 

build/$(APP).bas : src/$(APP).bas build/bank/globalvars.bas build/bank/splashscreen.bas
	txt2bas -i src/$(APP).bas -o build/$(APP).bas
	-$(HDFMONKEY) mkdir ../../../CSpect/systemnext.img /quietbloke/$(APP)
	$(HDFMONKEY) put ../../../CSpect/systemnext.img $@ /quietbloke/$(APP)/$(notdir $@)

#$(BANKOBJECTS) : $(BANKSOURCES)
build/bank/%.bas : src/bank/%.bas
	txt2bas -bank -i $< -o $@
	-$(HDFMONKEY) mkdir ../../../CSpect/systemnext.img /quietbloke/$(APP)
	$(HDFMONKEY) put ../../../CSpect/systemnext.img $@ /quietbloke/$(APP)/$(notdir $@)

run: build/$(APP).bas
	$(EMU)

clean:
	rm build/*.* -f
	rm build/bank/*.* -f

print:
	@$(ECHO) "****** Make variables ******"
	@$(ECHO) APP: $(APP)
	@$(ECHO) Bank Source Dir : $(BANKSRCDIR)
	@$(ECHO) Build  Dir : $(OBJDIR)
	@$(ECHO) Source     : $(BANKSOURCES)
	@$(ECHO) Objects    : $(BANKOBJECTS)
	