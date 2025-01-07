package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dao.DAO;

@WebServlet("/signin")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DAO dao;

    @Override
    public void init() {
        this.dao = new DAO();
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/signin":
                    showSigninForm(request, response);
                    break;
                case "/signup":
                    showSignupForm(request, response);
                    break;
                case "/index":
                    showIndexPage(request, response);
                    break;
                default:
                    response.sendRedirect("signin");
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/signin":
                    processSignin(request, response);
                    break;
                case "/signup":
                    processSignup(request, response);
                    break;
                default:
                    response.sendRedirect("signin");
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    private void showSigninForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("signin.jsp");
        dispatcher.forward(request, response);
    }

    private void showSignupForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("signup.jsp");
        dispatcher.forward(request, response);
    }

    private void showIndexPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (isLoggedIn(request)) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect("signin");
        }
    }

    private void processSignin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection connection = dao.getConnection()) {
            PreparedStatement statement = connection.prepareStatement("SELECT * FROM users WHERE email = ? AND passwd = ?");
            statement.setString(1, email);
            statement.setString(2, password);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("status", "active");
                session.setAttribute("email", email);
                response.sendRedirect("index");
            } else {
                request.setAttribute("error", "Invalid email or password!");
                RequestDispatcher dispatcher = request.getRequestDispatcher("signin.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void processSignup(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User newUser = new User(name, email, password); // Assuming userId is auto-generated or not used during signup

        if (dao.createUser(newUser)) { // No changes needed here


        if (dao.createUser(newUser)) {
            response.sendRedirect("signin");
        } else {
            request.setAttribute("error", "Signup failed! Try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("signup.jsp");
            dispatcher.forward(request, response);
        }}
    }

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && "active".equals(session.getAttribute("status"));
    }
}
