module InvalidModel
  class Error
    def self.from_hash(errors_object, attribute, hash)
      new(errors_object, attribute, hash[:error], hash.except(:error))
    end

    attr_reader :attribute, :errors_object, :type, :meta

    def initialize(errors_object, attribute, type, meta)
      @errors_object = errors_object
      @attribute = attribute
      @type = type
      @meta = meta
    end

    def detail
      @errors_object.full_message(attribute, errors_object.generate_message(attribute, type, meta))
    end

    def model_name
      errors_object.instance_variable_get(:@base).model_name
    end
  end
end
