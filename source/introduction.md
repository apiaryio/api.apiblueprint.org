## Media Types
The API uses [content negotiation](https://en.wikipedia.org/wiki/Content_negotiation) heavily. Send requests with the `Content-Type` header set to the right input media type and use the `Accept` header to select desired output as a response.

### Resource State Representation

```
application/hal+json
```

Where applicable this API uses the [HAL+JSON](https://github.com/mikekelly/hal_specification/blob/master/hal_specification.md) media type to represent resource states and to provide available affordances.

### Error States
The common [HTTP Response Status Codes](https://github.com/for-GET/know-your-http-well/blob/master/status-codes.md) are used. Error responses use the [vnd.error](https://github.com/blongden/vnd.error) media type.
