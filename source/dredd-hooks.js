var hooks = require('hooks')
  , assert = require('chai').assert
  , typer = require('media-typer')
  , yaml = require('js-yaml');

hooks.beforeEachValidation(function (transaction) {
  var type = typer.parse(transaction.expected.headers['Content-Type']);

  assert.equal(transaction.expected.headers['Content-Type'], transaction.real.headers['content-type']);

  // Indent the request and response bodies properly
  if (type.suffix === 'json' || type.subtype === 'json') {
    transaction.expected.body = JSON.stringify(JSON.parse(transaction.expected.body));
    transaction.real.body = JSON.stringify(JSON.parse(transaction.real.body));

    // Change content type because otherwise gavel would compare JSON objects
    transaction.expected.headers['Content-Type'] = 'text/plain';
    transaction.real.headers['content-type'] = 'text/plain';

    return;
  }

  if (type.suffix === 'yaml' || type.subtype === 'yaml') {
    transaction.expected.body = yaml.safeDump(yaml.safeLoad(transaction.expected.body));
    transaction.real.body = yaml.safeDump(yaml.safeLoad(transaction.real.body));

    return;
  }

  transaction.expected.body = transaction.expected.body.trim();
  transaction.real.body = transaction.real.body.trim();
});
