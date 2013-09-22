site:
	@echo Building...
	@rm -f 404.html
	@jekyll build
	@mv _site/404.html 404.html

clean:
	@rm -rf _site
