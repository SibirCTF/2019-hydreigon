# frozen_string_literal: true

RSpec.describe Web::Controllers::Messages::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) do
    {
      message: {
        text: 'soo secret',
        self_destruction_time: Time.now.to_s,
        clicks_left: '1',
        client_password: ''
      }
    }
  end
  it 'is successful' do
    response = action.call(params)
    expect(response).to have_http_status(200)
  end
end
