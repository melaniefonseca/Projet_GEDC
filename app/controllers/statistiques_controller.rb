class StatistiquesController < ApplicationController
  def statistiques
    @data = [["A", 13], ["B",  17], ["C",  20],["D",  30], ["E",  20]]
  end
end