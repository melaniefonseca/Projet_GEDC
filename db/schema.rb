# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_11_124430) do

  create_table "entreprises", force: :cascade do |t|
    t.string "raison_sociale"
    t.string "numero_voie"
    t.string "nom_voie"
    t.string "code_postal"
    t.string "ville"
    t.string "email"
    t.string "telephone"
  end

  create_table "etudiants", primary_key: "id_personne", force: :cascade do |t|
  end

  create_table "evaluations", force: :cascade do |t|
    t.string "contenu"
    t.boolean "est_auto_evaluation"
    t.integer "id_stage"
  end

  create_table "formations", force: :cascade do |t|
    t.string "niveau"
    t.string "libelle"
  end

  create_table "ge_formats", force: :cascade do |t|
    t.text "content"
  end

  create_table "maitres_stage", primary_key: "id_personne", force: :cascade do |t|
    t.integer "id_entreprise"
  end

  create_table "personnes", force: :cascade do |t|
    t.string "nom"
    t.string "prenom"
    t.string "email"
    t.string "telephone"
    t.boolean "est_utilisateur"
  end

  create_table "promotions", primary_key: ["id_etudiant", "id_formation"], force: :cascade do |t|
    t.integer "id_etudiant"
    t.integer "id_formation"
    t.string "annee"
  end

  create_table "responsables_stage", primary_key: "id_personne", force: :cascade do |t|
  end

  create_table "stages", force: :cascade do |t|
    t.string "date_debut"
    t.string "date_fin"
    t.string "theme"
    t.string "fonction"
    t.string "sujet"
    t.integer "note"
    t.boolean "est_stage"
    t.integer "id_tuteur_pedagogique"
    t.integer "id_responsable_stage"
    t.integer "id_maitre_stage"
    t.integer "id_etudiant"
  end

  create_table "tuteurs_pedagogique", primary_key: "id_personne", force: :cascade do |t|
  end

  add_foreign_key "etudiants", "personnes", column: "id_personne"
  add_foreign_key "evaluations", "stages", column: "id_stage"
  add_foreign_key "maitres_stage", "entreprises", column: "id_entreprise"
  add_foreign_key "maitres_stage", "personnes", column: "id_personne"
  add_foreign_key "promotions", "etudiants", column: "id_etudiant", primary_key: "id_personne"
  add_foreign_key "promotions", "formations", column: "id_formation"
  add_foreign_key "responsables_stage", "personnes", column: "id_personne"
  add_foreign_key "stages", "etudiants", column: "id_etudiant", primary_key: "id_personne"
  add_foreign_key "stages", "maitres_stage", column: "id_maitre_stage", primary_key: "id_personne"
  add_foreign_key "stages", "responsables_stage", column: "id_responsable_stage", primary_key: "id_personne"
  add_foreign_key "stages", "tuteurs_pedagogique", column: "id_tuteur_pedagogique", primary_key: "id_personne"
  add_foreign_key "tuteurs_pedagogique", "personnes", column: "id_personne"
end
