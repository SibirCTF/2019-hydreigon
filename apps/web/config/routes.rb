# frozen_string_literal: true

resources :messages, except: %i[update destroy edit index]
post '/crypto', to: 'messages#crypto'
root to: 'messages#main'
