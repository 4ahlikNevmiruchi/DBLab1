import com.mongodb.client.*;
import org.bson.Document;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BenchmarkApp {

    // PostgreSQL
    private static final String PG_URL = "jdbc:postgresql://localhost:5432/postgres";
    private static final String PG_USER = "postgres";
    private static final String PG_PASS = "1234"; // ПАРОЛЬ

    // MongoDB
    private static final String MONGO_URI = "mongodb://localhost:27017";

    public static void main(String[] args) {
        try {
            System.out.println("Міграція даних SQL -> NoSQL");
            migrateDataToMongo();

            System.out.println("\nТЕСТУВАННЯ ШВИДКОДІЇ 1000 читань");

            long startSql = System.nanoTime();
            for (int i = 0; i < 1000; i++) {
                readHotelComplexSQL(2);
            }
            long endSql = System.nanoTime();
            double timeSql = (endSql - startSql) / 1_000_000.0;
            System.out.printf("SQL (PostgreSQL Join): %.2f ms%n", timeSql);

            long startMongo = System.nanoTime();
            for (int i = 0; i < 1000; i++) {
                readHotelDocumentMongo(2);
            }
            long endMongo = System.nanoTime();
            double timeMongo = (endMongo - startMongo) / 1_000_000.0;
            System.out.printf("NoSQL (MongoDB Doc):   %.2f ms%n", timeMongo);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // запит з JOIN
    private static void readHotelComplexSQL(long hotelId) throws SQLException {
        String sql = "SELECT h.name, l.address_line, r.comment " +
                "FROM hotels h " +
                "JOIN locations l ON h.location_id = l.id " +
                "LEFT JOIN reviews r ON h.id = r.hotel_id " +
                "WHERE h.id = ?";

        try (Connection conn = DriverManager.getConnection(PG_URL, PG_USER, PG_PASS);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rs.getString("name");
                    rs.getString("address_line");
                }
            }
        }
    }

    // Простий пошук документу
    private static void readHotelDocumentMongo(long hotelId) {
        try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {
            MongoDatabase database = mongoClient.getDatabase("tourism_db");
            MongoCollection<Document> collection = database.getCollection("hotels_denormalized");

            // Миттєвий доступ по ID
            Document doc = collection.find(new Document("_id", hotelId)).first();
        }
    }

    // Створення документу в Mongo на основі даних
    private static void migrateDataToMongo() {
        try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {
            MongoDatabase database = mongoClient.getDatabase("tourism_db");
            MongoCollection<Document> collection = database.getCollection("hotels_denormalized");

            collection.deleteOne(new Document("_id", 2L));

            Document hotel = new Document("_id", 2L)
                    .append("name", "Rixos Premium Antalya")
                    .append("stars", 5)
                    .append("address", "Lara Beach, Antalya")
                    .append("reviews", List.of(
                            new Document("user", "tourist2").append("text", "Great pool!"),
                            new Document("user", "admin").append("text", "Excellent service")
                    ));

            collection.insertOne(hotel);
            System.out.println("-> Тестовий готель успішно створено в MongoDB.");
        }
    }
}
