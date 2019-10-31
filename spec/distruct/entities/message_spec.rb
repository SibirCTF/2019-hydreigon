RSpec.describe Message, type: :entity do
  describe '#call' do
    it 'when all ok' do
      message = described_class.new(
        text: 'soo secret',
        self_destruction_time: Time.new(2993),
        clicks_left: 1,
        client_password: '',
        remove: false
      )
      expect(message.available?).to eq true
    end

    it 'when too late' do
      message = described_class.new(
        text: 'soo secret',
        self_destruction_time: Time.new(1993),
        clicks_left: 1,
        client_password: '',
        remove: false
      )
      expect(message.available?).to eq false
    end

    it 'when message was remove' do
      message = described_class.new(
        text: 'soo secret',
        self_destruction_time: Time.new(2993),
        clicks_left: 1,
        client_password: '',
        remove: true
      )
      expect(message.available?).to eq false
    end

    it 'when message was remove' do
      message = described_class.new(
        text: 'soo secret',
        self_destruction_time: Time.new(1993),
        clicks_left: 1,
        client_password: '',
        remove: true
      )
      expect(message.available?).to eq false
    end
  end
end
