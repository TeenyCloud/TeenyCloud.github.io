site:
	@echo Building...
	@rm -f 404.html
	@grunt
	@jekyll build
	@mv _site/404.html 404.html

clean:
	@rm -rf _site
	@grunt clean
