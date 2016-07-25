var hooks = require('hooks');

hooks.beforeEachValidation(function (transaction) {
  // Remove the trailing (or well, empty) new line
  if (transaction.expected.headers['Content-Type'] === 'text/vnd.apiblueprint') {
    transaction.real.body = transaction.expected.body.replace(/^$/g, '');
  }
});
