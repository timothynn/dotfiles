{ config, pkgs, ... }:

{
  # Backend Development Tools
  home.packages = with pkgs; [
    # API Development & Testing
    postman
    insomnia
    bruno
    httpie
    xh
    curl
    
    # gRPC tools
    grpcurl
    evans
    
    # Load testing
    k6
    hey
    wrk
    
    # Reverse proxy
    nginx
    
    # Distributed tracing
    # jaeger  # Install when needed
    
    # Service discovery
    # consul  # Install when needed
    
    # Secret management
    sops
    age
    
    # Infrastructure as Code
    terraform
    ansible
    
    # Container tools
    buildah
    skopeo
    dive
    
    # Kubernetes tools
    kubectl
    kubectx  # Includes both kubectx and kubens
    k9s
    helm
    kustomize
    stern
    
    # Protocol buffers
    protobuf
    buf
    
    # Network debugging
    netcat
    nmap
    
    # DNS tools (using dog - modern dig alternative)
    dog  # Modern DNS lookup tool
    
    # TLS/SSL tools
    openssl
    mkcert
    
    # Benchmarking
    hyperfine
    
    # Container security scanning
    trivy
    
    # Documentation generators
    mkdocs
    
    # Backup tools
    restic
  ];

  # Docker compose template
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

  # Shell aliases for backend development
  programs.zsh.shellAliases = {
    # Docker shortcuts
    dps = "docker ps";
    dpa = "docker ps -a";
    di = "docker images";
    dex = "docker exec -it";
    dlog = "docker logs -f";
    
    # Kubernetes shortcuts
    k = "kubectl";
    kgp = "kubectl get pods";
    kgs = "kubectl get services";
    kgd = "kubectl get deployments";
    klog = "kubectl logs -f";
    kex = "kubectl exec -it";
    
    # Testing shortcuts
    curl-json = "curl -H 'Content-Type: application/json'";
    curl-post = "curl -X POST -H 'Content-Type: application/json'";
    
    # Process monitoring
    ports = "netstat -tulpn";
  };
}
