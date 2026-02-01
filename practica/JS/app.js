// --- CONFIGURACIÓN DE IA ---
const API_KEY = "TU_API_KEY"; // ¡Recuerda proteger tu llave!
const AI_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${API_KEY}`;

const EMOJIS = ["🪙", "😊", "😂", "🤣", "❤️", "😍", "😒", "👌", "😘", "💕", "👍", "🤦‍♂️"];
const CARDS = [...EMOJIS, ...EMOJIS];

const gameBoard = document.getElementById("game-board");
const movesElement = document.getElementById("moves");
const timerElement = document.getElementById("timer");
const scoreElement = document.getElementById("score");
const startStopBtn = document.getElementById("start-stop-btn");
const gameInfoElement = document.getElementById("gameInfo");

let gameState = {
    flippedCards: [],
    moves: 0,
    score: 0,
    timer: 0,
    intervalId: null,
    isGameRunning: false,
};

// --- IA ---
async function pedirMensajeIA(prompt) {
    try {
        const respuesta = await fetch(AI_URL, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                contents: [{ parts: [{ text: prompt }] }]
            })
        });
        const data = await respuesta.json();
        return data.candidates[0].content.parts[0].text;
    } catch (error) {
        return "¡Concentración total ahora!";
    }
}

// --- LÓGICA DEL JUEGO ---
const shuffleArray = (array) => {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
};

const createCard = (emoji) => {
    const card = document.createElement("div");
    card.classList.add("card");
    card.dataset.emoji = emoji;
    card.addEventListener("click", () => flipCard(card));
    return card;
};

const flipCard = (card) => {
    if (!gameState.isGameRunning || gameState.flippedCards.length >= 2 || card.classList.contains("flipped")) return;

    card.classList.add("flipped");
    card.textContent = card.dataset.emoji;
    gameState.flippedCards.push(card);

    if (gameState.flippedCards.length === 2) {
        gameState.moves++;
        updateMovesDisplay();
        setTimeout(checkMatch, 600);
    }
};

const checkMatch = () => {
    const [card1, card2] = gameState.flippedCards;
    if (card1.dataset.emoji === card2.dataset.emoji) {
        gameState.score += 10;
        updateScoreDisplay();
        if (document.querySelectorAll(".flipped").length === CARDS.length) {
            gameEnd();
        }
    } else {
        [card1, card2].forEach((card) => {
            card.classList.remove("flipped");
            card.textContent = "";
        });
    }
    gameState.flippedCards = [];
};

const updateMovesDisplay = () => movesElement.textContent = `Movimientos: ${gameState.moves}`;
const updateScoreDisplay = () => scoreElement.textContent = `Puntuación: ${gameState.score}`;
const updateTimerDisplay = () => timerElement.textContent = `Tiempo: ${gameState.timer}s`;

const startTimer = () => {
    gameState.intervalId = setInterval(() => {
        gameState.timer++;
        updateTimerDisplay();
    }, 1000);
};

const startGame = async () => {
    // Reset de estado
    gameState = { ...gameState, flippedCards: [], moves: 0, timer: 0, score: 0, isGameRunning: true };
    
    shuffleArray(CARDS);
    gameBoard.innerHTML = "";
    CARDS.forEach((emoji) => gameBoard.appendChild(createCard(emoji)));
    
    updateScoreDisplay();
    updateMovesDisplay();
    updateTimerDisplay();
    startTimer();

    startStopBtn.textContent = "Detener Juego";
    gameBoard.classList.remove("hidden", "fade-out");
    gameInfoElement.classList.remove("hidden");

    // Llamada a la IA
    const saludo = await pedirMensajeIA("Dame una frase de 5 palabras para alguien que empieza un juego de memoria.");
    gameInfoElement.textContent = saludo;
};

const stopGame = () => {
    gameState.isGameRunning = false;
    clearInterval(gameState.intervalId);
    startStopBtn.textContent = "Iniciar Juego";
    gameBoard.classList.add("fade-out");
    setTimeout(() => gameBoard.classList.add("hidden"), 500);
};

const gameEnd = () => {
    clearInterval(gameState.intervalId);
    const bonus = Math.max(0, 1000 - (gameState.timer * 10) - (gameState.moves * 5));
    const finalScore = gameState.score + bonus;
    alert(`¡Juego terminado! Puntuación Final: ${finalScore}`);
    stopGame();
};

// --- CONTROLADOR ÚNICO ---
startStopBtn.addEventListener("click", () => {
    if (gameState.isGameRunning) {
        stopGame();
    } else {
        startGame();
    }
});