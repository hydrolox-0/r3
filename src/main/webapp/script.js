document.addEventListener('DOMContentLoaded', () => {
    // Initialize variables
    const canvas = document.getElementById('whiteboard');
    const ctx = canvas.getContext('2d');
    const colorPicker = document.getElementById('colorPicker');
    const brushSize = document.getElementById('brushSize');
    const clearBtn = document.getElementById('clearBtn');
    const collaboratorList = document.getElementById('collaboratorList');
    const darkModeToggle = document.getElementById('darkModeToggle');
    const darkModeIcon = document.getElementById('darkModeIcon');
    // const darkModeText = document.getElementById('darkModeText');


    let isDrawing = false;
    let lastX = 0;
    let lastY = 0;

    const usernameDisplay = document.getElementById('usernameDisplay');
    const signinBtn = document.getElementById('signinBtn');
    const logoutBtn = document.getElementById('logoutBtn');

        // Check if a user is logged in
    const loggedInUser = JSON.parse(localStorage.getItem('loggedInUser'));


  

    if (loggedInUser) {
        // Update UI to show username and logout button
        usernameDisplay.textContent = `Welcome, ${loggedInUser.name}!`;
        signinBtn.style.display = 'none';
        logoutBtn.style.display = 'block';
    } else {
        // If not logged in, show signin button
        usernameDisplay.textContent = '';
        signinBtn.style.display = 'block';
        logoutBtn.style.display = 'none';
    }

        // Logout button functionality
    logoutBtn.addEventListener('click', () => {
        localStorage.removeItem('loggedInUser'); // Clear user info
        alert('You have logged out successfully.');
        location.reload(); // Reload the page to update UI
    });

    // Canvas dimensions
    canvas.width = canvas.offsetWidth;
    canvas.height = canvas.offsetHeight;

    // Simulated collaborators and state management
    // const collaborators = {}; // Format: { userId: { color, lastX, lastY } }
    // const userId = `user-${Date.now()}`; // Unique ID for this user

    // Dark mode state
    const isDarkMode = localStorage.getItem('darkMode') === 'true';

    // Initialize dark mode by default
    if (isDarkMode) {
        document.body.classList.add('dark-mode');
        darkModeIcon.classList.replace('bi-moon-fill', 'bi-sun-fill');
    }

    // Drawing logic
    function startDrawing(e) {
        isDrawing = true;
        [lastX, lastY] = [e.offsetX, e.offsetY];
    }

    function stopDrawing() {
        isDrawing = false;
    }

    function draw(e) {
        if (!isDrawing) return;

        ctx.strokeStyle = colorPicker.value;
        ctx.lineWidth = brushSize.value;
        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';

        ctx.beginPath();
        ctx.moveTo(lastX, lastY);
        ctx.lineTo(e.offsetX, e.offsetY);
        ctx.stroke();

        [lastX, lastY] = [e.offsetX, e.offsetY];

        // Send drawing data to other collaborators
        broadcastDrawing({
            userId,
            color: colorPicker.value,
            brushSize: brushSize.value,
            startX: lastX,
            startY: lastY,
            endX: e.offsetX,
            endY: e.offsetY,
        });
    }

    // Event listeners for the canvas
    canvas.addEventListener('mousedown', startDrawing);
    canvas.addEventListener('mousemove', draw);
    canvas.addEventListener('mouseup', stopDrawing);
    canvas.addEventListener('mouseout', stopDrawing);

    // Clear the whiteboard
    clearBtn.addEventListener('click', () => {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        broadcastClear();
    });

    // Dark Mode Toggle
    darkModeToggle.addEventListener('click', () => {
        const isDark = document.body.classList.toggle('dark-mode');
        localStorage.setItem('darkMode', isDark);
        darkModeIcon.classList.toggle('bi-moon-fill');
        darkModeIcon.classList.toggle('bi-sun-fill');
    });

    // Example: Add a collaborator to the list
    function addCollaborator(username, color) {
        const li = document.createElement('li');
        li.className = 'list-group-item';
        li.textContent = username;
        li.style.color = color;
        collaboratorList.appendChild(li);
    }


    colorPicker.addEventListener('input', function() {
        const colorValue = colorPicker.value;
        document.documentElement.style.setProperty('--slider-bg', colorValue);
      });
    // // Simulate a collaborator joining (for demo purposes)
    // setTimeout(() => addCollaborator('John', '#FF5733'), 1000);
    // setTimeout(() => addCollaborator('Jane', '#33FF57'), 2000);
});
