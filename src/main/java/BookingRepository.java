import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingRepository {
    private Connection connection;

    public BookingRepository(Connection connection) {
        this.connection = connection;
    }

    public List<Booking> getAllActive() throws SQLException {
        List<Booking> bookings = new ArrayList<>();

        String sql = "SELECT b.id, u.email, b.total_price, b.created_at " +
                "FROM bookings b JOIN users u ON b.user_id = u.id " +
                "WHERE b.is_deleted = FALSE";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                bookings.add(new Booking(
                        rs.getLong("id"),
                        rs.getString("email"),
                        rs.getDouble("total_price"),
                        rs.getTimestamp("created_at")
                ));
            }
        }
        return bookings;
    }

    public void softDelete(long bookingId, int userId) throws SQLException {
        String sql = "CALL sp_soft_delete_booking(?, ?)";

        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setLong(1, bookingId);
            stmt.setInt(2, userId);
            stmt.execute();
            System.out.println("LOG: Викликано процедуру soft_delete для Booking #" + bookingId);
        }
    }
}