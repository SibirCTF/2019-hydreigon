require "spec_helper"

RSpec.describe Analitycs::Views::ApplicationLayout, type: :view do
  let(:layout)   { Analitycs::Views::ApplicationLayout.new({ format: :html }, "contents") }
  let(:rendered) { layout.render }

  it 'contains application name' do
    expect(rendered).to include('Analitycs')
  end
end
