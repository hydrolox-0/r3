<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Collaborative Whiteboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* General Styling */
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

        .card {
            transition: background-color 0.3s, box-shadow 0.3s;
        }

        .form-control {
            transition: background-color 0.3s, color 0.3s, border-color 0.3s;
        }

        .form-control:focus {
            border-color: #80bdff;
            box-shadow: 0 0 0 0.2rem rgba(128, 189, 255, 0.5);
        }

        button {
            transition: background-color 0.3s, color 0.3s;
        }

        body.dark-mode button {
            background-color: #444;
            color: #eaeaea;
        }

        a {
            color: #007bff;
        }

        body.dark-mode a {
            color: #80bdff;
        }
    </style>
</head>

<body>
    <div class="container vh-100 d-flex flex-column justify-content-center align-items-center position-relative">
        <!-- Dark Mode Toggle -->
        <button id="darkModeToggle" class="btn btn-outline-secondary position-absolute top-0 end-0 m-3" aria-label="Toggle Dark Mode">
            <i class="bi bi-moon-fill" id="darkModeIcon"></i>
        </button>
        <div class="card p-4 shadow-lg" style="width: 100%; max-width: 400px;">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="fw-bold">Sign Up</h2>
            </div>
            <form id="signupForm" novalidate>
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input type="text" id="name" class="form-control" placeholder="Enter your name" required>
                    <div class="invalid-feedback">Name is required.</div>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" class="form-control" placeholder="Enter your email" required>
                    <div class="invalid-feedback">Please enter a valid email address.</div>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" class="form-control" placeholder="Enter your password" required>
                    <div class="invalid-feedback">Password is required.</div>
                </div>
                <button type="submit" class="btn btn-primary w-100">Sign Up</button>
            </form>
            <div class="text-center mt-3">
                <p>Already have an account? <a href="signin" class="text-primary">Sign in</a></p>
            </div>
        </div>
    </div>
    

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const signupForm = document.getElementById('signupForm');
            const darkModeToggle = document.getElementById('darkModeToggle');
            const darkModeIcon = document.getElementById('darkModeIcon');

            // Check and apply saved dark mode preference
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

            // Validate form on submission
            signupForm.addEventListener('submit', (event) => {
                event.preventDefault();

                const name = document.getElementById('name');
                const email = document.getElementById('email');
                const password = document.getElementById('password');

                if (!name.value.trim() || !email.value.trim() || !password.value.trim()) {
                    signupForm.classList.add('was-validated');
                    return;
                }

                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(email.value.trim())) {
                    email.classList.add('is-invalid');
                    return;
                } else {
                    email.classList.remove('is-invalid');
                }

                // Check for existing user
                const users = JSON.parse(localStorage.getItem('users')) || [];
                const userExists = users.some(user => user.email === email.value.trim());

                if (userExists) {
                    alert('This email is already registered.');
                } else {
                    users.push({ name: name.value.trim(), email: email.value.trim(), password: password.value.trim() });
                    localStorage.setItem('users', JSON.stringify(users));
                    alert('Sign-up successful! Redirecting to Sign-in page.');
                    window.location.href = 'signin.jsp';
                }
            });
        });
    </script>
</body>

</html>
