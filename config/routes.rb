Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'pages#home'
  get '/evaluation', to: 'evaluations#evaluation'
  post '/evaluation/save', to: 'evaluations#save'
  get '/evaluation/view', to: 'evaluations#viewEvaluation'
  get '/tableaudebord', to: 'tableau_de_bord#tableauDeBord'
  get '/menuetudiant', to: 'menu#menuEtudiant'
  get '/menurespstage', to: 'menu#menuRespStage'
  get '/menu', to: 'menu#redirection'
  get '/notation', to: 'notations#notation'
  get '/notation/view', to: 'notations#viewNotation'
  get '/evolution', to: 'evolutions#evolution'
  get '/statistiques', to: 'statistiques#statistiques'
  resources :ge_formats
end
