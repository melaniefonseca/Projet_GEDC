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

      autoEval  = 'null'
      autoEvalFinal = 'null'
      grille = 'null'
      grilleFinal = 'null'
      sqleval = "SELECT id,
      COUNT(CASE WHEN auto_evalution = 1 THEN (CASE WHEN finale = 0 THEN id END)END) as autoEval,
      COUNT(CASE WHEN auto_evalution = 1 THEN (CASE WHEN finale = 1 THEN id END)END) as autoEvalFinal,
      COUNT(CASE WHEN auto_evalution = 0 THEN (CASE WHEN finale = 0 THEN id END)END) as grille,
      COUNT(CASE WHEN auto_evalution = 0 THEN (CASE WHEN finale = 1 THEN id END)END) as grilleFinal
      FROM evaluations
      WHERE evaluations.stage_id = " + stage['id'].to_s
      eval = ActiveRecord::Base.connection.execute(sqleval)
      if eval.present?
        if (eval[0]['autoEval'].to_s != 0)
          autoEval  = eval[0]['autoEval'].to_s
        end
        if (eval[0]['autoEvalFinal'].to_s != 0)
          autoEvalFinal = eval[0]['autoEvalFinal'].to_s
        end
        if (eval[0]['grille'].to_s != 0)
          grille = eval[0]['grille'].to_s
        end
        if (eval[0]['grilleFinal'] != 0)
          grilleFinal = eval[0]['grilleFinal'].to_s
        end
      end
      puts(eval)

      sqlnotation = "SELECT note FROM notations where notations.stage_id = " + stage['id'].to_s
      notation = ActiveRecord::Base.connection.execute(sqlnotation)
      if !notation.present?
        notation = 'null'
      else
        notation = notation[0]['note'].to_s
      end

      text += '{"nom": "'+stage['nom'] +' '+ stage['prenom'] +'","promotion": "'+stage['mention']+'", "entreprise": "'+stage['raison_sociale']+'", "autoevaluation": '+autoEval+', "grilleevaluation": '+grille+', "autoevaluationfinale": '+autoEvalFinal+', "grilleevaluationfinale": '+grilleFinal+',  "note": '+notation+'}'

    end
    text += ']}'
    @data = JSON.parse(text)
  end
end