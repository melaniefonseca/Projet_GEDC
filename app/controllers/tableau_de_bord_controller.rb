class TableauDeBordController < ApplicationController
  def tableauDeBord
    require 'json'

    idTuteur = 1

    sqlStage = "SELECT stages.id, sujet, type_stage, nom, prenom, mention, raison_sociale, " +
      " MAX(promotions.id) " +
      " FROM stages, formations, promotions, etudiants, entreprises " +
      " WHERE tuteur_universitaire_id == " + idTuteur.to_s +
      " AND stages.formation_id = formations.id" +
      " AND formations.promotion_id = promotions.id" +
      " AND stages.etudiant_id = etudiants.id" +
      " AND stages.entreprise_id = entreprises.id"
      " GROUP BY stages.id, sujet, type_stage"
    @stages = ActiveRecord::Base.connection.execute(sqlStage)
    text = '{"etudiants":['
    @stages.each do |stage|
        sqlautoevaluation = "SELECT id FROM evaluations where evaluations.stage_id = " + stage['id'].to_s + ' AND auto_evalution = 1 AND finale = 0 GROUP BY id'
        autoevaluation = ActiveRecord::Base.connection.execute(sqlautoevaluation)
        if !autoevaluation.present?
          autoevaluation = nil
        else
          autoevaluation = autoevaluation[0]['id'].to_s
        end

        sqlautoevaluationfinal = "SELECT id FROM evaluations where evaluations.stage_id = " + stage['id'].to_s + ' AND auto_evalution = 1 AND finale = 1 GROUP BY id'
        autoevaluationfinal = ActiveRecord::Base.connection.execute(sqlautoevaluationfinal)
        if !autoevaluationfinal.present?
          autoevaluationfinal = nil
        else
          autoevaluationfinal = autoevaluationfinal[0]['id'].to_s
        end

        sqlgrilleevaluation = "SELECT id FROM evaluations where evaluations.stage_id = " + stage['id'].to_s + ' AND auto_evalution = 0 AND finale = 0 GROUP BY id'
        grilleevaluation = ActiveRecord::Base.connection.execute(sqlgrilleevaluation)
        if !grilleevaluation.present?
          grilleevaluation = 'null'
        else
          grilleevaluation = grilleevaluation[0]['id'].to_s
        end

        sqlgrilleevaluationfinal = "SELECT id FROM evaluations where evaluations.stage_id = " + stage['id'].to_s + ' AND auto_evalution = 0 AND finale = 1 GROUP BY id'
        grilleevaluationfinal = ActiveRecord::Base.connection.execute(sqlgrilleevaluationfinal)
        if !grilleevaluationfinal.present?
          grilleevaluationfinal = 'null'
        else
          grilleevaluationfinal = grilleevaluationfinal[0]['id'].to_s
        end

        text += '{"nom": "'+stage['nom'] +' '+ stage['prenom'] +'","promotion": "'+stage['mention']+'", "entreprise": "'+stage['raison_sociale']+'", "autoevaluation": '+autoevaluation+', "grilleevaluation": '+grilleevaluation+', "autoevaluationfinale": '+autoevaluationfinal+', "grilleevaluationfinale": '+grilleevaluationfinal+',  "note": "B"}'
    end
    text += ']}'
    @data = JSON.parse(text)
  end
end