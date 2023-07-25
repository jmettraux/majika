
serve:
	$(RUBY) -run -ehttpd web/ -p7003
s: serve

.PHONY: serve

