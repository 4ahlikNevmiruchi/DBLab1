import java.sql.SQLException;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        System.out.println("Unit of Work");

        try (UnitOfWork uow = new UnitOfWork()) {

            BookingRepository repo = uow.getBookingRepository();

            // Отримання даних
            System.out.println("\nСписок активних бронювань:");
            List<Booking> list = repo.getAllActive();
            list.forEach(System.out::println);

            // Видалення
            if (!list.isEmpty()) {
                long idToDelete = list.get(0).getId();
                System.out.println("\nВидаляю бронювання #" + idToDelete + "...");

                // Видаляємо від імені адміна (ID=1)
                repo.softDelete(idToDelete, 1);
            }

            // Збереження змін
            uow.commit();
            System.out.println("Транзакція успішна!");

            // Перевірка
            System.out.println("\nСписок після видалення:");
            repo.getAllActive().forEach(System.out::println);

        } catch (SQLException e) {
            System.err.println("Помилка! Роблю відкат...");
            e.printStackTrace();
        }
    }
}
