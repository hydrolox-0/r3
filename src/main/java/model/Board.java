package model;


import java.sql.Timestamp;

public class Board {
    private int boardId;
    private String name;
    private Timestamp createdAt;
    private int creatorId;

    // Constructor
    public Board(int boardId, String name, Timestamp createdAt, int creatorId) {
        this.boardId = boardId;
        this.name = name;
        this.createdAt = createdAt;
        this.creatorId = creatorId;
    }

    // Getters and Setters
    public int getBoardId() {
        return boardId;
    }

    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(int creatorId) {
        this.creatorId = creatorId;
    }
}

