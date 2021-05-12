class PagesController < ApplicationController
  def home

  end

  def showForm

    require 'json'
    text =  '{"annee": "","nom": "","entreprise": "","poste": "","activité": "","date":"","sections":[{"titre": "Savoir-être","choix": ["Non évalué", "A travailler", "Acquis"],"competences":[{"intitule": "Investi et motivé","requis": 2,"selection": 2},{"intitule": "Anglais","requis": 1,"selection": -1}]},{"titre": "Compétences transverses","choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],"competences":[{"intitule": "Organisé","requis": 3,"selection": 1}]}],"commentaire": ""}'

    @data = JSON.parse(text)  # <--- no `to_json`
    # => {"one"=>1, "two"=>2}
    puts @data.class

  end

  def viewAutoEval
    require 'json'
    text =  '{"année": "2020-2021","nom": "Dumas Richard","entreprise": "SAS Entreprise","poste": "Développeur web","activité": "Développement de modules pour ERP web","date":"26/02/2021","sections":[{"titre": "Savoir-être","choix": ["Non évalué", "A travailler", "Acquis"],"competences":[{"intitule": "Investi et motivé","requis": 2,"selection": 2},{"intitule": "Anglais","requis": 1,"selection": 2}]},{"titre": "Compétences transverses","choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],"competences":[{"intitule": "Organisé","requis": 3,"selection": 1}]}],"commentaire": "Test de commentaire Test de commentaire Test de commentaire Test de commentaire"}'

    @data = JSON.parse(text)  # <--- no `to_json`
    # => {"one"=>1, "two"=>2}
    puts @data.class
  end

  def menuEtudiant

  end

  def grilleVierge
    require 'json'
    text =  '{"annee": "","nom": "","entreprise": "","poste": "","activité": "","date":"","sections":[{"titre": "Savoir-être","choix": ["Non évalué", "A travailler", "Acquis"],"competences":[{"intitule": "Investi et motivé","requis": 2,"selection": -1},{"intitule": "Anglais","requis": 1,"selection": -1}]},{"titre": "Compétences transverses","choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],"competences":[{"intitule": "Organisé","requis": 3,"selection": -1}]}],"commentaire": ""}'

    @data = JSON.parse(text)  # <--- no `to_json`
    # => {"one"=>1, "two"=>2}
    puts @data.class
  end

  def viewGrilleStage
    require 'json'
    text =  '{"année": "2020-2021","nom": "Dumas Richard","entreprise": "SAS Entreprise","poste": "Développeur web","activité": "Développement de modules pour ERP web","date":"26/02/2021","sections":[{"titre": "Savoir-être","choix": ["Non évalué", "A travailler", "Acquis"],"competences":[{"intitule": "Investi et motivé","requis": 2,"selection": 2},{"intitule": "Anglais","requis": 1,"selection": 2}]},{"titre": "Compétences transverses","choix": ["Non évalué", "Avec aide", "Autonome", "Niveau professionnel"],"competences":[{"intitule": "Organisé","requis": 3,"selection": 1}]}],"commentaire": "Test de commentaire Test de commentaire Test de commentaire Test de commentaire"}'

    @data = JSON.parse(text)  # <--- no `to_json`
    # => {"one"=>1, "two"=>2}
    puts @data.class
  end
end