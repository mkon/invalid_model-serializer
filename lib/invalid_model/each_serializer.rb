module InvalidModel
  class EachSerializer
    def initialize(resource, error, options = {})
      @resource = resource
      @error = error
      @options = options
    end

    def serializable_hash
      {
        code:   code,
        detail: detail,
        meta:   meta,
        source: source,
        status: status
      }.compact
    end

    private

    attr_reader :error, :resource

    delegate :attribute, :type, to: :error
    delegate :errors, :model_name, to: :resource

    def code
      if @options[:code].respond_to?(:call)
        @options[:code].call resource, error
      elsif @options[:code]
        @options[:code]
      else
        format code_format, attribute: attribute, model: model_name.singular, type: type
      end
    end

    def code_format
      @options[:code_format] || InvalidModel::Serializer.default_code_format
    end

    def detail
      errors.full_message(attribute, errors.generate_message(attribute, type, error.options))
    end

    def meta
      return unless error.options.present?

      error.options.except(*ActiveModel::Error::CALLBACKS_OPTIONS)
    end

    def source
      return @options[:source] if @options.key?(:source)
      return if attribute == :base

      {pointer: "/data/attributes/#{attribute}"}
    end

    def status
      @options[:status] || InvalidModel::Serializer.default_status
    end
  end
end
