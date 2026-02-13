package com.nam.java.controller;

import com.nam.java.HttpMethod;
import com.nam.java.ModelView;
import com.nam.java.MyAnnotation;
import com.nam.java.MyParam;
import com.nam.java.model.Carburant;
import com.nam.java.model.Vehicule;
import com.nam.java.repository.CarburantRepository;
import com.nam.java.repository.VehiculeRepository;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@MyAnnotation(value = "/vehicule", method = HttpMethod.CONTROLLER)
public class VehiculeController {

    @MyAnnotation(value = "/list", method = HttpMethod.GET)
    public ModelView list() {
        ModelView mv = new ModelView();
        List<Vehicule> vehicules = new VehiculeRepository().findAll();
        List<Carburant> carburants = new CarburantRepository().findAll();

        Map<Integer, String> carburantMap = new HashMap<>();
        for (Carburant carburant : carburants) {
            carburantMap.put(carburant.getIdCarburant(), carburant.getNom());
        }

        mv.addItem("vehicules", vehicules);
        mv.addItem("carburants", carburants);
        mv.addItem("carburantMap", carburantMap);
        mv.setJspName("vehiculeList");
        return mv;
    }

    @MyAnnotation(value = "/form", method = HttpMethod.GET)
    public ModelView form() {
        ModelView mv = new ModelView();
        List<Carburant> carburants = new CarburantRepository().findAll();
        mv.addItem("carburants", carburants);
        mv.setJspName("vehiculeForm");
        return mv;
    }

    @MyAnnotation(value = "/edit", method = HttpMethod.GET)
    public ModelView edit(@MyParam("id") int idVehicule) {
        ModelView mv = new ModelView();
        Vehicule vehicule = new VehiculeRepository().findById(idVehicule);
        List<Carburant> carburants = new CarburantRepository().findAll();

        if (vehicule == null) {
            ModelView listView = list();
            listView.addItem("error", "Véhicule introuvable");
            return listView;
        }

        mv.addItem("vehicule", vehicule);
        mv.addItem("carburants", carburants);
        mv.setJspName("vehiculeForm");
        return mv;
    }

    @MyAnnotation(value = "/insert", method = HttpMethod.POST)
    public ModelView insert(@MyParam("capacite") int capacite, @MyParam("idCarburant") int idCarburant) {
        if (capacite <= 0 || idCarburant <= 0) {
            ModelView mv = new ModelView();
            mv.addItem("error", "Capacité et carburant requis");
            mv.addItem("carburants", new CarburantRepository().findAll());
            mv.setJspName("vehiculeForm");
            return mv;
        }

        new VehiculeRepository().insert(new Vehicule(0, capacite, idCarburant));
        return list();
    }

    @MyAnnotation(value = "/update", method = HttpMethod.POST)
    public ModelView update(
            @MyParam("idVehicule") int idVehicule,
            @MyParam("capacite") int capacite,
            @MyParam("idCarburant") int idCarburant
    ) {
        if (idVehicule <= 0 || capacite <= 0 || idCarburant <= 0) {
            ModelView mv = new ModelView();
            mv.addItem("error", "Champs invalides");
            mv.addItem("carburants", new CarburantRepository().findAll());
            mv.setJspName("vehiculeForm");
            return mv;
        }

        new VehiculeRepository().update(new Vehicule(idVehicule, capacite, idCarburant));
        return list();
    }

    @MyAnnotation(value = "/delete", method = HttpMethod.GET)
    public ModelView delete(@MyParam("id") int idVehicule) {
        if (idVehicule > 0) {
            new VehiculeRepository().delete(idVehicule);
        }
        return list();
    }
}
