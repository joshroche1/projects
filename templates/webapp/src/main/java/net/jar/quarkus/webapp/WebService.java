package net.jar.quarkus.webapp;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.POST;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.quarkus.qute.CheckedTemplate;
import io.quarkus.qute.TemplateExtension;
import io.quarkus.qute.TemplateInstance;

@Path("/")
public class WebService {

  @CheckedTemplate
  static class Templates {
    static native TemplateInstance index();
  }

  @GET
  @Path("/")
  @Produces(MediaType.TEXT_HTML)
  public TemplateInstance get() {
    return Templates.index();
  }

}
