class TableEtudiantController < ApplicationController
  def tableEtudiant
    auto = -1
    final = -1
    note = -1
    mention = -1
    url = request.original_url
    if url.include? "auto=" then
      uri    = URI.parse(url)
      params = CGI.parse(uri.query)
      auto = params['auto'][0].to_s
    end

    if url.include? "final=" then
      uri    = URI.parse(url)
      params = CGI.parse(uri.query)
      final = params['final'][0].to_s
    end

    if url.include? "mention=" then
      uri    = URI.parse(url)
      params = CGI.parse(uri.query)
      mention = params['mention'][0].to_s
    end

    if url.include? "note=" then
      uri    = URI.parse(url)
      params = CGI.parse(uri.query)
      note = params['note'][0].to_s
    end

    if(auto != -1 || final != -1 )
      sqletudiants = "SELECT stages.id, etudiants.nom, etudiants.prenom,
        etudiants.email_universitaire, etudiants.email_personnelle,
        tuteur_universitaires.nom as nomTuteur, tuteur_universitaires.prenom as prenomTuteur,
        tuteur_universitaires.email, mention, raison_sociale
        FROM stages, etudiants, formations, promotions, tuteur_universitaires, entreprises
        WHERE stages.etudiant_id = etudiants.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND tuteur_universitaires.id = stages.tuteur_universitaire_id
        AND entreprises.id = stages.entreprise_id
        AND stages.id NOT IN (SELECT stage_id
        FROM evaluations, formations, promotions, stages
        WHERE evaluations.stage_id = stages.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND rempli = 1
        AND promotions.id = (SELECT MAX(promotions.id) FROM promotions) "
        if auto != -1
          sqletudiants += " AND auto_evaluation = "+auto
        end
        if final != -1
          sqletudiants += " AND finale = "+final
        end
        if mention != -1
          sqletudiants += " AND mention = '"+mention+"'"
        end
        sqletudiants += ") AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"
        if mention != -1
          sqletudiants += " AND mention = '"+mention+"'"
        end

    else
      if (note != -1)
        sqletudiants = "SELECT stages.id, etudiants.nom, etudiants.prenom,
        etudiants.email_universitaire, etudiants.email_personnelle,
        tuteur_universitaires.nom as nomTuteur, tuteur_universitaires.prenom as prenomTuteur,
        tuteur_universitaires.email, mention, raison_sociale
        FROM stages, etudiants, formations, promotions, tuteur_universitaires, entreprises
        WHERE stages.etudiant_id = etudiants.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND tuteur_universitaires.id = stages.tuteur_universitaire_id
        AND entreprises.id = stages.entreprise_id
        AND stages.id NOT IN (SELECT stage_id
        FROM notations, formations, promotions, stages
        WHERE notations.stage_id = stages.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND rempli = 1
        AND promotions.id = (SELECT MAX(promotions.id) FROM promotions) "
        if mention != -1
          sqletudiants += " AND mention = '"+mention+"'"
        end
        sqletudiants += ") AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"
        if mention != -1
          sqletudiants += " AND mention = '"+mention+"'"
        end
      else
        sqletudiants = "SELECT stages.id, etudiants.nom, etudiants.prenom,
        etudiants.email_universitaire, etudiants.email_personnelle,
        tuteur_universitaires.nom as nomTuteur, tuteur_universitaires.prenom as prenomTuteur,
        tuteur_universitaires.email, mention, raison_sociale
        FROM stages, etudiants, formations, promotions, tuteur_universitaires, entreprises
        WHERE stages.etudiant_id = etudiants.id
        AND stages.formation_id = formations.id
        AND formations.promotion_id = promotions.id
        AND tuteur_universitaires.id = stages.tuteur_universitaire_id
        AND entreprises.id = stages.entreprise_id
        AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)
        GROUP BY stages.id"
      end
    end

    @etudiants = ActiveRecord::Base.connection.execute(sqletudiants)
    puts(@etudiants)
  end
end