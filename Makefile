I18N = ~/Dev/depage-cms/www/framework/i18n.sh
JSMIN = ~/Dev/depage-cms/www/framework/JsMin/minimize

PROJECTNAME=projectName

SASSDIR = www/lib/global/sass/
CSSDIR = www/lib/global/css/
JSDIR = www/lib/global/js/

.PHONY: all min minjs locale locale-php sass sassc push pushdev pushlive

all: sassc min

min: sassc $(JSDIR)global.min.js

$(JSDIR)global.min.js: \
    $(JSDIR)jquery-1.12.3.min.js \
    $(JSDIR)depage-jquery-plugins/depage-email-antispam.js \
    $(JSDIR)depage-jquery-plugins/depage-social.js \
    $(JSDIR)depage-jquery-plugins/depage-slideshow.js \
    $(JSDIR)global.js \
    $(JSDIR)picturefill.js
	$(JSMIN) --dp-path . --target=$@ $^

locale:
	cd www/lib/ ; $(I18N)

$(CSSDIR)%.css: $(SASSDIR)%.scss
	sassc --style compressed $< $@

sassc: $(patsubst %.scss,$(CSSDIR)%.css, $(notdir $(wildcard $(SASSDIR)*.scss)))

sass:
	sass --update $(SASSDIR):$(CSSDIR) -r ./$(SASSDIR)mixins/helper/functions.rb --style compressed --sourcemap=none

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
