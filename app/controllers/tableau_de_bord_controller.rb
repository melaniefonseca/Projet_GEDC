class TableauDeBordController < ApplicationController
  def tableauDeBord
    require 'json'

    idTuteur = 1

    @filtre = 'tout'
    url = request.original_url
    if url.include? "filtre=" then
      uri    = URI.parse(url)
      params = CGI.parse(uri.query)
      @filtre = params['filtre'][0].to_s
    end

    if @filtre == 'tout' then
      sqlStage =
        " SELECT stages.id, sujet, type_stage, nom, prenom, mention, raison_sociale " +
        " FROM stages, formations, promotions, etudiants, entreprises " +
        " WHERE tuteur_universitaire_id == " + idTuteur.to_s +
        " AND stages.formation_id = formations.id" +
        " AND formations.promotion_id = promotions.id" +
        " AND stages.etudiant_id = etudiants.id" +
        " AND stages.entreprise_id = entreprises.id " +
        " AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"
    else
      sqlStage =
        " SELECT stages.id, sujet, type_stage, nom, prenom, mention, raison_sociale " +
          " FROM stages, formations, promotions, etudiants, entreprises " +
          " WHERE tuteur_universitaire_id == " + idTuteur.to_s +
          " AND stages.formation_id = formations.id" +
          " AND formations.promotion_id = promotions.id" +
          " AND stages.etudiant_id = etudiants.id" +
          " AND stages.entreprise_id = entreprises.id " +
          " AND formations.mention = '" + @filtre + "'" +
          " AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"
    end

    @stages = ActiveRecord::Base.connection.execute(sqlStage)
    i = 0
    text = '{"etudiants":['

    @stages.each do |stage|
      autoEval  = 'null'
      autoEvalFinal = 'null'
      grille = 'null'
      grilleFinal = 'null'

      sqleval =
        "SELECT id,
        COUNT(CASE WHEN auto_evaluation = 1 THEN (CASE WHEN finale = 0 THEN id END)END) as autoEval,
        COUNT(CASE WHEN auto_evaluation = 1 THEN (CASE WHEN finale = 1 THEN id END)END) as autoEvalFinal,
        COUNT(CASE WHEN auto_evaluation = 0 THEN (CASE WHEN finale = 0 THEN id END)END) as grille,
        COUNT(CASE WHEN auto_evaluation = 0 THEN (CASE WHEN finale = 1 THEN id END)END) as grilleFinal
        FROM evaluations
        WHERE evaluations.stage_id = " + stage['id'].to_s + "
        AND evaluations.rempli = 1"
      eval = ActiveRecord::Base.connection.execute(sqleval)

      sqlautoeval =
        "SELECT id
        FROM evaluations
        WHERE evaluations.stage_id = " + stage['id'].to_s + "
        AND evaluations.auto_evaluation = 1
        AND evaluations.finale = 0"
      resautoeval = ActiveRecord::Base.connection.execute(sqlautoeval)
      idautoeval = resautoeval[0]['id'].to_s

      sqleval =
        "SELECT id
        FROM evaluations
        WHERE evaluations.stage_id = " + stage['id'].to_s + "
        AND evaluations.auto_evaluation = 0
        AND evaluations.finale = 0"
      reseval = ActiveRecord::Base.connection.execute(sqleval)
      ideval = reseval[0]['id'].to_s

      sqlautoevalfinale =
        "SELECT id
        FROM evaluations
        WHERE evaluations.stage_id = " + stage['id'].to_s + "
        AND evaluations.auto_evaluation = 1
        AND evaluations.finale = 1"
      resautoevalfinale = ActiveRecord::Base.connection.execute(sqlautoevalfinale)
      idautoevalfinale = resautoevalfinale[0]['id'].to_s

      sqlevalfinale =
        "SELECT id
        FROM evaluations
        WHERE evaluations.stage_id = " + stage['id'].to_s + "
        AND evaluations.auto_evaluation = 0
        AND evaluations.finale = 1"
      resevalfinale = ActiveRecord::Base.connection.execute(sqlevalfinale)
      idevalfinale = resevalfinale[0]['id'].to_s

      sqlnote =
        "SELECT id
        FROM notations
        WHERE notations.stage_id = " + stage['id'].to_s
      resnote = ActiveRecord::Base.connection.execute(sqlnote)
      idnote = resnote[0]['id'].to_s

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

      sqlnotation = "SELECT COUNT(*) as note FROM notations WHERE notations.stage_id = " + stage['id'].to_s + " AND notations.rempli = 1"
      notation = ActiveRecord::Base.connection.execute(sqlnotation)

      if !notation.present?
        notation = 'null'
      else
        notation = notation[0]['note'].to_s
      end
      if(i>0)
        text += ','
      end
      text += '{"nom": "'+stage['nom'] +' '+ stage['prenom'] +'","promotion": "'+stage['mention']+'", "entreprise": "'+stage['raison_sociale']+'", "type": "'+stage['type_stage']+'", "autoevaluation": '+autoEval+', "grilleevaluation": '+grille+', "autoevaluationfinale": '+autoEvalFinal+', "grilleevaluationfinale": '+grilleFinal+',  "note": '+notation+', "idautoevaluation": '+idautoeval+', "idevaluation": '+ideval+', "idautoevaluationfinale": '+idautoevalfinale+', "idevaluationfinale": '+idevalfinale+', "idnote": '+idnote+'}'
      i += 1
    end
    text += ']}'

    @data = JSON.parse(text)
  end
end