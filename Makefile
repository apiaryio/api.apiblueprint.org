HERCULE := ./node_modules/.bin/hercule
DREDD := ./node_modules/.bin/dredd
SOURCES := apiary.apib sample.apib introduction.md \
	root.apib parser.apib composer.apib \
	sample.refract.parse-result.json \
	sample.refract.parse-result.yaml \
	sample.apiblueprint.parse-result.json \
	sample.apiblueprint.parse-result.yaml \
	sample.apiblueprint.ast-2.0.yaml \
	sample.apiblueprint.ast-2.0.json
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
	npm install hercule dredd
