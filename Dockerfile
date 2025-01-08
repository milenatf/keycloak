FROM quay.io/keycloak/keycloak:26.0.7

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]