# require 'invalid_model/serializer'

RSpec.describe InvalidModel::Serializer do
  subject(:hash) { described_class.new(model.tap(&:valid?), options).serializable_hash }

  let(:json) { MultiJson.dump(hash) }
  let(:options) { {} }

  context 'when the model has multiple errors' do
    let(:model) { DummyModel.new(code: '?', size: 'wrong') }

    it 'has 4 errors' do
      expect(hash.key?(:errors)).to be true
      expect(hash[:errors].length).to be 4
    end

    it 'renders the blank error correctly' do
      expect(json).to include_json(
        <<-JSON
        {
          "code": "validation_error/blank",
          "detail": "Name can't be blank",
          "source": {
            "pointer": "/data/attributes/name"
          },
          "status": "400"
        }
        JSON
      ).at_path('errors')
    end

    it 'renders the inclusion error correctly' do
      expect(json).to include_json(
        <<-JSON
        {
          "code": "validation_error/inclusion",
          "detail": "Size is not included in the list",
          "meta": {
            "value": "wrong"
          },
          "source": {
            "pointer": "/data/attributes/size"
          },
          "status": "400"
        }
        JSON
      ).at_path('errors')
    end

    it 'renders the invalid error correctly' do
      expect(json).to include_json(
        <<-JSON
        {
          "code": "validation_error/invalid",
          "detail": "Code is invalid",
          "meta": {
            "value": "?"
          },
          "source": {
            "pointer": "/data/attributes/code"
          },
          "status": "400"
        }
        JSON
      ).at_path('errors')
    end

    it 'renders the too_short error correctly' do
      expect(json).to include_json(
        <<-JSON
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
        JSON
      ).at_path('errors')
    end

    context 'when injecting a custom source' do
      let(:options) { {source: ->(_m, e) { {'pointer' => "/#{e.attribute}"} }} }

      it 'renders correct json' do
        expect(json).to be_json_eql(<<~JSON).at_path('errors/0')
          {
            "code": "validation_error/invalid",
            "detail": "Code is invalid",
            "meta": {
              "value": "?"
            },
            "source": {
              "pointer": "/code"
            },
            "status": "400"
          }
        JSON
      end
    end
  end

  context 'when the model has a custom error' do
    let(:model) { DummyModel.new(name: 'ValidName', code: 'AB', size: 'small') }

    it 'renders correct json' do
      expect(json).to be_json_eql(
        <<-JSON
        {
          "errors": [
            {
              "code": "validation_error/custom_error",
              "detail": "Other has custom error",
              "meta": {
                "foo": "bar"
              },
              "source": {
                "pointer": "/data/attributes/other"
              },
              "status": "400"
            }
          ]
        }
        JSON
      )
    end
  end
end
