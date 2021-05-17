class ConsultationEval < Prawn::Document
  def initialize(data)
    super()
    span(350, :position => :center) do
      image open(Rails.root.to_s + '/app/assets/images/IMG_BdxMiage.png')
    end
    move_down(10)
    text "Suivi de la période en entreprise"
    move_down(10)
    text "- à remplir par l’alternant/l’étudiant avant la visite en entreprise
    - base de l’échange durant la visite en entreprise
    - à renvoyer à claude.mansart@u-bordeaux.fr
      dans le dossier de suivi des alternants (si alternant)
    - feuille de suivi à réutiliser lors de la soutenance de fin d’année "
    move_down(10)

    data.each do |key, value|
      if (key != 'sections' && key != 'commentaire') then
        text key + " : " + value
        move_down(5)
      end
    end
    move_down(10)
    text "En bleu : le niveau de compétences attendu à l’obtention du diplôme de Master."
    move_down(10)

    dataTable = []
    ligne = 0
    colonne = 1
    nbcolonne = 0
    indiceRequis = []

    data['sections'].each_with_index do |valueData, indexData|
      dataTableHead = ["<color rgb='23BCDE'>"+valueData['titre']+"</color> "]

      valueData['choix'].each do |valueChoix|
        dataTableHead = dataTableHead.push(valueChoix)
      end

      dataTable.push(dataTableHead)

      valueData['competences'].each do |valueComp|
        dataCompetence = []
        dataCompetence = dataCompetence.push(valueComp['intitule'])
        ligne += 1
        valueData['choix'].each_with_index do |val, index|

          if index == valueComp['requis'] then
            indiceRequis.append([ligne, colonne])
            if index == valueComp['selection'] then
              dataCompetence = dataCompetence.push('X ')
            else
              dataCompetence = dataCompetence.push(' ')
            end
          else
            if index == valueComp['selection'] then
              dataCompetence = dataCompetence.push('X')
            else
              dataCompetence = dataCompetence.push(' ')
            end
          end
          colonne += 1
        end

        colonne = 1
        dataTable.push(dataCompetence)
        nbcolonne = dataCompetence.length
        puts(dataCompetence.length)
      end

      table(dataTable, :cell_style => { :inline_format => true }) do
        self.row(0).font_style = :bold
        cells.column(0).width = 350

        columns(1..nbcolonne).width = 230/nbcolonne
        # row(0).columns(1..nbcolonne).rotate = 90
        # row(0).columns(1..nbcolonne).rotate_around = :center
        # row(0).height = 100

        cells.style.background_color = "FFFFFF"
        columns(1..nbcolonne).align = :center

        for i in indiceRequis
          self.row(i[0]).column(i[1]).background_color = '23BCDE'
          self.row(i[0]).column(i[1]).text_color = "FFFFFF"
        end
      end
      move_down(10)
      dataTable = []
      ligne = 0
      indiceRequis = []
      start_new_page
    end

    text "D’autres compétences peuvent être également développées pendant le stage.
    Liste non exhaustive :
    - Favoriser l’amélioration et l’innovation
    - Coordonner l’activité d’une équipe
    - Intégrer l’ensemble des outils informatiques dans un système cohérent
    - Concevoir l’architecture informatique de l’entreprise..."
    move_down(10)
    if data.has_key?('commentaire') then
      if data['commentaire'] != '' then
        text "Commentaire : " + data['commentaire']
      end
    end
  end
end
