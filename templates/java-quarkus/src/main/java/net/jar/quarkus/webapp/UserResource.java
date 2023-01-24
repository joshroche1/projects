package net.jar.quarkus.webapp;

import java.util.List;
import javax.annotation.security.RolesAllowed;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.SecurityContext;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import org.hibernate.Query;
import org.jboss.logging.Logger;
import io.quarkus.panache.common.Sort;
import io.quarkus.qute.CheckedTemplate;
import io.quarkus.qute.TemplateExtension;
import io.quarkus.qute.TemplateInstance;
import io.smallrye.common.annotation.Blocking;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;


@Path("users")
@ApplicationScoped
public class UserResource {

  private static final Logger LOGGER = Logger.getLogger(UserResource.class.getName());

  @CheckedTemplate
  static class Templates {
    static native TemplateInstance list(List<UserEntity> userlist);
  }
  
  @GET
  @Path("list")
  @RolesAllowed("user")
  @Produces(MediaType.TEXT_HTML)
  @Blocking
  public TemplateInstance list() {
    List<UserEntity> userlist = UserEntity.listAll(Sort.by("username"));
    return Templates.list(userlist);
  }
  
  @GET
  @Path("me")
  @RolesAllowed("user")
  @Produces(MediaType.TEXT_PLAIN)
  public String me(@Context SecurityContext securityContext) {
    return securityContext.getUserPrincipal().getName();
  }


  @Provider
  public static class ErrorMapper implements ExceptionMapper<Exception> {

    @Inject
    ObjectMapper objectMapper;

    @Override
    public Response toResponse(Exception exception) {
      LOGGER.error("Failed to handle request", exception);

      int code = 500;
      if (exception instanceof WebApplicationException) {
        code = ((WebApplicationException) exception).getResponse().getStatus();
      }

      ObjectNode exceptionJson = objectMapper.createObjectNode();
      exceptionJson.put("exceptionType", exception.getClass().getName());
      exceptionJson.put("code", code);

      if (exception.getMessage() != null) {
        exceptionJson.put("error", exception.getMessage());
      }

      return Response.status(code)
        .entity(exceptionJson)
        .build();
    }

  }
}
