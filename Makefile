HERCULE := ./node_modules/.bin/hercule
DREDD := ./node_modules/.bin/dredd
SOURCES := apiary.apib introduction.md \
	root.apib parser.apib composer.apib \
	fixtures/apib/normal.refract.parse-result.json \
	fixtures/apib/normal.refract.parse-result.yaml \
	fixtures/apib/error.apib \
	fixtures/apib/error.refract.parse-result.yaml \
	fixtures/swagger.yaml/normal.yaml
DEPENDENCIES = $(foreach file,$(SOURCES),source/$(file))
HOST := https://api.apiblueprint.org/
APIARY_API := apiblueprintapi

apiary.apib: node_modules $(DEPENDENCIES)
	@echo "Transcluding API Blueprint"
	@$(HERCULE) source/apiary.apib -o apiary.apib

test: apiary.apib
	$(DREDD) --hookfiles source/dredd-hooks.js apiary.apib $(HOST)

clean:
	@echo "Cleaning"
	@rm -fr apiary.apib

publish: apiary.apib
	@echo "Uploading blueprint to Apiary"
	@apiary publish --api-name=$(APIARY_API)

node_modules:
	npm install --no-optional hercule dredd js-yaml media-typer chai
