# Bundler loading entrypoint
require 'active_support'

module InvalidModel
  autoload :Error,          'invalid_model/error'
  autoload :EachSerializer, 'invalid_model/each_serializer'

  class Serializer
    include ActiveSupport::Configurable

    config_accessor(:default_code_format) { 'validation_error/%<type>s' }
    config_accessor(:default_status) { '400' }

    def initialize(resource, options = {})
      @resource = resource
      @options = options
    end

    def serializable_hash
      list = []
      @resource.errors.each do |error|
        list << each_serializer_klass.new(@resource, error, @options).serializable_hash
      end
      {errors: list}
    end

    private

    def each_serializer_klass
      @options[:each_serializer] || EachSerializer
    end
  end
end
