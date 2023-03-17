package net.jar.quarkus.webapp;

import javax.enterprise.event.Observes;
import javax.inject.Singleton;
import javax.transaction.Transactional;
import org.jboss.logging.Logger;
import io.quarkus.runtime.StartupEvent;

@Singleton
public class Startup {
  
  private static final Logger LOGGER = Logger.getLogger(PublicResource.class.getName());
  
  @Transactional
  public void loadDefaults(@Observes StartupEvent evt) {
    // Init objects    
    UserEntity.add("admin", "admin", "user", "admin@admin.adm");
    LOGGER.info("Added user entity");
  }
}