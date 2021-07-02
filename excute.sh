#!/bin/sh
mvn clean install -DskipTests -Drelease=true && cd ./app-impl-play/ && sbt dist && unzip ./target/universal/porsche-app