{ config, pkgs, ... }:

{
  # Data Science and Analytics Tools
  home.packages = with pkgs; [
    # R and RStudio for statistical computing
    R
    rstudio

    # Apache tools for big data
    # spark  # Commented - large package, install when needed

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

  # Shell aliases moved to centralized modules/common/aliases.nix
}
