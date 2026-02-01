const content = document.getElementById('container');
console.log(content.textContent)

const firstParagraph = document.querySelector('.title');
console.log(firstParagraph.textContent)

const allParagraph = document.querySelectorAll('.title');
console.log(allParagraph)


const button = document.getElementById("changeTitle");

button.addEventListener("click", () =>{
    firstParagraph.textContent = "Hooolllaaaaa";
    firstParagraph.style.color = "red";
    firstParagraph.style.fontSize = "25px";
})

firstParagraph.addEventListener("mouseover", () => {
    firstParagraph.style.backgroundColor = "red";

firstParagraph.addEventListener("mouseout", () => {
   firstParagraph.style.backgroundColor = "white";


})
