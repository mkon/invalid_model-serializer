# InvalidModel Serializer

You are using one of the many ruby `json_api` serializer gems like `active_model_serializers` or `fast_jsonapi`, but are not satisfied with the rendering of validation errors?

This gem is trying to fit this gap.

## Usage

Add the gem to your Gemfile

```ruby
gem 'invalid_model-serializer'
```

To generate a `json-api` compliant error hash simply call
```ruby
InvalidModel::Serializer.new(invalid_model).serializable_hash
```

Which should parse your `ActiveModel` compatible errors and produce something like:

```json
{
  "errors": [
    {
      "code": "validation_error/too_short",
      "detail": "Name is too short (minimum is 6 characters)",
      "meta": {
        "count": 6
      },
      "source": {
        "pointer": "/data/attributes/name"
      },
      "status": "400"
    }
  ]
}
```

### Rails

In a rails controller you could for example use:

```ruby
def create
  ...
  if @record.save
    head :no_content
  else
    render json: InvalidModel::Serializer.new(@record).serializable_hash, status: :bad_request
  end
end
```

### Options

You can pass options to the serializer as 2nd argument. The following keys are supported:
* `code_format`: Override the default format. This string will be passed through a `format` method so you can use some placeholders like `type` and `attribute`.
* `status`: Set a different status, default is `400`
* `each_serializer`: Use your own serializer for error objects.
