class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def home; end

  def evaluation
    require 'json'
    text =  '{"annee": "","nom": "","entreprise": "","poste": "","activité": "","date":"","sections":[{"titre": "Savoir-être","choix": ["Non évalué", "A travailler", "Acquis"],"competences":[{"intitule": "Investi et motivé","requis": 2,"selection": -1},{"intitule": "Anglais","requis": 1,"selection": -1}]},{"titre": "Compétences transverses","choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],"competences":[{"intitule": "Organisé","requis": 3,"selection": -1}]}],"commentaire": ""}'

    @data = JSON.parse(text)  # <--- no `to_json`
    # => {"one"=>1, "two"=>2}
    puts @data.class

    respond_to do |format|
      format.html
      format.pdf do
        pdf = ConsultationEval.new(@data)
        # pdf = Prawn::Document.new
        # pdf.text "Hello"
        send_data pdf.render, filename: 'member.pdf', type: 'application/pdf', disposition: "inline"
      end
    end
  end

  def save
    text =  '{"annee": "","nom": "","entreprise": "","poste": "","activité": "","date":"","sections":[{"titre": "Savoir-être","choix": ["Non évalué", "A travailler", "Acquis"],"competences":[{"intitule": "Investi et motivé","requis": 2,"selection": 2},{"intitule": "Anglais","requis": 1,"selection": -1}]},{"titre": "Compétences transverses","choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],"competences":[{"intitule": "Organisé","requis": 3,"selection": 1}]}],"commentaire": ""}'

    @text_json = JSON.parse(text)

    params.delete('action')
    params.delete('controller')

    params.each do |key, value|
      if @text_json.key?(key)
        @text_json[key] = params[key]
      else
        @text_json['sections'].each_with_index do |value_data, index_data|
          value_data['competences'].each_with_index do |value_comp, index_comp|
            if value_comp['intitule'] == key
              @text_json['sections'][index_data]['competences'][index_comp]['selection'] = value.to_i
            end
          end
        end
      end
    end

    @json_add_to_db = Evaluation.new
    @json_add_to_db.contenu = @text_json.to_json
    @json_add_to_db.est_auto_evaluation = true
    @json_add_to_db.save
  end

  def viewEvaluation
    require 'json'
    text =  '{"année": "2020-2021","nom": "Dumas Richard","entreprise": "SAS Entreprise","poste": "Développeur web","activité": "Développement de modules pour ERP web","date":"26/02/2021","sections":[{"titre": "Savoir-être","choix": ["Non évalué", "A travailler", "Acquis"],"competences":[{"intitule": "Investi et motivé","requis": 2,"selection": 2},{"intitule": "Anglais","requis": 1,"selection": 2}]},{"titre": "Compétences transverses","choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],"competences":[{"intitule": "Organisé","requis": 3,"selection": 1}]}],"commentaire": "Test de commentaire Test de commentaire Test de commentaire Test de commentaire"}'

    @data = JSON.parse(text)  # <--- no `to_json`
    # => {"one"=>1, "two"=>2}
    puts @data.class

    respond_to do |format|
      format.html
      format.pdf do
        pdf = ConsultationEval.new(@data)
        # pdf = Prawn::Document.new
        # pdf.text "Hello"
        send_data pdf.render, filename: 'member.pdf', type: 'application/pdf', disposition: "inline"
      end
    end
  end

  def menuEtudiant

  end

  def tableauDeBord
    require 'json'
    text =  '{"etudiants":[{"nom": "Marie Danede","promotion": "M2 Miage", "entreprise": "Bordeaux Metropole", "autoevaluation": 1, "grilleevaluation": 2, "autoevaluationfinale": 7, "grilleevaluationfinale": 3,  "note": "B"}, {"nom": "Nawel Ouadhour","promotion": "M2 Miage", "entreprise": "Atos", "autoevaluation": null, "grilleevaluation": null, "autoevaluationfinale": null, "grilleevaluationfinale": null,  "note": null}]}'

    @data = JSON.parse(text)
  end

  def menuRespStage

  end

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

