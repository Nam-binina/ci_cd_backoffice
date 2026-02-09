package com.nam.java;

import java.util.List;

@MyAnnotation(value = "/hotel", method = HttpMethod.CONTROLLER)
public class HotelController {

    @MyAnnotation(value = "/show", method = HttpMethod.GET)
    public ModelView showHotel() {
        ModelView mv = new ModelView();
        List<Hotel> hotels;
        try {
            hotels = new HotelRepository().findAll();
        } catch (Exception e) {
            String details = e.getMessage();
            if (e.getCause() != null && e.getCause().getMessage() != null) {
                details = details + " | Cause: " + e.getCause().getMessage();
            }
            mv.addItem("error", details);
            mv.setJspName("hotel");
            return mv;
        }
        Hotel hotel = (hotels == null || hotels.isEmpty()) ? null : hotels.get(0);
        mv.addItem("hotels", hotels);
        mv.setJspName("hotelList");
        return mv;
    }
    @MyAnnotation(value = "/form", method = HttpMethod.GET)
    public ModelView form() {
        System.out.println("Goodbye !");
        ModelView M = new ModelView();
        M.setJspName("post");
        return M;
    }
}
