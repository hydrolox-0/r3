package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/") // Mapping for the servlet
public class WhiteboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Constructor
    public WhiteboardController() {
        super();
    }

    // Handles GET requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher requestDispatcher;
        String action = request.getServletPath(); // Get the requested path

        switch (action) {
            case "/signup":
                // Forward to signup.jsp
                requestDispatcher = request.getRequestDispatcher("signup.jsp");
                requestDispatcher.forward(request, response);
                break;

            case "/signin":
                // Forward to signin.jsp
                requestDispatcher = request.getRequestDispatcher("signin.jsp");
                requestDispatcher.forward(request, response);
                break;

            case "/board":
                // Handle the root context
                requestDispatcher = request.getRequestDispatcher("index.jsp");
                requestDispatcher.forward(request, response);
                break;

            default:
                // Handle unknown paths
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page Not Found");
                break;
        }
    }

    // Handles POST requests
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Placeholder for POST logic
        response.getWriter().write("POST request handling is not implemented yet.");
    }
}
