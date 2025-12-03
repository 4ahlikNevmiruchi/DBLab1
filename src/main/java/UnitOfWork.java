import java.sql.Connection;
import java.sql.SQLException;

public class UnitOfWork implements AutoCloseable {
    private Connection connection;
    private BookingRepository bookingRepository;

    public UnitOfWork() throws SQLException {
        this.connection = DatabaseConnection.getConnection();
        this.connection.setAutoCommit(false);
    }

    public BookingRepository getBookingRepository() {
        if (bookingRepository == null) {
            bookingRepository = new BookingRepository(connection);
        }
        return bookingRepository;
    }

    public void commit() throws SQLException {
        connection.commit();
    }

    public void rollback() {
        try {
            if (connection != null) {
                connection.rollback();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void close() throws SQLException {
        if (connection != null) {
            connection.close();
        }
    }
}
