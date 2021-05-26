class StatistiquesController < ApplicationController
  def statistiques

    @filtre = 'tout'
    url = request.original_url
    if url.include? "filtre=" then
      uri    = URI.parse(url)
      params = CGI.parse(uri.query)
      @filtre = params['filtre'][0].to_s
    end

    @pourcentageEtudiantAutoEvaluation = 0
    @pourcentageEtudiantAutoEvaluationFinal = 0
    @pourcentageEtudiantGrilleEvaluation = 0
    @pourcentageEtudiantGrilleEvaluationFinal = 0
    @pourcentageEtudiantNotation = 0


    if @filtre == 'tout' then
      sqlnbTotalEtudiant = "SELECT count(*) as nbEtudiant
      FROM stages, etudiants, formations, promotions
      WHERE stages.etudiant_id = etudiants.id
      AND stages.formation_id = formations.id
      AND formations.promotion_id = promotions.id
      AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"
    else
      sqlnbTotalEtudiant = "SELECT count(*) as nbEtudiant
      FROM stages, etudiants, formations, promotions
      WHERE stages.etudiant_id = etudiants.id
      AND stages.formation_id = formations.id
      AND formations.promotion_id = promotions.id
      AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)" +
      " AND formations.mention = '" + @filtre + "'"

    end

    nbTotalEtudiant = ActiveRecord::Base.connection.execute(sqlnbTotalEtudiant)

    if nbTotalEtudiant.present?
      if nbTotalEtudiant[0]['nbEtudiant']>0
        if @filtre == 'tout' then
          sqletudiant = "SELECT stages.id, nom, prenom,
        COUNT (CASE WHEN auto_evaluation = 1 THEN (CASE WHEN finale = 0 THEN stages.id END)END) as EtuAutoEval,
        COUNT (CASE WHEN auto_evaluation = 1 THEN (CASE WHEN finale = 1 THEN stages.id END)END) as EtuAutoEvalFinal,
        COUNT (CASE WHEN auto_evaluation = 0 THEN (CASE WHEN finale = 0 THEN stages.id END)END) as EtuGrille,
        COUNT (CASE WHEN auto_evaluation = 0 THEN (CASE WHEN finale = 1 THEN stages.id END)END) as EtuGrilleFinal
        FROM stages, etudiants, evaluations, formations, promotions
        WHERE stages.etudiant_id = etudiants.id
        AND evaluations.stage_id = stages.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)
        AND rempli = 1
        GROUP BY stages.id, nom, prenom	"
        else
          sqletudiant = "SELECT stages.id, nom, prenom,
        COUNT (CASE WHEN auto_evaluation = 1 THEN (CASE WHEN finale = 0 THEN stages.id END)END) as EtuAutoEval,
        COUNT (CASE WHEN auto_evaluation = 1 THEN (CASE WHEN finale = 1 THEN stages.id END)END) as EtuAutoEvalFinal,
        COUNT (CASE WHEN auto_evaluation = 0 THEN (CASE WHEN finale = 0 THEN stages.id END)END) as EtuGrille,
        COUNT (CASE WHEN auto_evaluation = 0 THEN (CASE WHEN finale = 1 THEN stages.id END)END) as EtuGrilleFinal
        FROM stages, etudiants, evaluations, formations, promotions
        WHERE stages.etudiant_id = etudiants.id
        AND evaluations.stage_id = stages.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND rempli = 1
        AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"+
            " AND formations.mention = '" + @filtre + "'" +
            " GROUP BY stages.id, nom, prenom	"
        end
        etudiant = ActiveRecord::Base.connection.execute(sqletudiant)
        if etudiant.present?
          @pourcentageEtudiantAutoEvaluation = ((etudiant[0]['EtuAutoEval'].fdiv(nbTotalEtudiant[0]['nbEtudiant']))*100).round
          @pourcentageEtudiantAutoEvaluationFinal = ((etudiant[0]['EtuAutoEvalFinal'].fdiv(nbTotalEtudiant[0]['nbEtudiant']))*100).round
          @pourcentageEtudiantGrilleEvaluation = ((etudiant[0]['EtuGrille'].fdiv(nbTotalEtudiant[0]['nbEtudiant']))*100).round
          @pourcentageEtudiantGrilleEvaluationFinal = ((etudiant[0]['EtuGrilleFinal'].fdiv(nbTotalEtudiant[0]['nbEtudiant']))*100).round
        end

        if @filtre == 'tout' then
          sqletudiantNotation = "SELECT count(*) as nbEtudiant
        FROM stages, etudiants, notations, formations, promotions
        WHERE stages.etudiant_id = etudiants.id
        AND notations.stage_id = stages.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND rempli = 1
        AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"
        else
          sqletudiantNotation = "SELECT count(*) as nbEtudiant
        FROM stages, etudiants, notations, formations, promotions
        WHERE stages.etudiant_id = etudiants.id
        AND notations.stage_id = stages.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND rempli = 1
        AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"+
            " AND formations.mention = '" + @filtre + "'"
        end
        etudiantNotation = ActiveRecord::Base.connection.execute(sqletudiantNotation)
        etudiantNotationNb = 0
        if etudiantNotation.present?
          etudiantNotationNb = etudiantNotation[0]['nbEtudiant']
        end
        @pourcentageEtudiantNotation = (etudiantNotationNb/nbTotalEtudiant[0]['nbEtudiant'])*100

        maxversion = JSON.parse ActiveRecord::Base.connection.execute("SELECT MAX(notation_format_id) as ver FROM notations")[0].to_s.gsub("=>", ":")
        
        if @filtre == 'tout' then
          sqletudiantNotationGraphe = "SELECT note
        FROM stages, etudiants, notations, formations, promotions
        WHERE stages.etudiant_id = etudiants.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND notations.stage_id = stages.id
        AND notations.notation_format_id = " + maxversion["ver"].to_s
        else
          sqletudiantNotationGraphe = "SELECT note
        FROM stages, etudiants, notations, formations, promotions
        WHERE stages.etudiant_id = etudiants.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND notations.stage_id = stages.id	"+
            " AND formations.mention = '" + @filtre + "'
        AND notations.notation_format_id = " + maxversion["ver"].to_s
        end

        etudiantNotationGraphe = ActiveRecord::Base.connection.execute(sqletudiantNotationGraphe)

        dic = {}
        etudiantNotationGraphe.each do |data|
          if (!dic.key?(data["note"]))
            dic[data["note"]] = 1;
          else
            dic[data["note"]] = dic[data["note"]] + 1;
          end
        end

      end
      @data = []
      dic.each do |key, value|
        @data.push([key, value]);
      end
    end
  end
end