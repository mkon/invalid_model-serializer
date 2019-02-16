require 'active_support'

module InvalidModel
  autoload :Error,           'invalid_model/error'
  autoload :ErrorSerializer, 'invalid_model/error_serializer'

  include ActiveSupport::Configurable

  config_accessor(:default_code_format) { 'validation_error/%<type>s' }
  config_accessor(:default_status) { '400' }
end
