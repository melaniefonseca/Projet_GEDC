class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def home; end

  def showForm
    require 'json'
    text =  '{
      "annee": "",
      "nom": "",
      "entreprise": "",
      "poste": "",
      "activité": "",
      "date":"",
      "sections":
      [
        {
          "titre": "Savoir-être",
          "choix": ["Non évalué", "A travailler", "Acquis"],
          "competences":
          [
            {
              "intitule": "Investi et motivé",
              "requis": 2,
              "selection": 2
            },
            {
              "intitule": "Anglais",
              "requis": 1,
              "selection": 2
            }
          ]
        },
        {
          "titre": "Compétences transverses",
          "choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],
          "competences":
          [
            {
              "intitule": "Organisé",
              "requis": 3,
              "selection": 1
            }
          ]
        }
      ],
      "commentaire": ""
    }'

    @data = JSON.parse(text)  # <--- no `to_json`
  end

  def save
    text = '{
      "annee": "",
      "nom": "",
      "entreprise": "",
      "poste": "",
      "activité": "",
      "date":"",
      "sections":
      [
        {
          "titre": "Savoir-être",
          "choix": ["Non évalué", "A travailler", "Acquis"],
          "competences":
          [
            {
              "intitule": "Investi et motivé",
              "requis": 2,
              "selection": 2
            },
            {
              "intitule": "Anglais",
              "requis": 1,
              "selection": 2
            }
          ]
        },
        {
          "titre": "Compétences transverses",
          "choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],
          "competences":
          [
            {
              "intitule": "Organisé",
              "requis": 3,
              "selection": 1
            }
          ]
        }
      ],
      "commentaire": ""
    }'

    @text_json = JSON.parse(text)

    params.delete('action')
    params.delete('controller')

    params.each do |key, value|
      if @text_json.key?(key)
        @text_json[key] = params[key]
      else
        @text_json['sections'].each_with_index do |value_data, index_data|
          value_data['competences'].each_with_index do |value_comp, index_comp|
            if value_comp['intitule'] == key
              @text_json['sections'][index_data]['competences'][index_comp]['selection'] = value.to_i
            end
          end
        end
      end
    end

    @json_add_to_db = Evaluation.new
    @json_add_to_db.contenu = @text_json.to_json
    @json_add_to_db.est_auto_evaluation = true
    @json_add_to_db.save
  end
end
