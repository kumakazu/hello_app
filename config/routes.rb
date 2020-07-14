Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "posts/index"=>"posts#index"
  get "posts/new" => "posts#new"
  get "posts/:id"=>"posts#show"
  post "posts/create"=>"posts#create"
  get "posts/:id/edit"=>"posts#edit"
  post "posts/:id/update"=>"posts#update"
  
  get "/" => "home#top"
  get "about"=>"home#about"
end