RSpec.describe InvalidModel::ErrorSerializer do
  subject(:hash) { described_class.new(error, options).serializable_hash }

  let(:json) { MultiJson.dump(hash) }
  let(:error) do
    instance_double(
      InvalidModel::Error,
      attribute:  attribute,
      type:       type,
      meta:       meta,
      detail:     detail,
      model_name: ActiveModel::Name.new(DummyModel)
    )
  end
  let(:options) { {} }
  let(:attribute) { :my_attribute }
  let(:detail) { 'my detail' }
  let(:type) { :my_type }
  let(:meta) { {} }

  it 'renders correctly' do
    expect(json).to be_json_eql(
      <<-JSON
      {
        "code": "validation_error/#{type}",
        "detail": "#{detail}",
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
  end

  context 'when setting custom code_format' do
    let(:options) { {code_format: '%<model>s.validation_error/%<attribute>s/%<type>s'} }

    it 'uses the new value' do
      expect(hash[:code]).to eq 'dummy_model.validation_error/my_attribute/my_type'
    end
  end

  context 'when setting code as a proc' do
    let(:options) { {code: ->(e) { "#{e.model_name.name}/#{e.type}" }} }

    it 'uses the new value' do
      expect(hash[:code]).to eq 'DummyModel/my_type'
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
