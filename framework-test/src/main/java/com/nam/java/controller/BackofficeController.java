package com.nam.java.controller;

import com.nam.java.HttpMethod;
import com.nam.java.ModelView;
import com.nam.java.MyAnnotation;

@MyAnnotation(value = "/backoffice", method = HttpMethod.CONTROLLER)
public class BackofficeController {

    @MyAnnotation(value = "", method = HttpMethod.GET)
    public ModelView backoffice() {
        ModelView view = new ModelView();
        view.setJspName("backoffice");
        return view;
    }
}
