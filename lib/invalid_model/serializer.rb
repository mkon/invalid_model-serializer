# Bundler loading entrypoint
require 'active_support'

module InvalidModel
  autoload :Error,           'invalid_model/error'
  autoload :ErrorSerializer, 'invalid_model/error_serializer'

  class Serializer
    include ActiveSupport::Configurable

    config_accessor(:default_code_format) { 'validation_error/%<type>s' }
    config_accessor(:default_status) { '400' }

    def initialize(resource, options = {})
      @resource = resource
      @options = options
    end

    def serializable_hash
      {
        errors: errors_list.map { |error| each_serializer_klass.new(error, @options).serializable_hash }
      }
    end

    private

    def each_serializer_klass
      @options[:each_serializer] || ErrorSerializer
    end

    def errors_object
      @resource.errors
    end

    def errors_list
      list = errors_object.details.map do |key, array|
        array.map { |error| Error.from_hash(errors_object, key, error) }
      end
      list.flatten
    end
  end
end
