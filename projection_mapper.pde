// Created by Grayson Earle for Integrated Media Systems Design
// CUNY City Tech
// Free for non-commercial use

import java.util.Map;

import deadpixel.keystone.*;

Keystone ks;

import processing.video.*;

ArrayList<Surface> surfaces = new ArrayList<Surface>();

int lastType = 0;
int syphonIndex = 0;

import codeanticode.syphon.*;

void setup() {
  fullScreen(P3D);

  ks = new Keystone(this);

  background(0);
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());

    synchronized(surfaces) {
      surfaces.add(new Surface(this, lastType, selection.getAbsolutePath()));
    }
  }
}

void draw() {
  background(0);
  synchronized(surfaces) {
    for (Surface s : surfaces) {
      s.update();
    }
  }
}

void keyPressed() {
  switch(key) {

  case '1':
    lastType = 1;
    selectInput("Select a file to process:", "fileSelected");
    break;

  case '2':
    lastType = 2;
    selectInput("Select a file to process:", "fileSelected");
    break;

  case '3':
    synchronized(surfaces) {
      surfaces.add(new Surface(this, 3, ""));
    }
    break;

  case '-':
    synchronized(surfaces) {
      if (surfaces.size() > 0)
        surfaces.remove(surfaces.size()-1);
    }
    break;

  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;
  }
}