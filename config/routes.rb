Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :hooks do
    resources :telegram, :only => [] do
      post ENV['TELEGRAM_WEBHOOK'], action: :update, :on => :collection
    end
  end
end
