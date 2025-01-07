<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Collaborative Whiteboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --slider-bg: #000000;
          }
          
        
        /* General Body Styling */
        
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            transition: background-color 0.3s, color 0.3s;
        }
        
        body.dark-mode {
            background-color: #1e1e1e;
            color: #eaeaea;
        }
        
        /* Navbar */
        .navbar {
            background-color: #f8f9fa;
            transition: background-color 0.3s, color 0.3s;
        }
        
        body.dark-mode .navbar {
            background-color: #292929;
            color: #eaeaea;
        }
        
        .navbar-brand {
            font-weight: bold;
        }
        
        body.dark-mode .navbar-brand {
            color: #eaeaea;
        }
        
        /* Canvas */
        #whiteboard {
            width: 100%;
            height: 80vh;
            cursor: crosshair;
            background-color: #fff;
            border: 2px solid #ccc;
            border-radius: 8px;
            transition: background-color 0.3s, border-color 0.3s;
        }
        
        body.dark-mode #whiteboard {
            background-color: #2b2b2b;
            border-color: #555;
        }
        
        /* Tools Section */
        .tools-heading {
            color: #444;
            transition: color 0.3s;
        }
        
        body.dark-mode .tools-heading {
            color: #eaeaea;
        }
        
        .tools, .collaborators {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            transition: background-color 0.3s, color 0.3s, box-shadow 0.3s;
        }
        
        #brushSize::-webkit-slider-runnable-track {
            background: var(--slider-bg);
          }
          
          
        
        body.dark-mode .tools,
        body.dark-mode .collaborators {
            background-color: #292929;
            color: #eaeaea;
        }
        
        /* Collaborators List */
        .list-group-item {
            transition: background-color 0.3s, color 0.3s;
        }
        
        body.dark-mode .list-group-item {
            background-color: #2b2b2b;
            color: #eaeaea;
            -webkit-text-fill-color: #ccc;
        }
        
        /* Buttons */
        button {
            transition: background-color 0.3s, color 0.3s;
        }
        
        body.dark-mode button {
            background-color: #444;
            color: #eaeaea;
        }
        
        /* Dark Mode Toggle */
        #darkModeToggle {
            border-color: #ccc;
        }
        
        body.dark-mode #darkModeToggle {
            border-color: #555;
        }
        
    </style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid vh-100 d-flex flex-column" id="app">
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg shadow-sm py-3">
            <div class="container-fluid">
                <a class="navbar-brand fw-bold text-primary" href="">
                    <img src="/images/icon.png" alt="Logo" width="30" height="30" class="d-inline-block align-text-top"> 
                    Whiteboard Pro
                </a>
                <div class="d-flex align-items-center">
                    <span id="usernameDisplay" class="navbar-text me-3"></span>
                    <button id="darkModeToggle" class="btn btn-outline-secondary me-2">
                        <i class="bi bi-moon-fill" id="darkModeIcon"></i> <span id="darkModeText"></span>
                    </button>
                    <a href="signin" id="signinBtn" class="btn btn-primary me-2">Sign In</a>
                    <button id="logoutBtn" class="btn btn-outline-danger" style="display: none;">Logout</button>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="row flex-grow-1">
            <!-- Canvas Section -->
            <div class="col-md-9 d-flex justify-content-center align-items-center position-relative">
                <canvas id="whiteboard" class="border rounded shadow-lg"></canvas>
                <div id="loadingGif" class="position-absolute d-none">
                    <img src="loading.gif" alt="Loading" class="rounded-circle">
                </div>
            </div>

            <!-- Tools and Collaborators -->
            <div class="col-md-3 px-4 py-3 border-start shadow-sm">
                <!-- Tools -->
                <h4 class="fw-bold tools-heading">Tools</h4>
                <div class="mb-3">
                    <label for="colorPicker" class="form-label">Brush Color</label>
                    <input type="color" id="colorPicker" class="form-control form-control-color">
                </div>
                <div class="mb-3">
                    <label for="brushSize" class="form-label">Brush Size</label>
                    <input type="range" id="brushSize" class="form-range" min="1" max="20" value="5">
                </div>
                <button id="clearBtn" class="btn btn-danger w-100">Clear Board</button>

                <!-- Collaborators -->
                <div class="mt-4">
                    <h4 class="fw-bold tools-heading">Collaborators</h4>
                    <ul id="collaboratorList" class="list-group">
                        <li class="list-group-item text-center text-muted">No collaborators yet.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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
        
    </script>
</body>
</html>
