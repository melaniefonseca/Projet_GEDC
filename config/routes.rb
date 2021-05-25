Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'pages#home'
  get '/evaluation', to: 'evaluations#evaluation'
  get '/evaluation/edit/(:id)', to: 'evaluations#editEvaluation'
  post '/evaluation/save/(:id)', to: 'evaluations#save'
  get '/evaluation/view/(:id)', to: 'evaluations#viewEvaluation'
  get '/tableaudebord', to: 'tableau_de_bord#tableauDeBord'
  get '/menuetudiant', to: 'menu#menuEtudiant'
  get '/menurespstage', to: 'menu#menuRespStage'
  get '/menu', to: 'menu#redirection'
  get '/notation/(:id)', to: 'notations#notation'
  get '/notation/view/(:id)', to: 'notations#viewNotation'
  post '/notation/save', to: 'notations#saveNotation'
  get '/evolution', to: 'evolutions#evolution'
  get '/statistiques', to: 'statistiques#statistiques'
  get '/tableEtudiant', to: 'table_etudiant#tableEtudiant'
  resources :ge_formats
  resources :notation_formats
end
