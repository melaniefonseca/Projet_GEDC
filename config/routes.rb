Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  get '/', to: 'pages#home'
  get '/evaluation', to: 'pages#evaluation'
  post '/evaluation/save', to: 'pages#save'
  get '/evaluation/view', to: 'pages#viewEvaluation'
  get '/tableaudebord', to: 'pages#tableauDeBord'
  get '/menuetudiant', to: 'pages#menuEtudiant'
  get '/menurespstage', to: 'pages#menuRespStage'

  resources :ge_formats
end
