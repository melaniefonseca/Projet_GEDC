class GeFormatsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    redirect_to action: "show", id: GeFormats.first.nil? ? 0 : GeFormats.last.id
  end

  def new
    redirect_to action: "show", id: 0
  end

  def show
    @ge_id = params[:id]
    @ge_formats = if GeFormats.exists?(params[:id])
                    JSON.parse GeFormats.find(params[:id]).contenu.to_s
    else
      @ge_id = "new"
      JSON.parse '{"sections":[]}'
                  end
    @ge_ids = GeFormats.ids
  end

  def create
    @GeFormats_to_save = GeFormats.new
    @GeFormats_to_save.contenu = params[:ge_format].to_s.gsub("=>", ":")

    if @GeFormats_to_save.save
      redirect_to @GeFormats_to_save
    end
  end
end