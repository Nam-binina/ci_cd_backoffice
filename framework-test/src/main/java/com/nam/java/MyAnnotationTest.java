// package com.nam.java;

// import java.lang.reflect.Method;

// import java.lang.reflect.Field;

// public class MyAnnotationTest {

//     @MyAnnotation(value =  "/TEST",method = HttpMethod.CONTROLLER)
//     public void fun() {
//     }

//     @SuppressWarnings("unchecked")
//     public static void printAnno(@SuppressWarnings("rawtypes") Class C) {
//         System.out.println("Class");
//         if (C.isAnnotationPresent(MyAnnotation.class)) {
//             MyAnnotation mA = (MyAnnotation) C.getAnnotation(MyAnnotation.class);
//             System.out.println(mA.value());
//         }
//         System.out.println("\nField");
//         for (Field F : C.getDeclaredFields()) {
//             if (F.isAnnotationPresent(MyAnnotation.class)) {
//                 MyAnnotation mA = F.getAnnotation(MyAnnotation.class);
//                 System.out.println(mA.value());
//             }
//         }
//         System.out.println("\nMethod");
//         for (Method m : C.getMethods()) {
//             if (m.isAnnotationPresent(MyAnnotation.class)) {
//                 MyAnnotation mA = m.getAnnotation(MyAnnotation.class);
//                 System.out.println(mA.value());
//             }
//         }
//     }

//     public static void main(String[] args) throws Exception {
//         printAnno(MyAnnotationTest.class);
//     }
// }