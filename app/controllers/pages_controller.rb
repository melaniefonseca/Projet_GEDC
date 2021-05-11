class PagesController < ApplicationController
  def home

  end

  def showForm
    @json_request = '{
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
  end
end