package com.nam.java;

import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Iterator;
import java.util.Map;

public class MyGson {
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    public static String toJson(Map<String, Object> map) throws IllegalAccessException {
        return mapToJson(map);
    }

    private static String mapToJson(Map<String, Object> map) throws IllegalAccessException {
        StringBuilder builder = new StringBuilder("{");
        boolean first = true;
        if (map != null) {
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                if (!first) {
                    builder.append(",");
                }
                first = false;
                builder.append("\"").append(escapeJson(entry.getKey())).append("\":");
                builder.append(valueToJson(entry.getValue()));
            }
        }
        builder.append("}");
        return builder.toString();
    }

    private static String valueToJson(Object value) throws IllegalAccessException {
        if (value == null) {
            return "null";
        }
        if (value instanceof String) {
            return "\"" + escapeJson((String) value) + "\"";
        }
        if (value instanceof Character) {
            return "\"" + escapeJson(String.valueOf(value)) + "\"";
        }
        if (value instanceof Number || value instanceof Boolean) {
            return value.toString();
        }
        if (value instanceof LocalDateTime) {
            return "\"" + DATE_TIME_FORMATTER.format((LocalDateTime) value) + "\"";
        }
        if (value instanceof Map<?, ?>) {
            @SuppressWarnings("unchecked")
            Map<String, Object> mapValue = (Map<String, Object>) value;
            return mapToJson(mapValue);
        }
        if (value instanceof Iterable<?>) {
            return iterableToJson((Iterable<?>) value);
        }
        if (value.getClass().isArray()) {
            return arrayToJson(value);
        }
        return objectToJson(value);
    }

    private static String iterableToJson(Iterable<?> iterable) throws IllegalAccessException {
        StringBuilder builder = new StringBuilder("[");
        boolean first = true;
        Iterator<?> iterator = iterable.iterator();
        while (iterator.hasNext()) {
            if (!first) {
                builder.append(",");
            }
            first = false;
            builder.append(valueToJson(iterator.next()));
        }
        builder.append("]");
        return builder.toString();
    }

    private static String arrayToJson(Object array) throws IllegalAccessException {
        StringBuilder builder = new StringBuilder("[");
        int length = Array.getLength(array);
        for (int i = 0; i < length; i++) {
            if (i > 0) {
                builder.append(",");
            }
            builder.append(valueToJson(Array.get(array, i)));
        }
        builder.append("]");
        return builder.toString();
    }

    private static String objectToJson(Object value) throws IllegalAccessException {
        StringBuilder builder = new StringBuilder("{");
        Field[] fields = value.getClass().getDeclaredFields();
        boolean first = true;
        for (Field field : fields) {
            field.setAccessible(true);
            if (!first) {
                builder.append(",");
            }
            first = false;
            builder.append("\"").append(escapeJson(field.getName())).append("\":");
            builder.append(valueToJson(field.get(value)));
        }
        builder.append("}");
        return builder.toString();
    }

    private static String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
