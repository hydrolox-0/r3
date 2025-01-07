package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Board;
import model.Drawing;
import model.User;

public class DAO {
    
    // JDBC configuration
    private String jdbcURL = "jdbc:mysql://localhost:3306/whiteboarddb";
    private String jdbcUserName = "root";
    private String jdbcPassword = "hexabase";

    // SQL queries
    private static final String INSERT_USER_SQL = "INSERT INTO User (username, email, password) VALUES (?, ?, ?);";
    private static final String SELECT_USER_BY_ID = "SELECT * FROM User WHERE user_id = ?;";
    private static final String INSERT_BOARD_SQL = "INSERT INTO Board (name, creator_id, created_at) VALUES (?, ?, NOW());";
    private static final String SELECT_BOARD_BY_ID = "SELECT * FROM Board WHERE board_id = ?;";
    private static final String INSERT_DRAWING_SQL = "INSERT INTO Drawing (board_id, user_id, start_x, start_y, end_x, end_y, color, data, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW());";
    private static final String SELECT_DRAWINGS_BY_BOARD_ID = "SELECT * FROM Drawing WHERE board_id = ? ORDER BY created_at;";

    // Constructor
    public DAO() {}

    // Method to establish a connection
    public Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUserName, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    // ---------- User Operations ----------

    public boolean createUser(User user) {
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(INSERT_USER_SQL)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public User getUserById(int userId) {
        User user = null;
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SELECT_USER_BY_ID)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user = new User(rs.getString("username"), rs.getString("email"), rs.getString("password"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // ---------- Board Operations ----------

    public boolean createBoard(String name, int creatorId) {
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(INSERT_BOARD_SQL)) {
            stmt.setString(1, name);
            stmt.setInt(2, creatorId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Board getBoardById(int boardId) {
        Board board = null;
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SELECT_BOARD_BY_ID)) {
            stmt.setInt(1, boardId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                board = new Board(rs.getInt("board_id"), rs.getString("name"), rs.getTimestamp("created_at"), rs.getInt("creator_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return board;
    }

    // ---------- Drawing Operations ----------

    public boolean createDrawing(int boardId, int userId, float startX, float startY, float endX, float endY, String color, String data) {
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(INSERT_DRAWING_SQL)) {
            stmt.setInt(1, boardId);
            stmt.setInt(2, userId);
            stmt.setFloat(3, startX);
            stmt.setFloat(4, startY);
            stmt.setFloat(5, endX);
            stmt.setFloat(6, endY);
            stmt.setString(7, color);
            stmt.setString(8, data);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Drawing> getDrawingsByBoardId(int boardId) {
        List<Drawing> drawings = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SELECT_DRAWINGS_BY_BOARD_ID)) {
            stmt.setInt(1, boardId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Drawing drawing = new Drawing(
                        rs.getInt("drawing_id"),
                        rs.getInt("board_id"),
                        rs.getInt("user_id"),
                        rs.getFloat("start_x"),
                        rs.getFloat("start_y"),
                        rs.getFloat("end_x"),
                        rs.getFloat("end_y"),
                        rs.getString("color"),
                        rs.getString("data"),
                        rs.getTimestamp("created_at")
                );
                drawings.add(drawing);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return drawings;
    }
}
