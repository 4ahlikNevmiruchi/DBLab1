import java.sql.Timestamp;

public class Booking {
    private long id;
    private String userEmail;
    private double totalPrice;
    private Timestamp createdAt;

    public Booking(long id, String userEmail, double totalPrice, Timestamp createdAt) {
        this.id = id;
        this.userEmail = userEmail;
        this.totalPrice = totalPrice;
        this.createdAt = createdAt;
    }


    public long getId() {
        return id;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    @Override
    public String toString() {
        return String.format("Booking #%d | User: %s | Price: %.2f | Date: %s",
                id, userEmail, totalPrice, createdAt);
    }
}
