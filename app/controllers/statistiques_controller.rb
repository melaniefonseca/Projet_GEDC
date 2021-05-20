class StatistiquesController < ApplicationController
  def statistiques


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

    sqlnbTotalEtudiant = "SELECT stages.id, nom, prenom, count(*) as nbEtudiant
    FROM stages, etudiants
    WHERE stages.etudiant_id = etudiants.id
    GROUP BY stages.id, nom, prenom	"
    nbTotalEtudiant = ActiveRecord::Base.connection.execute(sqlnbTotalEtudiant)

    if nbTotalEtudiant.present?

      sqletudiant = "SELECT stages.id, nom, prenom,
      COUNT (CASE WHEN auto_evalution = 1 THEN (CASE WHEN finale = 0 THEN stages.id END)END) as EtuAutoEval,
      COUNT (CASE WHEN auto_evalution = 1 THEN (CASE WHEN finale = 1 THEN stages.id END)END) as EtuAutoEvalFinal,
      COUNT (CASE WHEN auto_evalution = 0 THEN (CASE WHEN finale = 0 THEN stages.id END)END) as EtuGrille,
      COUNT (CASE WHEN auto_evalution = 0 THEN (CASE WHEN finale = 1 THEN stages.id END)END) as EtuGrilleFinal
      FROM stages, etudiants, evaluations
      WHERE stages.etudiant_id = etudiants.id
      AND evaluations.stage_id = stages.id
      GROUP BY stages.id, nom, prenom	"
      etudiant = ActiveRecord::Base.connection.execute(sqletudiant)
      if etudiant.present?
        @pourcentageEtudiantAutoEvaluation = (etudiant[0]['EtuAutoEval']/nbTotalEtudiant[0]['nbEtudiant'])*100
        @pourcentageEtudiantAutoEvaluationFinal = (etudiant[0]['EtuAutoEvalFinal']/nbTotalEtudiant[0]['nbEtudiant'])*100
        @pourcentageEtudiantGrilleEvaluation = (etudiant[0]['EtuGrille']/nbTotalEtudiant[0]['nbEtudiant'])*100
        @pourcentageEtudiantGrilleEvaluationFinal = (etudiant[0]['EtuGrilleFinal']/nbTotalEtudiant[0]['nbEtudiant'])*100
      end

      sqletudiantNotation = "SELECT stages.id, nom, prenom, count(*) as nbEtudiant
      FROM stages, etudiants, notations
      WHERE stages.etudiant_id = etudiants.id
      AND notations.stage_id = stages.id
      GROUP BY stages.id, nom, prenom	"
      etudiantNotation = ActiveRecord::Base.connection.execute(sqletudiantNotation)
      etudiantNotationNb = 0
      if etudiantNotation.present?
        etudiantNotationNb = etudiantNotation[0]['nbEtudiant']
      end
      @pourcentageEtudiantNotation = (etudiantNotationNb/nbTotalEtudiant[0]['nbEtudiant'])*100
      puts(@pourcentageEtudiantNotation)

      sqletudiantNotationGraphe = "SELECT stages.id, nom, prenom,
      COUNT (CASE WHEN note = 'A' THEN note END) as noteA,
      COUNT (CASE WHEN note = 'B' THEN note END) as noteB,
      COUNT (CASE WHEN note = 'C' THEN note END) as noteC,
      COUNT (CASE WHEN note = 'D' THEN note END) as noteD,
      COUNT (CASE WHEN note = 'E' THEN note END) as noteE
      FROM stages, etudiants, notations
      WHERE stages.etudiant_id = etudiants.id
      AND notations.stage_id = stages.id
      GROUP BY stages.id, nom, prenom	"
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