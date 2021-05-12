class PagesController < ApplicationController
  def home

  end

  def showForm

    require 'json'
    text =  '{
      "annee": "",
      "nom": "",
      "entreprise": "",
      "poste": "",
      "activité": "",
      "date":"",
      "commentaire": "",
      "data": [{
          "titre": "Savoir-être",
          "choix": ["Non évalué", "A travailler", "Acquis"],
          "competences": [{
              "intitule": "Investi et motivé",
              "requis": 2
            }, {
              "intitule": "Anglais",
              "requis": 1
            }
          ]
        }, {
          "titre": "Compétences transverses",
          "choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],
          "competences": [ {
              "intitule": "Organisé",
              "requis": 3
            }
          ]
        }
      ]
    }'

    @data = JSON.parse(text)  # <--- no `to_json`
    # => {"one"=>1, "two"=>2}
    puts @data.class

  end
end