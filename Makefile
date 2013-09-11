APP := yokogao

include make/common.mk
include make/rebar.mk
include make/release.mk
include make/pkg.mk

.PHONY: cgrind

erlgrind:
	wget https://raw.github.com/isacssouza/erlgrind/master/src/erlgrind
	chmod u+x erlgrind

grind: erlgrind
	./erlgrind $(if $(FILE),$(FILE),"fprof.trace")
