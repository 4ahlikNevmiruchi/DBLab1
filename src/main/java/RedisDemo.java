import redis.clients.jedis.Jedis;

public class RedisDemo {
    public static void main(String[] args) {
        // Підключення
        try (Jedis jedis = new Jedis("localhost", 6379)) {

            // Запис
            jedis.set("top_tour", "Weekend in Lviv: -50%");
            System.out.println("Записано в Redis!");

            // Читання
            String value = jedis.get("top_tour");
            System.out.println("Прочитано з кешу: " + value);
        }
    }
}
