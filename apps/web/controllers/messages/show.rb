module Web
  module Controllers
    module Messages
      class Show
        include Web::Action
        expose :message

        def call(params)
          @message = MessageRepository.new.find(params[:id])
          if @message.clicks_left.positive?
            clicks_left = @message.clicks_left - 1
            MessageRepository.new.update(@message.id, clicks_left: clicks_left)
          else
            MessageRepository.new.update(@message.id, remove: true)
          end
        rescue StandardError
          nil
        end
      end
    end
  end
end
