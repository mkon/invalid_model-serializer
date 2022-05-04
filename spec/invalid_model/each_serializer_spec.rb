RSpec.describe InvalidModel::EachSerializer do
  subject(:hash) { described_class.new(resource, error, options).serializable_hash }

  let(:json) { MultiJson.dump(hash) }
  let(:resource) { DummyModel.new }
  let(:error) do
    instance_double(
      ActiveModel::Error,
      attribute: attribute,
      type:      type,
      options:   meta
    )
  end
  let(:options) { {} }
  let(:attribute) { :code }
  let(:type) { :invalid }
  let(:meta) { {} }

  it 'renders correctly' do
    expect(json).to be_json_eql(
      <<-JSON
      {
        "code": "validation_error/#{type}",
        "detail": "Code is invalid",
        "source": {
          "pointer": "/data/attributes/#{attribute}"
        },
        "status": "400"
      }
      JSON
    )
  end

  context 'when error has a meta object' do
    let(:meta) { {foo: 'bar'} }

    it 'shows the meta' do
      expect(hash[:meta]).to eq meta
    end

    context 'when the meta object contains callback options' do
      before do
        meta.merge!(
          if:        -> { 23 == 42 },
          unless:    :admin?,
          allow_nil: true
        )
      end

      it 'filters out those keys' do
        expect(hash[:meta].keys).to eq %i(foo)
      end
    end
  end

  context 'when setting custom code_format' do
    let(:options) { {code_format: '%<model>s.validation_error/%<attribute>s/%<type>s'} }

    it 'uses the new value' do
      expect(hash[:code]).to eq 'dummy_model.validation_error/code/invalid'
    end
  end

  context 'when setting code as a proc' do
    let(:options) { {code: ->(r, e) { "#{r.model_name}/#{e.type}" }} }

    it 'uses the new value' do
      expect(hash[:code]).to eq 'DummyModel/invalid'
    end
  end

  context 'when setting fixed code' do
    let(:options) { {code: 'my-code'} }

    it 'uses the new value' do
      expect(hash[:code]).to eq 'my-code'
    end
  end

  context 'when setting custom status' do
    let(:options) { {status: '422'} }

    it 'uses the new value' do
      expect(hash[:status]).to eq '422'
    end
  end
end
