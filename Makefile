
RUBY = ruby30

generate:
	@$(RUBY) lib/majika/generate.rb

serve:
	$(RUBY) -run -ehttpd web/ -p7003
s: serve

.PHONY: serve

