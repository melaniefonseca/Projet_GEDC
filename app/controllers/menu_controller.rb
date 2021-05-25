class MenuController < ApplicationController

  @bool_test = false

  def menuEtudiant
    idEtudiant = 2

    sqlStage =
      " SELECT id " +
      " FROM stages " +
      " WHERE etudiant_id == " + idEtudiant.to_s
    stage = ActiveRecord::Base.connection.execute(sqlStage)
    idStage = stage[0]['id'].to_s

    sqleval =
      "SELECT id,
        COUNT(CASE WHEN auto_evaluation = 1 THEN (CASE WHEN finale = 0 THEN id END)END) as autoEval,
        COUNT(CASE WHEN auto_evaluation = 1 THEN (CASE WHEN finale = 1 THEN id END)END) as autoEvalFinal,
        COUNT(CASE WHEN auto_evaluation = 0 THEN (CASE WHEN finale = 0 THEN id END)END) as grille,
        COUNT(CASE WHEN auto_evaluation = 0 THEN (CASE WHEN finale = 1 THEN id END)END) as grilleFinal
        FROM evaluations
        WHERE evaluations.stage_id = " + idStage + "
        AND evaluations.rempli = 1"
    @eval = ActiveRecord::Base.connection.execute(sqleval)

    sqlautoeval =
      "SELECT id
        FROM evaluations
        WHERE evaluations.stage_id = " + idStage + "
        AND evaluations.auto_evaluation = 1
        AND evaluations.finale = 0"
    resautoeval = ActiveRecord::Base.connection.execute(sqlautoeval)
    idautoeval = resautoeval[0]['id'].to_s

    sqleval =
      "SELECT id
        FROM evaluations
        WHERE evaluations.stage_id = " + idStage + "
        AND evaluations.auto_evaluation = 0
        AND evaluations.finale = 0"
    reseval = ActiveRecord::Base.connection.execute(sqleval)
    ideval = reseval[0]['id'].to_s

    sqlautoevalfinale =
      "SELECT id
        FROM evaluations
        WHERE evaluations.stage_id = " + idStage + "
        AND evaluations.auto_evaluation = 1
        AND evaluations.finale = 1"
    resautoevalfinale = ActiveRecord::Base.connection.execute(sqlautoevalfinale)
    idautoevalfinale = resautoevalfinale[0]['id'].to_s

    sqlevalfinale =
      "SELECT id
        FROM evaluations
        WHERE evaluations.stage_id = " + idStage + "
        AND evaluations.auto_evaluation = 0
        AND evaluations.finale = 1"
    resevalfinale = ActiveRecord::Base.connection.execute(sqlevalfinale)
    idevalfinale = resevalfinale[0]['id'].to_s

    @idEvals = { "idAutoEval" => idautoeval, "idAutoEvalFinale" => idautoevalfinale, "idEval" => ideval, "idEvalFinale" => idevalfinale}
  end

  def menuRespStage

  end

  def redirection
    if (@bool_test == false)
      redirect_to(menuetudiant_path)
    else
      redirect_to(menurespstage_path)
    end
  end
end