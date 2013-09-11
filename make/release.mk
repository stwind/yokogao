APP ?= demo_app

rel: app rel/$(APP) 

rel/$(APP):
	@$(REBAR) generate $(OVERLAY_VARS)

relclean:
	@rm -rf rel/$(APP)
