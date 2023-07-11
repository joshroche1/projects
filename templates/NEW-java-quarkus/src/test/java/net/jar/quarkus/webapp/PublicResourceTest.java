package net.jar.quarkus.webapp;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;

@QuarkusTest
public class PublicResourceTest {

  @Test
  public void testHelloEndpoint() {
    given()
      .when().get("/hello")
      .then()
        .statusCode(200);
  }

}