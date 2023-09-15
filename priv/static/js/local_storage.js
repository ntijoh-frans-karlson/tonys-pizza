const input = document.querySelector("input")
    h2 = document.querySelector("h2");

input.addEventListener("keyup", display);

function diplay() {
    localStorage.setItem("value", input.value);
    h2.innerHTML = localStorage.getItem("value")
}
