const form = document.getElementById('form');
form.onsubmit = submit;

const result = document.getElementById('result');

function get(e, d) {
    return e && e.value ? e.value : d;
}

function submit(event) {
    event.preventDefault();
    const url = form.elements['url'] ?
        form.elements['url'].value :
        "/api/figlet/";

    const data = {
        "text": get(form.elements['text'], "Figlet"),
        "font": get(form.elements['font'], "standard"),
        "direction": get(form.elements['direction'], "auto"),
        "justify": get(form.elements['justify'], "auto"),
        "width": parseInt(
            get(form.elements['width'], "80"),
            10
        )
    };

    result.classList.add("spinner")
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        result.innerText = data.text
        result.classList.remove("spinner")
    });
}
