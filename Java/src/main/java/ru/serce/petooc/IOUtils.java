package ru.serce.petooc;

import java.io.IOException;
import java.io.InputStream;

/**
 * @author Sergey Tselovalnikov
 * @since 14.12.14
 */
public class IOUtils {
    public static String toString(InputStream is) {
        try {
            StringBuilder builder = new StringBuilder();
            int ch;
            while ((ch = is.read()) != -1) {
                builder.append((char) ch);
            }
            return builder.toString();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private IOUtils() {}
}
