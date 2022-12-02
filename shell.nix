{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  packages = [ pkgs.postgresql pkgs.docker pkgs.docker-compose ];

    PGHOST = "localhost";
    PGPORT = "5432";
    PGDATABASE = "aoc";
    PGUSER = "aoc";
    PGPASSWORD = "aoc";
    DATABASE_URL = "postgresql://(PGUSER):(PGPASSWORD)@(PGHOST):(PGPORT)/(PGDATABASE)?sslmode=disable";

    shellHook = ''
        docker-compose up -d
      '';
}
