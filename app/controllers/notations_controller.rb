class NotationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def notation
    require 'json'
    params.require(:id)
    @id = params[:id]
    notationDB = Notation.find(@id)
    text = NotationFormats.find(notationDB.notation_format_id).contenu
    @data = JSON.parse(text)

    sqlevol = "SELECT nom, prenom, mention, libelle, raison_sociale " +
      " FROM stages, etudiants, entreprises, formations " +
      " WHERE stages.id == " + notationDB.stage_id.to_s +
      " AND etudiants.id = stages.etudiant_id" +
      " AND entreprises.id = stages.entreprise_id" +
      " AND formations.id = stages.formation_id"

    notationData = JSON.parse ActiveRecord::Base.connection.execute(sqlevol)[0].to_s.gsub("=>", ":")

    @nomEtudiant = notationData["nom"].to_s + " " + notationData["prenom"].to_s
    @promotionEtudiant = notationData["mention"].to_s + " " + notationData["libelle"].to_s
    @entrepriseEtudiant = notationData["raison_sociale"].to_s

    @note = notationDB.note
    @commentaire = notationDB.commentaire
  end

  def viewNotation
    require 'json'
    params.require(:id)
    @id = params[:id]
    notationDB = Notation.find(@id)
    text = NotationFormats.find(notationDB.notation_format_id).contenu
    @data = JSON.parse(text)

    sqlevol = "SELECT nom, prenom, mention, libelle, raison_sociale " +
    " FROM stages, etudiants, entreprises, formations " +
    " WHERE stages.id == " + notationDB.stage_id.to_s +
    " AND etudiants.id = stages.etudiant_id" +
    " AND entreprises.id = stages.entreprise_id" +
    " AND formations.id = stages.formation_id"

    notationData = JSON.parse ActiveRecord::Base.connection.execute(sqlevol)[0].to_s.gsub("=>", ":")

    @nomEtudiant = notationData["nom"].to_s + " " + notationData["prenom"].to_s
    @promotionEtudiant = notationData["mention"].to_s + " " + notationData["libelle"].to_s
    @entrepriseEtudiant = notationData["raison_sociale"].to_s

    @note = notationDB.note
    @commentaire = notationDB.commentaire
  end

  def saveNotation
    require 'json'
    puts params
    params.require(:note)
    params.require(:id)
    params.require(:commentaire)
    valid_params = true
    if (valid_params)
      @note = params[:note]
      @commentaire = params[:commentaire]
      @id = params[:id]
      data =  Notation.find(@id)
      if (data != nil)
        st = ActiveRecord::Base.connection.raw_connection.prepare("update notations set note=?, commentaire=? where id=?")
        st.execute(@note, @commentaire, @id)
        st.close
        redirect_to action: "viewNotation", id: @id
      end
    end
  end

  def template

    sqlFormatNotation = "select contenu"+
      " FROM notation_formats"+
      " WHERE id = (select MAX(id) FROM notation_formats)"
    formatNotation = ActiveRecord::Base.connection.execute(sqlFormatNotation)

    @jsonGrille = JSON.parse(formatNotation[0]['contenu'])
  end
end