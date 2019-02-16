require 'active_model'

class DummyModel
  include ActiveModel::Model

  attr_accessor :code, :name, :size, :other

  validates :code, format: {with: /\A[a-zA-Z]+\z/}
  validates :name, presence: true, length: {in: 6..20}
  validates :size, inclusion: {in: %w(small medium large)}

  validate :custom_validation_method

  private

  def custom_validation_method
    return if errors.any? || other.present?

    errors.add :other, :custom_error, foo: 'bar'
  end
end
