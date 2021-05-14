Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'pages#home'
  get '/autoeval', to: 'pages#showForm'
  post '/autoeval/save', to: 'pages#save'
  get '/viewautoeval', to: 'pages#viewAutoEval'
  get '/menuetudiant', to: 'pages#menuEtudiant'
  get '/grillevierge', to: 'pages#grilleVierge'
  get '/viewgrille', to: 'pages#viewGrilleStage'
end
