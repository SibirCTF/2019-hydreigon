# frozen_string_literal: true

module Web
  module Controllers
    module Messages
      class Crypto
        include Web::Action
        def call(params)
          response = AESCrypt.decrypt(
            params[:message][:text].chomp,
            params.dig(:message, :client_pasword) || ENV['AES_PASSWORD']
          )
          status 200, response
        rescue StandardError => e
          status 200, 'Wrong password!'
        end
      end
    end
  end
end
