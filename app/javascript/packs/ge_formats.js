import $ from 'jquery';

var libelle_container = $("div#libelle")
var sections_container = $("div#sections")
var json = JSON.parse($("p#mydata").html());
var tmp_json = 1;

var labelle_table = [];

// Ajout de "Input" pour un parent donné
function add_input_to_parent(key, parent, i) {
    let newdiv = document.createElement("div");
    newdiv.id = i;
    newdiv.className = "my-2 px-3";

    let newCloseButton = document.createElement("button");
    newCloseButton.className = "btn-close";
    newCloseButton.type = "button";
    newCloseButton.setAttribute("aria-label", "Close");
    newCloseButton.onclick = function() {
        delete json[labelle_table[i]];
        $('div#' + i).remove();
    };
    newdiv.append(newCloseButton);

    let newInput = document.createElement("input");
    newInput.value = key;
    newInput.className = "capitalized formLabel formLabel-large text-mediumblue";
    newInput.onchange = function() {
        let current_val = this.value;
        let current_id = labelle_table[i];
        if (this.value.length > 0) {
            if (!json.hasOwnProperty(current_val)) {
                labelle_table[i] = current_val;
                json = JSON.parse((JSON.stringify(json)).replace(current_id, current_val));
            } else {
                this.value = current_id;
                alert("Ce champ est déjà existant.")
            }
        } else {
            this.value = current_id;
            alert("Impossible de mettre un libellé vide.")
        }
    };
    newdiv.append(newInput);

    newdiv.append(document.createElement("br"));
    newdiv.append(document.createElement("br"));
    parent.append(newdiv);
}

// Ajout de "Section" pour un parent donné
function add_section_to_parent(data, section_id, parent) {
    let newdiv = document.createElement("div");
    newdiv.id =  "section" + section_id;
    newdiv.className = "section";

    let newdivBlock = document.createElement("div");
    newdivBlock.className = "block block-large";

    let newdivst = document.createElement("div");
    newdivst.className = "sous-titre";

    let newInput = document.createElement("input");
    newInput.value = data["titre"];
    newInput.id = data["titre"];
    newInput.className = "capitalized formLabel formLabel-large text-mediumblue";
    newInput.onchange = function() {
        let current_val = this.value;
        let already_exist = false;

        if (this.value.length > 0) {
            let current_id = this.id;
            for (let j = 0; j < json['sections'].length; j++) {
                if (json['sections'][j]['titre'] === current_val) {
                    already_exist = true;
                }
            }
            if (!already_exist) {
                json = JSON.parse((JSON.stringify(json)).replace(current_id, current_val));
                this.id = current_val;
            } else {
                this.value = current_id;
                alert("Une section possède déjà ce titre.");
            }
        } else {
            this.value = this.id;
            alert("Impossible de mettre un titre vide.")
        }
    };

    let newDeleteSectionButton = document.createElement("button");
    newDeleteSectionButton.className = "btn-close";
    newDeleteSectionButton.type = "button";
    newDeleteSectionButton.id = 'buttonsection' + section_id;
    newDeleteSectionButton.setAttribute("aria-label", "Close");
    newDeleteSectionButton.onclick = function() {
        json["sections"].splice(section_id, 1);
        $('div#' + 'section' + section_id).remove();
    };

    newdivst.append(newInput);
    newdivst.append(newDeleteSectionButton);
    newdivBlock.append(newdivst);

    let newtable = document.createElement("table");
    newtable.className = "table";

    let newthead = document.createElement("thead");

    let newtr = document.createElement("tr");

    let newth = document.createElement("th");

    newtr.append(newth);

    let newInputchoice = document.createElement("input");

    for (let i = 0; i < data["choix"].length; i++) {
        newth = document.createElement("th");
        newInputchoice = document.createElement("input");
        newInputchoice.value = data['choix'][i];
        newInputchoice.className = "text-center text-mediumblue w-80";
        newInputchoice.onchange = function() {
            let already_exist = false;

            if (this.value.length > 0) {
                for (let j = 0; j < data['choix'].length; j++) {
                    if (data['choix'][j] === this.value) {
                        already_exist = true;
                    }
                }
                if (!already_exist) {
                    data['choix'][i] = this.value;
                } else {
                    this.value = data['choix'][i];
                    alert("Un choix possède déjà cet intitulé.")
                }
            } else {
                this.value = data['choix'][i];
                alert("Impossible de mettre un choix vide.")
            }
        };

        let newCloseButtonChoice = document.createElement("button");
        newCloseButtonChoice.className = "btn-close";
        newCloseButtonChoice.type = "button";
        newCloseButtonChoice.setAttribute("aria-label", "Close");
        newCloseButtonChoice.onclick = function() {
            for (let i = 0; i < json['sections'].length; i++) {
                $("div#section"+i).remove();
            }
            data['choix'].splice(i, 1);
            for (let i = 0; i < json['sections'].length; i++) {
                add_section_to_parent(json['sections'][i], i, sections_container);
            }
        };
        newth.append(newInputchoice);
        newth.append(newCloseButtonChoice);
        newtr.append(newth);
    }
    newth = document.createElement("th");
    newth.className = "text-right";
    let newAddChoixButton = document.createElement("button");
    newAddChoixButton.className = "btn btn-round btn-sm px-3 mt-2";
    newAddChoixButton.type = "button";
    newAddChoixButton.id = "add_choix_button_" + section_id;
    newAddChoixButton.innerHTML = '+';
    newAddChoixButton.onclick = function() {
        for (let i = 0; i < json['sections'].length; i++) {
            $("div#section"+i).remove();
        }
        data['choix'].push("Choix#"+data['choix'].length);
        for (let i = 0; i < json['sections'].length; i++) {
            add_section_to_parent(json['sections'][i], i, sections_container);
        }
    };

    newth.append(newAddChoixButton);
    newtr.append(newth);
    newthead.append(newtr);
    newtable.append(newthead);

    let newtbody = document.createElement("tbody");

    let newtd;

    for (let i = 0; i < data["competences"].length; i++) {
        newtr = document.createElement("tr");
        newtd = document.createElement("td");
        newInputchoice = document.createElement("input");
        newInputchoice.value = data['competences'][i]["intitule"];
        newInputchoice.className = "w-80";
        newInputchoice.onchange = function() {
            let already_exist = false;

            if (this.value.length > 0) {
                for (let j = 0; j < data['competences'].length; j++) {
                    if (data['competences'][j]["intitule"] === this.value) {
                        already_exist = true;
                    }
                }
                if (!already_exist) {
                    data['competences'][i]["intitule"] = this.value;
                } else {
                    this.value = data['competences'][i]["intitule"];
                    alert("Un choix possède déjà cet intitulé.")
                }
            } else {
                this.value = data['competences'][i]["intitule"];
                alert("Impossible de mettre un choix vide.");
            }
        };

        let newCloseButtonChoice = document.createElement("button");
        newCloseButtonChoice.className = "btn-close";
        newCloseButtonChoice.type = "button";
        newCloseButtonChoice.setAttribute("aria-label", "Close");
        newCloseButtonChoice.onclick = function() {
            for (let i = 0; i < json['sections'].length; i++) {
                $("div#section"+i).remove();
            }
            data['competences'].splice(i, 1);
            for (let i = 0; i < json['sections'].length; i++) {
                add_section_to_parent(json['sections'][i], i, sections_container);
            }
        };
        newtd.append(newCloseButtonChoice);
        newtd.append(newInputchoice);
        newtr.append(newtd);

        let newInputRadioButton;
        for (let j = 0; j < data['choix'].length; j++) {
            newtd = document.createElement("td");
            newtd.className = "text-center";
            newInputRadioButton = document.createElement("input");
            newInputRadioButton.type = "radio";
            newInputRadioButton.name = data['competences'][i]["intitule"];
            if (data['competences'][i]["requis"] == j) {
                newInputRadioButton.checked = true;
                newInputRadioButton.className += " requis";
            }
            newInputRadioButton.onclick = function() {
                data['competences'][i]["requis"] = j;
            };
            newtd.append(newInputRadioButton);
            newtr.append(newtd);
        }
        newtbody.append(newtr);
    }
    newtable.append(newtbody);
    newdivBlock.append(newtable);

    let newAddButtonCompetences = document.createElement("button");
    newAddButtonCompetences.className = "btn btn-round btn-sm px-3 mt-2";
    newAddButtonCompetences.type = "button";
    newAddButtonCompetences.id = "add_competences_button";
    newAddButtonCompetences.innerHTML = '+';
    newAddButtonCompetences.onclick = function() {
        for (let i = 0; i < json['sections'].length; i++) {
            $("div#section"+i).remove();
        }
        data['competences'].push({"intitule": "competence#"+data['competences'].length,"requis": 0,"selection": -1});
        for (let i = 0; i < json['sections'].length; i++) {
            add_section_to_parent(json['sections'][i], i, sections_container);
        }
    };

    newdivBlock.append(newAddButtonCompetences);
    newdiv.append(newdivBlock);
    parent.append(newdiv);
}

