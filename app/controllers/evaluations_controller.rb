class EvaluationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def evaluation
    sql = "Select * from ge_formats ORDER BY id DESC LIMIT 1 "
    res = ActiveRecord::Base.connection.execute(sql)

    if res.present?
      @data = JSON.parse(res[0]["contenu"])
    else
      @data = ""
    end

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
    sql = "Select * from ge_formats ORDER BY id DESC LIMIT 1 "
    @res = ActiveRecord::Base.connection.execute(sql)

    @text_json = JSON.parse(@res[0]["contenu"])

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

    sql = "Update evaluations set contenu = " +"'" + @text_json.to_json + "', rempli = 1 where id == " + params[:id]
    ActiveRecord::Base.connection.execute(sql)
    redirect_to action: "viewEvaluation", id: params[:id]
  end

  def viewEvaluation
    if params[:id] == nil
      redirect_to(evaluation_path)
    else
      sql = "Select * from evaluations where id == " + params[:id]
      res = ActiveRecord::Base.connection.execute(sql)

      if res.present?
        @data = JSON.parse(res[0]["contenu"])
      end
    end

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

  def editEvaluation
    if params[:id] == nil
      redirect_to(evaluation_path)
    else
      @url_save = "/evaluation/save/" + params[:id]
      sql = "Select * from evaluations where id == " + params[:id]
      res = ActiveRecord::Base.connection.execute(sql)
    end

    if res.present?
      if res[0]['rempli'] == 1
        redirect_to action: "viewEvaluation", id: params[:id]
      else
        @data = JSON.parse(res[0]["contenu"])
      end
    end

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

  def template
    sqlFormatGrille = "select contenu"+
      " FROM ge_formats"+
      " WHERE id = (select MAX(id) FROM ge_formats)"
    formatGrille = ActiveRecord::Base.connection.execute(sqlFormatGrille)

    @jsonGrille = JSON.parse(formatGrille[0]['contenu'])

  end
end