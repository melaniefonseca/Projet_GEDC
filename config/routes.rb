Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'pages#home'
  get '/evaluation', to: 'evaluations#evaluation'
  post '/evaluation/save', to: 'evaluations#save'
  get '/evaluation/view', to: 'evaluations#viewEvaluation'
  get '/tableaudebord', to: 'tableau_de_bord#tableauDeBord'
  get '/menuetudiant', to: 'menu#menuEtudiant'
  get '/menurespstage', to: 'menu#menuRespStage'
  get '/menu', to: 'menu#require_login'
  get '/notation', to: 'pages#notation'
  get '/notation/view', to: 'pages#viewNotation'
  get '/evolution', to: 'pages#evolution'
end
