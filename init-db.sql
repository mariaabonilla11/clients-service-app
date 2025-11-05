WHENEVER SQLERROR EXIT SQL.SQLCODE;

CONNECT sys/123456 AS SYSDBA;

-- Crear PDB si no existe
DECLARE
  pdb_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO pdb_count FROM dba_pdbs WHERE pdb_name = 'FACTUMARKET_CLIENTS';
  IF pdb_count = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE PLUGGABLE DATABASE factumarket_clients
      ADMIN USER fmc_admin IDENTIFIED BY fmc_password
      FILE_NAME_CONVERT = (''/opt/oracle/oradata/XE/pdbseed/'', ''/opt/oracle/oradata/XE/factumarket_clients/'')
    ';
  END IF;
END;
/

-- Abrir PDB y guardar estado
ALTER PLUGGABLE DATABASE factumarket_clients OPEN;
ALTER PLUGGABLE DATABASE factumarket_clients SAVE STATE;

-- Entrar a la PDB
ALTER SESSION SET CONTAINER = factumarket_clients;

-- Crear tablespace dedicado para la app
CREATE TABLESPACE factumarket_data
  DATAFILE '/opt/oracle/oradata/XE/factumarket_clients/factumarket_data.dbf'
  SIZE 200M
  AUTOEXTEND ON
  NEXT 50M
  MAXSIZE UNLIMITED;

CONNECT system/123456@localhost:1521/factumarket_clients AS SYSDBA

-- Configurar usuario
ALTER USER fmc_admin DEFAULT TABLESPACE factumarket_data;
ALTER USER fmc_admin QUOTA UNLIMITED ON factumarket_data;

-- Asignar tablespace al usuario y cuota ilimitada
ALTER USER fmc_admin DEFAULT TABLESPACE factumarket_data QUOTA UNLIMITED ON factumarket_data;

-- Dar privilegios básicos
GRANT CONNECT, RESOURCE TO fmc_admin;

EXIT;
