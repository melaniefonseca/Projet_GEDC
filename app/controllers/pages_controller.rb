class PagesController < ApplicationController

  def home; end

  def statistiques
    @data = [["A", 13], ["B",  3], ["C",  7]]
  end
end

