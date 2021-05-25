import $ from 'jquery';

var libelle_container = $("tr#libelles")
var value_container = $("tr#values")
var json = JSON.parse($("p#mydata").html());

function add_libelle(key) {
    let newth = document.createElement("th");
    newth.id = key;
    newth.className = "text-center text-mediumblue font-normal";

    let newCloseButton = document.createElement("button");
    newCloseButton.className = "btn-close";
    newCloseButton.type = "button";
    newCloseButton.setAttribute("aria-label", "Close");
    newCloseButton.onclick = function () {
        let p = document.getElementById("libelles");
        let v = document.getElementById("values");
        while (p.firstChild) {
            p.removeChild(p.firstChild);
            v.removeChild(v.firstChild);
        }
        json["bareme"].splice(key, 1);
        main();
    };

    let newTextArea = document.createElement("textarea");
    newTextArea.id = key;
    newTextArea.value = json["bareme"][key]["libelle"];
    newTextArea.className = "form-control text-center text-mediumblue font-normal";
    newTextArea.setAttribute("rows", "6");
    newTextArea.onchange = function() {
        json["bareme"][this.id]["libelle"] = this.value;
    };

    newth.append(newCloseButton);
    newth.append(newTextArea);

    libelle_container.append(newth);
}

function add_value(key) {
    let newtd = document.createElement("td");
    newtd.id = key;
    newtd.className = "text-center";

    let newInput = document.createElement("input");
    newInput.id = key;
    newInput.value = json["bareme"][key]["valeur"];
    newInput.className = "form-control text-center text-mediumblue font-normal";
    newInput.onchange = function() {
        json["bareme"][key]["valeur"] = this.value;
    };

    newtd.append(newInput);

    value_container.append(newtd);
}

function add_bareme() {
    let key = json["bareme"].length;
    json["bareme"].push({"libelle":"Inserer un libelle","valeur":"Note"});
    add_libelle(key);
    add_value(key);
}

function commentaire_manager () {
    // Ajout du commentaire dans le formulaire
    if (json.hasOwnProperty('commentaire')) {
        delete json["commentaire"];
    } else { // Suppression du commentaire dans le formulaire
        json["commentaire"] = "";
    }
}

function submit_json() {
    let xhr = new XMLHttpRequest();
    let url = $('button#submit_button').val();
    if (!json.hasOwnProperty("selection")) {
        json["selection"] = "";
    }
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(JSON.stringify(json));
    window.location.replace(url);
}

// Fonction de génération des champs personalisable par le JSON en BDD
function main() {
    for (var key in json["bareme"]){
        add_libelle(key);
        add_value(key);
    }
    if (json.hasOwnProperty("commentaire")) {
        $('input#commentaire').prop('checked', true);
    } else {
        $('input#commentaire').prop('checked', false);
    }
}

main();

// EventListener
$(() =>
    $('button#add_bareme').on('click', () => add_bareme()),
    $('button#submit_button').on('click', () => submit_json()),
    $('input#commentaire').on('change', () => commentaire_manager ())
);

$('select#ver').change(function(){
    window.location.replace($(this).val());
});
