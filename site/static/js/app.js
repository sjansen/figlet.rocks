const form = document.getElementById('form');
form.onsubmit = submit;

const result = document.getElementById('result');

function get(e, d) {
    if (!e || !e.type) {
        return d;
    }
    switch (e.type) {
    case 'checkbox':
        return e.checked;
    default:
        return e.value ? e.value : d;
    }
}

function submit(event) {
    event.preventDefault();
    const url = form.elements['url'] ?
        form.elements['url'].value :
        "/api/figlet/";

    const data = {
        "direction": get(form.elements['direction'], "auto"),
        "flip": get(form.elements['flip'], false),
        "font": get(form.elements['font'], "standard"),
        "justify": get(form.elements['justify'], "auto"),
        "reverse": get(form.elements['reverse'], false),
        "text": get(form.elements['text'], "FIGlet"),
        "vtrim": get(form.elements['vtrim'], false),
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
