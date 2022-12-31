FROM ubuntu:20.04
RUN apt update && apt install -y openjdk-17-jre
COPY build/libs/calculator-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]