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

    etudiantNotationGrapheA = 0
    etudiantNotationGrapheB = 0
    etudiantNotationGrapheC = 0
    etudiantNotationGrapheD = 0
    etudiantNotationGrapheE = 0

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
        AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"
        else
          sqletudiantNotation = "SELECT count(*) as nbEtudiant
        FROM stages, etudiants, notations, formations, promotions
        WHERE stages.etudiant_id = etudiants.id
        AND notations.stage_id = stages.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"+
            " AND formations.mention = '" + @filtre + "'"
        end
        etudiantNotation = ActiveRecord::Base.connection.execute(sqletudiantNotation)
        etudiantNotationNb = 0
        if etudiantNotation.present?
          etudiantNotationNb = etudiantNotation[0]['nbEtudiant']
        end
        @pourcentageEtudiantNotation = (etudiantNotationNb/nbTotalEtudiant[0]['nbEtudiant'])*100



        if @filtre == 'tout' then
          sqletudiantNotationGraphe = "SELECT
        COUNT (CASE WHEN note = 'A' THEN note END) as noteA,
        COUNT (CASE WHEN note = 'B' THEN note END) as noteB,
        COUNT (CASE WHEN note = 'C' THEN note END) as noteC,
        COUNT (CASE WHEN note = 'D' THEN note END) as noteD,
        COUNT (CASE WHEN note = 'E' THEN note END) as noteE
        FROM stages, etudiants, notations, formations, promotions
        WHERE stages.etudiant_id = etudiants.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND notations.stage_id = stages.id	"+
            " AND formations.mention = '" + @filtre + "'"
        else
          sqletudiantNotationGraphe = "SELECT
        COUNT (CASE WHEN note = 'A' THEN note END) as noteA,
        COUNT (CASE WHEN note = 'B' THEN note END) as noteB,
        COUNT (CASE WHEN note = 'C' THEN note END) as noteC,
        COUNT (CASE WHEN note = 'D' THEN note END) as noteD,
        COUNT (CASE WHEN note = 'E' THEN note END) as noteE
        FROM stages, etudiants, notations, formations, promotions
        WHERE stages.etudiant_id = etudiants.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND notations.stage_id = stages.id	"+
            " AND formations.mention = '" + @filtre + "'"
        end

        etudiantNotationGraphe = ActiveRecord::Base.connection.execute(sqletudiantNotationGraphe)

        if etudiantNotationGraphe.present?
          etudiantNotationGrapheA = (etudiantNotationGraphe[0]['noteA']/nbTotalEtudiant[0]['nbEtudiant'])*100
          etudiantNotationGrapheB = (etudiantNotationGraphe[0]['noteB']/nbTotalEtudiant[0]['nbEtudiant'])*100
          etudiantNotationGrapheC = (etudiantNotationGraphe[0]['noteC']/nbTotalEtudiant[0]['nbEtudiant'])*100
          etudiantNotationGrapheD = (etudiantNotationGraphe[0]['noteD']/nbTotalEtudiant[0]['nbEtudiant'])*100
          etudiantNotationGrapheE = (etudiantNotationGraphe[0]['noteE']/nbTotalEtudiant[0]['nbEtudiant'])*100
        end
      end
      @data = [["A", etudiantNotationGrapheA], ["B",  etudiantNotationGrapheB], ["C",  etudiantNotationGrapheC],["D",  etudiantNotationGrapheD], ["E",  etudiantNotationGrapheE]]
    end
  end
end