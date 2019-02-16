require 'invalid_model'

module InvalidModel
  class Serializer
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
