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

  def evolution
    require 'json'
    text =  '{"etudiants":[{"nom": "Marie Danede","promotion": "M2 Miage", "entreprise": "Bordeaux Metropole", "savoiretre": 1, "competencestransverses": 2, "competencesdisciplinaire": 2, "global": 3}, {"nom": "Nawel Ouadhour","promotion": "M2 Miage", "entreprise": "Atos", "savoiretre": 1, "competencestransverses": 2, "competencesdisciplinaire": 1, "global": 3}]}'

    @data = JSON.parse(text)

    grille =  '{"année": "2020-2021","nom": "Dumas Richard","entreprise": "SAS Entreprise","poste": "Développeur web","activité": "Développement de modules pour ERP web","date":"26/02/2021","sections":[{"titre": "Savoir-être","choix": ["Non évalué", "A travailler", "Acquis"],"competences":[{"intitule": "Investi et motivé","requis": 2,"selection": 2},{"intitule": "Anglais","requis": 1,"selection": 2}]},{"titre": "Compétences transverses","choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],"competences":[{"intitule": "Organisé","requis": 3,"selection": 1}]}],"commentaire": "Test de commentaire Test de commentaire Test de commentaire Test de commentaire"}'
    grillefinal = '{"année": "2020-2021","nom": "Dumas Richard","entreprise": "SAS Entreprise","poste": "Développeur web","activité": "Développement de modules pour ERP web","date":"26/02/2021","sections":[{"titre": "Savoir-être","choix": ["Non évalué", "A travailler", "Acquis"],"competences":[{"intitule": "Investi et motivé","requis": 2,"selection": 1},{"intitule": "Anglais","requis": 1,"selection": 2}]},{"titre": "Compétences transverses","choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],"competences":[{"intitule": "Organisé","requis": 3,"selection": 3}]}],"commentaire": "Test de commentaire Test de commentaire Test de commentaire Test de commentaire"}'

    @dataGrille = JSON.parse(grille)
    @dataGrilleFinal =JSON.parse(grillefinal)

    tabGrilleSelection = []
    @dataGrille['sections'].each_with_index do |valueData, indexData|
      valueData['competences'].each do |valueComp|
        tabGrilleSelection.append([valueData['titre'], valueComp['selection']])
      end
    end
    # puts(tabGrilleSelection)
    tabGrilleFinalSelection = []
    @dataGrilleFinal['sections'].each_with_index do |valueData, indexData|
      valueData['competences'].each do |valueComp|
        tabGrilleFinalSelection.append([valueData['titre'], valueComp['selection']])
      end
    end
    # puts(tabGrilleFinalSelection)

    sections = ''
    tabEvolution = []
    progression = 0
    indice = 0
    multipleSection = false
    for i in tabGrilleSelection
      if (sections != i[0])
        if (sections != '')
          tabEvolution.append([sections, progression])
        end
        multipleSection = true
        sections = i[0]
        progression = 0
      end

      if(i[1] < tabGrilleFinalSelection[indice][1])
        progression += 1
      else
        if(i[1] > tabGrilleFinalSelection[indice][1])
          progression -= 1
        end
      end

      indice +=1
    end

    if (multipleSection)
      tabEvolution.append([sections, progression])
    end

    puts(tabEvolution)
  end
end

