class NotationFormatsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    redirect_to action: "show", id: NotationFormats.first.nil? ? 0 : NotationFormats.last.id
  end

  def new
    redirect_to action: "show", id: 0
  end

  def show
    @notation_id = params[:id]
    @notation_formats = if NotationFormats.exists?(params[:id])
                    JSON.parse NotationFormats.find(params[:id]).contenu.to_s
                  else
                    @notation_id = "new"
                    JSON.parse '{"bareme":[]}'
                  end
    @notation_ids = NotationFormats.ids
  end

  def create
    @NotationFormats_to_save = NotationFormats.new
    @NotationFormats_to_save.contenu = params[:notation_format].to_s.gsub("=>", ":")

    if @NotationFormats_to_save.save
      redirect_to @NotationFormats_to_save
    end
  end
end