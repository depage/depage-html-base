I18N = ~/Dev/depage-cms/www/framework/i18n.sh
JSMIN = ~/Dev/depage-cms/www/framework/JsMin/minimize
JSDIR = www/lib/global/js/
PROJECTNAME=projectName

.PHONY: all min minjs locale locale-php sass sassc push pushdev pushlive

all: locale sassc min

min: sassc $(JSDIR)global.min.js

$(JSDIR)global.min.js: \
    $(JSDIR)jquery-1.12.3.min.js \
    $(JSDIR)depage-jquery-plugins/depage-email-antispam.js \
    $(JSDIR)depage-jquery-plugins/depage-social.js \
    $(JSDIR)depage-jquery-plugins/depage-slideshow.js \
    $(JSDIR)global.js $(JSDIR)picturefill.js
	$(JSMIN) --dp-path . --target=$@ $^

locale:
	cd www/lib/ ; $(I18N)

www/lib/global/css/%.css: www/lib/global/sass/%.scss
	sassc --style compressed $< $@

sassc: $(patsubst %.scss,www/lib/global/css/%.css, $(notdir $(wildcard www/lib/global/sass/*.scss)))

sass:
	sass --update www/lib/global/sass/:www/lib/global/css/ -r ./www/lib/global/sass/mixins/helper/functions.rb --style compressed --sourcemap=none

push: pushdev

pushdev: all
	rsync \
	    -e "ssh -p 10022" \
	    -k -r -v -c \
	    --exclude '.DS_Store' \
	    --exclude '.git' \
	    --exclude 'cache/' \
	    www/ depage-ftp@depage.net:/var/www/depage/net.depage.dev/$(PROJECTNAME)/

pushlive: all
	rsync \
	    -k -r -v -c \
	    --exclude '.DS_Store' \
	    --exclude '.git' \
	    www/lib/global/ www-data@cms.depagecms.net:/var/www/net.depagecms.cms/projects/$(PROJECTNAME)/lib/global/
