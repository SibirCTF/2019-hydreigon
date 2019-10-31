# frozen_string_literal: true

require 'base64'

module Web
  module Controllers
    module Messages
      class Create
        include Web::Action
        expose :message
        def call(params)
          params[:message][:text] = AESCrypt.encrypt(
            params[:message][:text],
            params.dig(:message, :client_pasword) || ENV['AES_PASSWORD']
          )
          message = Message.new(params[:message])
          @message = MessageRepository.new.create(message)
        rescue StandardError => e
          status 500, "Something goes wrong: #{e}"
        end
      end
    end
  end
end
