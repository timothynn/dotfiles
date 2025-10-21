{ config, pkgs, ... }:

{
  # Data Science and Analytics Tools
  home.packages = with pkgs; [
    # R and RStudio for statistical computing
    R
    rstudio
    
    # Jupyter ecosystem
    jupyter
    
    # Apache tools for big data
    # apache-spark  # Commented - large package, install when needed
    
    # Data processing
    duckdb
    
    # Database tools
    sqlite
    sqlitebrowser
    
    # Graph visualization
    graphviz
    
    # Spreadsheet tools
    gnumeric
    
    # CSV/JSON processing
    miller
    
    # DVC (Data Version Control)
    dvc
    
    # Geographic information systems
    # qgis  # Commented - large package, install when needed
  ];

  # Environment variables for data science
  home.sessionVariables = {
    JUPYTER_CONFIG_DIR = "${config.home.homeDirectory}/.jupyter";
  };

  # Shell aliases for data work
  programs.zsh.shellAliases = {
    # Jupyter shortcuts
    jlab = "jupyter lab";
    jnb = "jupyter notebook";
    
    # Database shortcuts
    psql-local = "psql -U tim -h localhost";
    mysql-local = "mysql -u tim -h localhost";
    mongo-local = "mongosh";
    redis-cli-local = "redis-cli";
    
    # Data processing
    duck = "duckdb";
    
    # CSV/JSON tools
    jsonpp = "python -m json.tool";
  };
}
