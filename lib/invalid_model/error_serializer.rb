module InvalidModel
  class ErrorSerializer
    def initialize(error, options = {})
      @error = error
      @options = options
    end

    def serializable_hash
      {
        code:   code,
        detail: detail,
        meta:   meta.presence,
        source: source,
        status: status
      }.compact
    end

    private

    attr_reader :error

    delegate :attribute, :detail, :meta, :model_name, :type, to: :error

    def code
      if @options[:code]&.respond_to?(:call)
        @options[:code].call error
      elsif @options[:code]
        @options[:code]
      else
        format code_format, attribute: attribute, model: model_name.singular, type: type
      end
    end

    def code_format
      @options[:code_format] || InvalidModel.default_code_format
    end

    def source
      return if attribute == :base

      {pointer: "/data/attributes/#{attribute}"}
    end

    def status
      @options[:status] || InvalidModel.default_status
    end
  end
end
