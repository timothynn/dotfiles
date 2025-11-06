{ config, pkgs, ... }:

{
  # Docker Compose Development Stack Template
  home.file.".config/docker-compose/dev-stack.yml".text = ''
    version: '3.8'

    services:
      postgres:
        image: postgres:16
        environment:
          POSTGRES_USER: tim
          POSTGRES_PASSWORD: postgres
        ports:
          - "5432:5432"
        volumes:
          - postgres-data:/var/lib/postgresql/data
      
      redis:
        image: redis:7-alpine
        ports:
          - "6379:6379"
      
      mongodb:
        image: mongo:7
        ports:
          - "27017:27017"
        volumes:
          - mongo-data:/data/db

    volumes:
      postgres-data:
      mongo-data:
  '';
}
