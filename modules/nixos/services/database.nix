{ config, pkgs, ... }:

{
  # Comprehensive database services for data engineering
  # Note: Start services manually with: sudo systemctl start <service>
  # Or enable permanently with: systemctl enable <service>

  # PostgreSQL - Primary relational database
  services.postgresql = {
    enable = false;  # Enable manually: sudo systemctl start postgresql
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    
    settings = {
      # Conservative settings for 7.4GB RAM laptop
      max_connections = 100;
      shared_buffers = "1GB";
      effective_cache_size = "3GB";
      maintenance_work_mem = "256MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "10MB";
      min_wal_size = "512MB";
      max_wal_size = "2GB";
    };
    
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    
    # Extensions for data work
    extraPlugins = with pkgs.postgresql16Packages; [
      pg_partman
      timescaledb
      postgis
    ];
    
    initialScript = pkgs.writeText "init.sql" ''
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
      CREATE EXTENSION IF NOT EXISTS "hstore";
      CREATE EXTENSION IF NOT EXISTS "pg_trgm";
    '';
  };

  # Redis - In-memory data store
  services.redis.servers."default" = {
    enable = false;  # Enable manually
    port = 6379;
    bind = "127.0.0.1";
    
    settings = {
      maxmemory = "512mb";  # Conservative for laptop
      maxmemory-policy = "allkeys-lru";
      save = [
        [900 1]
        [300 10]
        [60 10000]
      ];
    };
  };

  # MongoDB
  services.mongodb = {
    enable = false;  # Enable manually
    bind_ip = "127.0.0.1";
    dbpath = "/var/db/mongodb";
    enableAuth = false;
    
    extraConfig = ''
      storage:
        wiredTiger:
          engineConfig:
            cacheSizeGB: 1
    '';
  };

  # MySQL/MariaDB
  services.mysql = {
    enable = false;  # Enable manually
    package = pkgs.mariadb;
    
    settings = {
      mysqld = {
        max_connections = 100;
        innodb_buffer_pool_size = "512M";
        innodb_log_file_size = "128M";
        character_set_server = "utf8mb4";
        collation_server = "utf8mb4_unicode_ci";
      };
    };
  };

  # Note: Heavier services like Kafka, Elasticsearch, etc.
  # are available but not configured by default to save resources.
  # Install them via home-manager packages when needed for specific projects.
}
