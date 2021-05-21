class EvolutionsController < ApplicationController
  def evolution
    require 'json'

    idTuteur = 1

    sqlevol = "SELECT stages.id, sujet, type_stage, nom, prenom, mention, raison_sociale " +
      " FROM stages, formations, promotions, etudiants, entreprises " +
      " WHERE tuteur_universitaire_id == " + idTuteur.to_s +
      " AND stages.formation_id = formations.id" +
      " AND formations.promotion_id = promotions.id" +
      " AND stages.etudiant_id = etudiants.id" +
      " AND stages.entreprise_id = entreprises.id " +
      " AND promotions.id = (SELECT MAX(promotions.id) FROM promotions)"
    @evol = ActiveRecord::Base.connection.execute(sqlevol)
    i=0
    text = '{"etudiants":['
      @evol.each do |evol|
        sqlgrille = "select contenu"+
                    "from evaluations"+
                    "WHERE stage_id = " +evol['id']+
                    "AND auto_evalution = 0"+
                    "AND finale =0"
        grille = ActiveRecord::Base.connection.execute(sqlgrille)

        sqlgrillefinal = "select contenu"+
          "from evaluations"+
          "WHERE stage_id = " +evol['id']+
          "AND auto_evalution = 0"+
          "AND finale =1"
        grillefinal = ActiveRecord::Base.connection.execute(sqlgrillefinal)











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









        if(i>0)
          text += ','
        end
        text += '{"nom": "'+evol['nom']+ ' '+evol['prenom'] +'","promotion": "'+evol['mention']+'", "entreprise": "'+evol['raison_sociale']+'", "savoiretre": 1, "competencestransverses": 2, "competencesdisciplinaire": 1, "global": 3}'
        i += 1
      end
    text += ']}'
    @data = JSON.parse(text)


  end
end