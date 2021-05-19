class NotationsController < ApplicationController
  def notation
    require 'json'
    text =  '{"bareme":[{"libelle": "Un stage durant lequel des problèmes se sont manifestés du fait de l\'étudiant","valeur": "E"}, {"libelle": "Aucun véritable problème ne s’est manifesté mais les résultats  escomptés n’ont pas été atteints","valeur": "D"},{"libelle": "Stage moyen, sans reproche particulier à faire à l’étudiant","valeur": "C"},{"libelle": "Stage de bonne qualité, les objectifs ont été atteints et les résultats sont  utiles à l’entreprise","valeur": "B"},{"libelle": "Stage excellent où les résultats dépassent les objectifs assignés","valeur": "A"}]}'

    @data = JSON.parse(text)

    @nomEtudiant = 'Durand Charles'
    @promotionEtudiant = 'M2 Miage'
    @entrepriseEtudiant = 'ATOS'
  end

  def viewNotation
    require 'json'
    text =  '{"bareme":[{"libelle": "Un stage durant lequel des problèmes se sont manifestés du fait de l\'étudiant","valeur": "E"}, {"libelle": "Aucun véritable problème ne s’est manifesté mais les résultats  escomptés n’ont pas été atteints","valeur": "D"},{"libelle": "Stage moyen, sans reproche particulier à faire à l’étudiant","valeur": "C"},{"libelle": "Stage de bonne qualité, les objectifs ont été atteints et les résultats sont  utiles à l’entreprise","valeur": "B"},{"libelle": "Stage excellent où les résultats dépassent les objectifs assignés","valeur": "A"}]}'

    @data = JSON.parse(text)

    @nomEtudiant = 'Durand Charles'
    @promotionEtudiant = 'M2 Miage'
    @entrepriseEtudiant = 'ATOS'

    @note = 'C'
    @commentaire = 'Très bon stage dans l\'ensemble, étudiant très volontaire'
  end
end