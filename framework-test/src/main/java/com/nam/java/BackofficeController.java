package com.nam.java;

import java.util.HashMap;
import java.util.Map;

@MyAnnotation(value = "/backoffice", method = HttpMethod.CONTROLLER)
public class BackofficeController {

    @MyAnnotation(value = "/", method = HttpMethod.GET)
    public ModelView backoffice() {
        ModelView view = new ModelView();
        view.setJspName("backoffice");
        return view;
    }
}
