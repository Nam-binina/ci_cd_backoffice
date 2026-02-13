package com.nam.java.controller;

import com.nam.java.HttpMethod;
import com.nam.java.ModelView;
import com.nam.java.MyAnnotation;
import com.nam.java.model.Hotel;
import com.nam.java.repository.HotelRepository;
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
        mv.addItem("hotels", hotels);
        mv.setJspName("hotelList");
        return mv;
    }

    @MyAnnotation(value = "/form", method = HttpMethod.GET)
    public ModelView form() {
        ModelView view = new ModelView();
        view.setJspName("post");
        return view;
    }
}