function commentaire_manager () {
    // Ajout du commentaire dans le formulaire
    if (json.hasOwnProperty('commentaire')) {
        delete json["commentaire"];
    } else { // Suppression du commentaire dans le formulaire
        json["commentaire"] = "";
    }
}

function add_label() {
    let key = "libelle#" + Math.floor(Math.random() * 9000);
    labelle_table.push(key);
    json[key] = "";
    add_input_to_parent(key, libelle_container, labelle_table.length - 1);
}

function add_section() {
    let key = {
        "titre": "Titre n°" + Math.floor(Math.random() * 5),
        "choix": [],
        "competences": []
    };
    json['sections'].push(key);
    add_section_to_parent(key, json['sections'].length-1, sections_container);
}

function send_json() {
    let xhr = new XMLHttpRequest();
    let url = $('button#send_button').val();
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(JSON.stringify(json));
    window.location.replace(url);
}

// Fonction de génération des champs personalisable par le JSON en BDD
function main() {
    var j = 0;
    console.log(json)
    for (var key in json){
        switch (key) {
            case 'commentaire':
                $('input#commentaire').attr("checked", "checked");
                break;
            case 'sections':
                for (let i = 0; i < json['sections'].length; i++) {
                    add_section_to_parent(json['sections'][i], i, sections_container);
                }
                break;
            default:
                labelle_table.push(key);
                add_input_to_parent(key, libelle_container, j++);
        }
    }
}

main();

// Event Listener
$(() =>
        $('button#add_label_button').on('click', () => add_label()),
        $('button#send_button').on('click', () => send_json()),
        $('button#add_section_button').on('click', () => add_section()),
        $('input#commentaire').on('change', () => commentaire_manager ())
);

$('select#ver').change(function(){
    window.location.replace($(this).val());
});