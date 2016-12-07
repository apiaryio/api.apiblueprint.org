var hooks = require('hooks')
  , assert = require('chai').assert
  , typer = require('media-typer')
  , yaml = require('js-yaml');

hooks.beforeEachValidation(function (transaction) {
  if (['/parser', '/composer'].indexOf(transaction.fullPath) == -1 ||
      ['415', '400', '406'].indexOf(transaction.expected.statusCode) != -1) {

    return;
  }

  var type = typer.parse(transaction.expected.headers['Content-Type']);

  assert.equal(transaction.expected.headers['Content-Type'], transaction.real.headers['content-type']);

  // Indent the request and response bodies properly
  if (type.suffix === 'json' || type.subtype === 'json') {
    // Addding extra character because of https://github.com/apiaryio/dredd/issues/674
    transaction.expected.body = '●' + JSON.stringify(JSON.parse(transaction.expected.body), null, 2) + '●';
    transaction.real.body = '●' + JSON.stringify(JSON.parse(transaction.real.body), null, 2) + '●';

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
