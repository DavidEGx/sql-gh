-- Creación tablas
CREATE TABLE bodega (
  idbodega  integer primary key,
  nombre    text,
  localidad text
);

CREATE TABLE vino (
  idvino       integer primary key,
  denominacion text,
  año          text,
  tipo         text,
  precio       real,
  idbodega     int,
  constraint fk_vino_bode foreign key (idbodega) references bodega
);

-- Datos
INSERT INTO bodega VALUES
  (null, 'Bodegas Artuke', 'Baño de Ebro'),
  (null, 'Bodegas Bretón', 'Logroño'),
  (null, 'Bodegas Valenciso', 'Ollauri'),
  (null, 'Bodegas Ondalón', 'Oyón')
;

INSERT INTO vino VALUES
  (null, 'Valenciso I', 2009, 'Tinto', 12, 3),
  (null, 'Valenciso II', 2010, 'Tinto', 14, 3),
  (null, 'La Finca', 2011, 'Blanco', 15, 2),
  (null, 'Alba', 2004, 'Tinto', 18, 2),
  (null, '100 Abades', 2012, 'Tinto', 14, 4),
  (null, 'Ondalón', 2013, 'Blanco', 9, 4)
;
