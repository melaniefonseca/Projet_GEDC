class EvaluationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def evaluation
    sql = "Select * from ge_formats ORDER BY id DESC LIMIT 1 "
    @res = ActiveRecord::Base.connection.execute(sql)

    @data = JSON.parse(@res[0]["contenu"])

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

    @json_add_to_db = Evaluation.new
    @json_add_to_db.contenu = @text_json.to_json
    @json_add_to_db.auto_evaluation = true
    @json_add_to_db.save
  end

  def viewEvaluation
    if params[:id] == nil
      redirect_to(evaluation_path)
    else
      sql = "Select * from evaluations where id == " + params[:id]
      @res = ActiveRecord::Base.connection.execute(sql)

      @data = JSON.parse(@res[0]["contenu"])
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
end