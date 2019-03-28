
final int isIMAGE = 1;
final int isMOVIE = 2;
final int isSYPHON = 3;

class Surface {

  int type;

  PApplet app;

  CornerPinSurface surface;
  PGraphics offscreen;
  Movie movie;
  boolean fileReady = false;

  PImage img;

  SyphonClient client;

  Surface(PApplet papp, int type, String path) {

    app = papp;

    this.type = type;

    switch(type) {

    case isIMAGE:
      img = loadImage(path);
      break;

    case isMOVIE:
      // is movie
      movie = new Movie(app, path);
      movie.loop();
      break;

    case isSYPHON:
      
      println(SyphonClient.listServers());
      
      String servName = SyphonClient.listServers()[syphonIndex].toString();
      servName = servName.substring(servName.indexOf("=")+1, servName.indexOf(","));
      println(servName);

      //client = new SyphonClient(app);
      client = new SyphonClient(app, "", servName);
      
      syphonIndex++;
      if(syphonIndex >= SyphonClient.listServers().length) {
        syphonIndex = 0;
      }
      break;
    }
  }



  void update() {

    // hacky but works. the deal is that you need to wait a bit before movie.width gets a value
    switch(type) {

    case isIMAGE:
      if (img.width > 0 && !fileReady) {
        // file is ready now, read width etc
        // create the surface and buffer to match
        surface = ks.createCornerPinSurface(img.width, img.height, 10);
        offscreen = createGraphics(img.width, img.height, P3D);

        fileReady = true;
      }

      if (fileReady) {
        offscreen.beginDraw();
        offscreen.image(img, 0, 0);
        offscreen.endDraw();
        surface.render(offscreen);
      }
      break;

    case isMOVIE:
      if (movie != null && offscreen != null && movie.available() == true) {
        movie.read(); 
        offscreen.beginDraw();
        offscreen.image(movie, 0, 0);
        offscreen.endDraw();
      } else {

        // see if the movie is ready yet
        if (!fileReady) {
          movie.read(); 

          // finally ready?
          if (movie.width > 0) {

            fileReady = true;

            // create the surface and buffer to match
            surface = ks.createCornerPinSurface(movie.width, movie.height, 10);
            offscreen = createGraphics(movie.width, movie.height, P3D);
          }
        }
      }


      if (fileReady) {
        surface.render(offscreen);
      }
      break;

    case isSYPHON:
      if (client.newFrame()) {

        if (!fileReady && client.getGraphics(offscreen).width > 0) {
          fileReady = true;

          surface = ks.createCornerPinSurface(client.getGraphics(offscreen).width, client.getGraphics(offscreen).height, 10);
          offscreen = createGraphics(client.getGraphics(offscreen).width, client.getGraphics(offscreen).height, P3D);
        }
      }

      if (fileReady) {
        offscreen = client.getGraphics(offscreen);
        surface.render(offscreen);
      }

      break;
    }
  }
}