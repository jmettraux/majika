
RUBY = ruby33

poem:
	@$(RUBY) lib/majika/poem.rb

cards:
	@$(RUBY) lib/majika/cards.rb

serve:
	$(RUBY) -run -ehttpd web/ -p7003
s: serve

.PHONY: serve

