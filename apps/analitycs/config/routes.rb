# frozen_string_literal: true

db = Sequel.connect(ENV.fetch('DATABASE_URL'))
analitycs = db[:analitycs].select_all.reverse(:updated_at).limit(100)
get '/payloads', to: ->(_env) { [200, { 'Content-Type' => 'application/json' }, [analitycs.to_a.to_json]] }
db.disconnect
