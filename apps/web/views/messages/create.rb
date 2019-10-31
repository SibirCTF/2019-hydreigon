module Web
  module Views
    module Messages
      class Create

        include Web::View
        def id
          @id ||= message.id
        end
      end
    end
  end
end
