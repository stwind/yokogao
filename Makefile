APP := yokogao

include make/common.mk
include make/rebar.mk
include make/release.mk
include make/pkg.mk

.PHONY: grind

erlgrind:
	wget https://raw.github.com/isacssouza/erlgrind/master/src/erlgrind
	chmod u+x erlgrind

grind: erlgrind
	$(if $(FILE),,$(error "Variable FILE must be set"))
	./erlgrind log/$(FILE).analysis
