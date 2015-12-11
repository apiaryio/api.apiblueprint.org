var hooks = require('hooks');
var yaml = require('js-yaml');

hooks.beforeEachValidation(function (transaction) {
  // Sort YAML so the ordering is identical for Dredd comparisons
  if (transaction.expected.headers['Content-Type'].match(/.*yaml.*/)) {
    var requestBody = yaml.safeLoad(transaction.expected.body);
    var responseBody = yaml.safeLoad(transaction.real.body);

    transaction.expected.body = yaml.safeDump(requestBody, { "sortKeys": true })
    transaction.real.body = yaml.safeDump(responseBody, { "sortKeys": true })
  }

  // Remove the trailing (or well, empty) new line
  if (transaction.expected.headers['Content-Type'] === 'text/vnd.apiblueprint') {
    transaction.real.body = transaction.expected.body.replace(/^$/g, '');
  }
});
