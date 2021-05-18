class TableauDeBordController < ApplicationController
  def tableauDeBord
    require 'json'
    text =  '{"etudiants":[{"nom": "Marie Danede","promotion": "M2 Miage", "entreprise": "Bordeaux Metropole", "autoevaluation": 1, "grilleevaluation": 2, "autoevaluationfinale": 7, "grilleevaluationfinale": 3,  "note": "B"}, {"nom": "Nawel Ouadhour","promotion": "M2 Miage", "entreprise": "Atos", "autoevaluation": null, "grilleevaluation": null, "autoevaluationfinale": null, "grilleevaluationfinale": null,  "note": null}]}'

    @data = JSON.parse(text)
  end
end