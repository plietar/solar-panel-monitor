ifeq ($(shell uname -s),Darwin)
	KICAD := /Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
else
	KICAD := kicad-cli
endif

NAME := power-monitor

$(NAME).csv: $(NAME).kicad_sch
	$(KICAD) sch export bom --group-by 'Value,Characteristics,Footprint' --fields 'Value,Characteristics,Footprint,$${QUANTITY},Reference' -o $@ $<
