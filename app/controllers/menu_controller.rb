class MenuController < ApplicationController

  @bool_test = false

  def menuEtudiant

  end

  def menuRespStage

  end

  def require_login
    if (@bool_test == false)
      redirect_to(menuetudiant_path)
    else
      redirect_to(menurespstage_path)
    end
  end
end