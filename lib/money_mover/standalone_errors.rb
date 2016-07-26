class StandaloneErrors < SimpleDelegator
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def initialize
    super ActiveModel::Errors.new(self)
  end

  def copy!(error_source)
    error_source.errors.each { |key, msg| add key, msg }
  end
end
