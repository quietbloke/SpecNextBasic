APP := patternedit

ECHO := echo
FIND := find

BANKSRCDIR := src/bank
OBJDIR := build

EMU := mono ~/CSpect/CSpect.exe -w3 -vsync -s28 -esc -60 -tv -basickeys -zxnext -nextrom -mmc=../../../../../SpectSD/cspect-next-2gb.img
TXTTOBAS = txt2nextbasic.py 
HDFMONKEY = hdfmonkey
SDIMAGE = ~/SpectSD/cspect-next-2gb.img

BANKSOURCES != find src/bank -type f -name "*.bas" | sort

BANKOBJECTS = $(BANKSOURCES:$(BANKSRCDIR)/%.bas=$(OBJDIR)/bank/%.bas) 

build/$(APP).bas : src/$(APP).bas build/bank/globalvars.bas build/bank/splashscreen.bas build/bank/helpscreen.bas
	txt2bas -i src/$(APP).bas -o build/$(APP).bas
	-$(HDFMONKEY) mkdir ~/SpectSD/cspect-next-2gb.img /quietbloke
	-$(HDFMONKEY) mkdir ~/SpectSD/cspect-next-2gb.img /quietbloke/$(APP)
	$(HDFMONKEY) put ~/SpectSD/cspect-next-2gb.img $@ /quietbloke/$(APP)/$(notdir $@)

#$(BANKOBJECTS) : $(BANKSOURCES)
build/bank/%.bas : src/bank/%.bas
	txt2bas -bank -i $< -o $@
	-$(HDFMONKEY) mkdir ~/SpectSD/cspect-next-2gb.img /quietbloke
	-$(HDFMONKEY) mkdir ~/SpectSD/cspect-next-2gb.img /quietbloke/$(APP)
	$(HDFMONKEY) put ~/SpectSD/cspect-next-2gb.img $@ /quietbloke/$(APP)/$(notdir $@)

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
	