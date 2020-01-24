Rails.application.routes.draw do
  get "state" => "state#index"
  post "move" => "moves#create"
end
