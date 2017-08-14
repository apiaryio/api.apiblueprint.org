HERCULE := ./node_modules/.bin/hercule
DREDD := ./node_modules/.bin/dredd

SOURCE_FIXTURES := \
	apib/normal apib/warning apib/error \
	apiaryb/normal apiaryb/error \
	swagger.json/normal swagger.json/warning swagger.json/error \
	swagger.yaml/normal swagger.yaml/warning swagger.yaml/error

FIXTURES :=  \
	source/fixtures/apib/normal.refract.parse-result.1.0.json \
	$(foreach path,$(SOURCE_FIXTURES),source/fixtures/$(path).refract.parse-result.json) \
	$(foreach path,$(SOURCE_FIXTURES),source/fixtures/$(path).refract.parse-result.yaml)

SOURCES := apiary.apib introduction.md \
	root.apib parser.apib composer.apib \
	fixtures/apib/error.apib \
	fixtures/swagger.yaml/normal.yaml

DEPENDENCIES = $(foreach file,$(SOURCES),source/$(file)) \
	$(FIXTURES)

HOST := https://api.apiblueprint.org/
APIARY_API := apiblueprintapi

FURY_06_JSON = fury -f 'application/vnd.refract.parse-result+json; version=0.6'
FURY_06_YAML = fury -f 'application/vnd.refract.parse-result+yaml; version=0.6'
FURY_JSON = fury -f 'application/vnd.refract.parse-result+json'

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
fixtures: $(FIXTURES)

.PHONY: cleanfixtures
cleanfixtures:
	@echo "Cleaning Fixtures"
	@rm $(FIXTURES)

source/fixtures/apib/%.refract.parse-result.json: source/fixtures/apib/%.apib
	@echo "Generating $@"
	@$(FURY_06_JSON) $< > $@ || true

source/fixtures/apib/%.refract.parse-result.1.0.json: source/fixtures/apib/%.apib
	@echo "Generating $@"
	@$(FURY_JSON) $< > $@ || true

source/fixtures/apib/%.refract.parse-result.yaml: source/fixtures/apib/%.apib
	@echo "Generating $@"
	@$(FURY_06_YAML) $< > $@ || true

source/fixtures/apiaryb/%.refract.parse-result.json: source/fixtures/apiaryb/%.apiaryb
	@echo "Generating $@"
	@$(FURY_06_JSON) $< > $@ || true

source/fixtures/apiaryb/%.refract.parse-result.yaml: source/fixtures/apiaryb/%.apiaryb
	@echo "Generating $@"
	@$(FURY_06_YAML) $< > $@ || true

source/fixtures/swagger.json/%.refract.parse-result.json: source/fixtures/swagger.json/%.json
	@echo "Generating $@"
	@$(FURY_06_JSON) $< > $@ || true

source/fixtures/swagger.json/%.refract.parse-result.yaml: source/fixtures/swagger.json/%.json
	@echo "Generating $@"
	@$(FURY_06_YAML) $< > $@ || true

source/fixtures/swagger.yaml/%.refract.parse-result.json: source/fixtures/swagger.yaml/%.yaml
	@echo "Generating $@"
	@$(FURY_06_JSON) $< > $@ || true

source/fixtures/swagger.yaml/%.refract.parse-result.yaml: source/fixtures/swagger.yaml/%.yaml
	@echo "Generating $@"
	@$(FURY_06_YAML) $< > $@ || true

node_modules:
	npm install --no-optional hercule dredd js-yaml media-typer chai fury-cli
