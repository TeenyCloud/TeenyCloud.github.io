# Let's use goold old Makefile
#
.PHONY: help bootstrap update serve

help:
	@echo "'make install' to install the tools to build the website"
	@echo "'make update' to update the tools to build the website"
	@echo "'make serve' to build and serve the website"
	@echo "'make imgmin' to minimize image size"

install:
	@Echo "Installing build dependencies..."
	@rm -f Gemfile.lock
	@gem install jekyll bundler
	@bundle install

update:
	@echo "Updating dependencies"
	@bundle update github-pages

serve:
	bundle exec jekyll serve --watch

imgmin:
	@echo "Reducing JPEG size..."
	@if [ "echo $(which jpegoptim)" == "" ];then echo "Please install jpegoptim"; else jpegoptim ./assets/images/*.jpg; fi
	@echo "Reducing PNG size..."
	@if [ "echo $(which optipng)" == "" ];then echo "Please install optipng"; else optipng ./assets/images/*.png; fi
