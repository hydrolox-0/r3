<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Collaborative Whiteboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* General Styles */
        body {
            transition: background-color 0.3s, color 0.3s;
        }
        /* Dark Mode Styles */
        body.dark-mode {
            background-color: #121212;
            color: #ffffff;
        }
        .dark-mode .card {
            background-color: #1e1e1e;
            color: #ffffff;
        }
        .dark-mode .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .dark-mode .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004b9a;
        }
        .dark-mode .btn-outline-secondary {
            color: #ffffff;
            border-color: #ffffff;
            background-color: #444;
        }
        .dark-mode .btn-outline-secondary:hover {
            background-color: #2d2d2d;
        }
        body.dark-mode button {
            background-color: #444;
            color: #eaeaea;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <!-- Dark Mode Toggle -->
        <div class="d-flex justify-content-end mb-3">
            <button id="darkModeToggle" class="btn btn-outline-secondary" aria-label="Toggle Dark Mode">
                <i class="bi bi-moon-fill" id="darkModeIcon"></i>
            </button>
        </div>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h2 class="text-center">Sign In</h2>
                    </div>
                    <div class="card-body">
                        <form id="SigninForm" novalidate>
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" required>
                                <div class="invalid-feedback">Please enter your username.</div>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" required>
                                <div class="invalid-feedback">Please enter your password.</div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 mb-3">Sign In</button>
                            <a href="signup" class="btn btn-outline-secondary w-100">Sign Up</a>
                        </form>
                    </div>
                </div>
                <div class="mt-3 text-center">
                    <a href="/Whiteboard/board">Back to Whiteboard</a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Dark Mode Toggle Logic
        const darkModeToggle = document.getElementById('darkModeToggle');
        const darkModeIcon = document.getElementById('darkModeIcon');

        // Check dark mode preference from localStorage
        const isDarkMode = localStorage.getItem('darkMode') === 'true';
        if (isDarkMode) {
            document.body.classList.add('dark-mode');
            darkModeIcon.classList.replace('bi-moon-fill', 'bi-sun-fill');
        }

        // Toggle dark mode
        darkModeToggle.addEventListener('click', () => {
            const isDark = document.body.classList.toggle('dark-mode');
            localStorage.setItem('darkMode', isDark);
            darkModeIcon.classList.toggle('bi-moon-fill');
            darkModeIcon.classList.toggle('bi-sun-fill');
        });

        // Signin Form Logic
        const signinForm = document.getElementById('SigninForm');
        signinForm.addEventListener('submit', function (e) {
            e.preventDefault();

            // Form validation
            if (!signinForm.checkValidity()) {
                signinForm.classList.add('was-validated');
                return;
            }

            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;

            // Simulate successful Signin
            localStorage.setItem('loggedInUser', JSON.stringify({ name: username, color: getRandomColor() }));
            alert(`Signin successful! Welcome, ${username}`);
            window.location.href = '/Whiteboard/board';
        });

        function getRandomColor() {
            return `#${Math.floor(Math.random() * 16777215).toString(16)}`;
        }
    </script>
</body>
</html>
