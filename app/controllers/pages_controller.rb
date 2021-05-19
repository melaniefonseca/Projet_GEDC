class PagesController < ApplicationController

  def home; end



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

  def statistiques
    @data = [["A", 13], ["B",  3], ["C",  7]]
  end
end

