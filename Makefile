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

.PHONY: fixtures
fixtures:
	fury source/fixtures/apiaryb/error.apiaryb -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/apiaryb/error.refract.parse-result.json || true
	fury source/fixtures/apiaryb/error.apiaryb -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/apiaryb/error.refract.parse-result.yaml || true
	fury source/fixtures/apiaryb/normal.apiaryb -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/apiaryb/normal.refract.parse-result.json
	fury source/fixtures/apiaryb/normal.apiaryb -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/apiaryb/normal.refract.parse-result.yaml
	fury source/fixtures/apib/normal.apib -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/apib/normal.refract.parse-result.json
	fury source/fixtures/apib/normal.apib -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/apib/normal.refract.parse-result.yaml
	fury source/fixtures/apib/warning.apib -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/apib/warning.refract.parse-result.json
	fury source/fixtures/apib/warning.apib -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/apib/warning.refract.parse-result.yaml
	fury source/fixtures/apib/error.apib -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/apib/error.refract.parse-result.json || true
	fury source/fixtures/apib/error.apib -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/apib/error.refract.parse-result.yaml || true
	fury source/fixtures/swagger.json/error.json -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/swagger.json/error.refract.parse-result.json || true
	fury source/fixtures/swagger.json/error.json -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/swagger.json/error.refract.parse-result.yaml || true
	fury source/fixtures/swagger.json/warning.json -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/swagger.json/warning.refract.parse-result.json
	fury source/fixtures/swagger.json/warning.json -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/swagger.json/warning.refract.parse-result.yaml
	fury source/fixtures/swagger.json/normal.json -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/swagger.json/normal.refract.parse-result.json
	fury source/fixtures/swagger.json/normal.json -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/swagger.json/normal.refract.parse-result.yaml
	fury source/fixtures/swagger.json/error.json -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/swagger.json/error.refract.parse-result.json || true
	fury source/fixtures/swagger.json/error.json -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/swagger.json/error.refract.parse-result.yaml || true
	fury source/fixtures/swagger.json/warning.json -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/swagger.json/warning.refract.parse-result.json
	fury source/fixtures/swagger.json/warning.json -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/swagger.json/warning.refract.parse-result.yaml
	fury source/fixtures/swagger.json/normal.json -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/swagger.json/normal.refract.parse-result.json
	fury source/fixtures/swagger.json/normal.json -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/swagger.json/normal.refract.parse-result.yaml
	fury source/fixtures/swagger.yaml/error.yaml -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/swagger.yaml/error.refract.parse-result.json || true
	fury source/fixtures/swagger.yaml/error.yaml -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/swagger.yaml/error.refract.parse-result.yaml || true
	fury source/fixtures/swagger.yaml/warning.yaml -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/swagger.yaml/warning.refract.parse-result.json
	fury source/fixtures/swagger.yaml/warning.yaml -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/swagger.yaml/warning.refract.parse-result.yaml
	fury source/fixtures/swagger.yaml/normal.yaml -f 'application/vnd.refract.parse-result+json; version=0.6' > source/fixtures/swagger.yaml/normal.refract.parse-result.json
	fury source/fixtures/swagger.yaml/normal.yaml -f 'application/vnd.refract.parse-result+yaml; version=0.6' > source/fixtures/swagger.yaml/normal.refract.parse-result.yaml

node_modules:
	npm install --no-optional hercule dredd js-yaml media-typer chai fury-cli
