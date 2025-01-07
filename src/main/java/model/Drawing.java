package model;

import java.sql.Timestamp;

public class Drawing {
    private int drawingId;
    private int boardId;
    private int userId;
    private float startX;
    private float startY;
    private float endX;
    private float endY;
    private String color;           // color in hex format
    private String data;            // additional drawing data
    private Timestamp createdAt;

    // Constructor
    public Drawing(int drawingId, int boardId, int userId, float startX, float startY, float endX, float endY, String color, String data, Timestamp createdAt) {
        this.drawingId = drawingId;
        this.boardId = boardId;
        this.userId = userId;
        this.startX = startX;
        this.startY = startY;
        this.endX = endX;
        this.endY = endY;
        this.color = color;
        this.data = data;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getDrawingId() {
        return drawingId;
    }

    public void setDrawingId(int drawingId) {
        this.drawingId = drawingId;
    }

    public int getBoardId() {
        return boardId;
    }

    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public float getStartX() {
        return startX;
    }

    public void setStartX(float startX) {
        this.startX = startX;
    }

    public float getStartY() {
        return startY;
    }

    public void setStartY(float startY) {
        this.startY = startY;
    }

    public float getEndX() {
        return endX;
    }

    public void setEndX(float endX) {
        this.endX = endX;
    }

    public float getEndY() {
        return endY;
    }

    public void setEndY(float endY) {
        this.endY = endY;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
