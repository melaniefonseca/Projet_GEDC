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

    dataTable = []
    ligne = 0
    colonne = 0
    indiceRequis = []

    data['sections'].each_with_index do |valueData, indexData|
      dataTableHead = ["<color rgb='23BCDE'>"+valueData['titre']+"</color> "]

      valueData['choix'].each do |valueChoix|
        dataTableHead = dataTableHead.push(valueChoix)
      end

      dataTable.push(dataTableHead)
      ligne += 1
      valueData['competences'].each do |valueComp|
        dataCompetence = []
        dataCompetence = dataCompetence.push(valueComp['intitule'])

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

        colonne = 0
        dataTable.push(dataCompetence)
      end

      puts(indiceRequis)

      table(dataTable, :cell_style => { :inline_format => true }) do
        self.row(0).font_style = :bold
        columns(1..5).align = :center
        self.row(1).column(3).background_color = '005C89'
        self.row(1).column(3).text_color = "FFFFFF"
      end
      move_down(10)
      dataTable = []
      ligne = 0
    end
    move_down(10)
    if data.has_key?('commentaire') then
      if data['commentaire'] != '' then
        text "Commentaire : " + data['commentaire']
      end
    end
  end
end
