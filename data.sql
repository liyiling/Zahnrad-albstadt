-- Kunde Table 客户表
CREATE TABLE kunde (
  kundeid SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  adresse TEXT,
  kontaktdaten TEXT
);
INSERT INTO kunde (KundeID, Name, Adresse, Kontaktdaten) VALUES
(1, 'Alpha GmbH', 'Musterstraße 1, Berlin', 'alpha@example.com'),
(2, 'Beta AG', 'Industrieweg 3, Hamburg', 'beta@example.com'),
(3, 'Gamma Co.', 'Techpark 12, München', 'gamma@example.com'),
(4, 'Delta KG', 'Bauhof 5, Köln', 'delta@example.com'),
(5, 'Epsilon SE', 'Werkstraße 7, Frankfurt', 'epsilon@example.com'),
(6, 'Zeta Ltd.', 'Fabrikallee 8, Leipzig', 'zeta@example.com'),
(7, 'Eta GmbH', 'Handelsweg 22, Stuttgart', 'eta@example.com'),
(8, 'Theta Inc.', 'Innovationspark 4, Düsseldorf', 'theta@example.com'),
(9, 'Iota OHG', 'Maschinenring 9, Bremen', 'iota@example.com'),
(10, 'Kappa e.K.', 'Lagerplatz 6, Dresden', 'kappa@example.com');


-- Zahnradtyp Table 齿轮类型表
CREATE TABLE zahnradtyp (
  zahnradtypid SERIAL PRIMARY KEY,
  typbezeichnung TEXT NOT NULL,
  durchmesser float,
  vorgabeproduktionszeit INT
);
INSERT INTO zahnradTyp (typbezeichnung, durchmesser, vorgabeproduktionszeit) VALUES
('Stirnrad', 25, 500),
('Schrägverzahntes Zahnrad', 40, 75),
('Kegelrad', 30, 90),
('Spiralkegelrad', 35, 100),
('Zahnstange und Ritzel', 23, 45),
('Planetengetriebe', 20, 120),
('Innenzahnrad', 50, 80),
('Schneckenrad', 45, 110),
('Doppeltverzahntes Zahnrad', 60, 95),
('Kettenrad', 38, 70),
('Z-100', 10.5, 12),
('Z-110', 12, 15),
('Z-120', 15, 18),
('Z-130', 20, 20),
('Z-140', 25.5, 25),
('Z-150', 30, 30),
('Z-160', 35.5, 32),
('Z-170', 40, 35),
('Z-180', 45, 38),
('Z-190', 50, 40);


-- Maschinen Table 机器表
CREATE TABLE maschine (
  maschineid SERIAL PRIMARY KEY,
  hersteller TEXT,
  baujahr INT
);
INSERT INTO maschine (hersteller, baujahr) VALUES
('Siemens', 2015),
('Bosch', 2016),
('GE', 2014),
('KUKA', 2017),
('Fanuc', 2018),
('ABB', 2013),
('Trumpf', 2019),
('DMG Mori', 2020),
('Heidenhain', 2021),
('Schuler', 2022);


-- 机器适配的齿轮类型（多对多）
CREATE TABLE maschinenfaehigkeit (
  maschineid INT REFERENCES maschine(maschineid),
  zahnradtypid INT REFERENCES zahnradtyp(zahnradtypid),
  PRIMARY KEY (maschineid, zahnradtypid)
);
INSERT INTO maschinenfaehigkeit (maschineid, zahnradtypid) VALUES
(1, 1),(1, 2),(1, 3),(2, 3),(2, 4),(2, 5),(3, 1),(3, 6),(3, 7),(4, 2),(4, 5),
(4, 6),(5, 4),(5, 5),(5, 8),(6, 6),(6, 9),(6, 10),(7, 7),(7, 8),
(7, 9),(8, 8),(8, 9),(8, 10),(9, 10),(9, 1),(9, 2),(10, 3),(10, 4),(10, 5);


-- 订单表
CREATE TABLE auftrag (
  auftragid SERIAL PRIMARY KEY,
  kundeid INT REFERENCES kunde(kundeid),
  bestelldatum DATE,
  geplantesfertigstellungsdatum DATE,
  tatsaechlichesfertigstellungsdatum DATE
);

-- 订单项（一个订单多个齿轮类型）
CREATE TABLE auftrag_position (
  auftragpositionid SERIAL PRIMARY KEY,
  auftragid INT REFERENCES auftrag(auftragid),
  zahnradtypid INT REFERENCES zahnradtyp(zahnradtypid),
  bestelltemenge INT,
  geplanteproduktionsdauer INT
);

-- 生产表（某项订单在某台机器上的生产记录）
CREATE TABLE produktion (
  produktionid SERIAL PRIMARY KEY,
  auftragpositionid INT REFERENCES auftrag_position(auftragpositionid),
  maschineid INT REFERENCES maschine(maschineid),
  startzeit TIMESTAMP,
  endzeit TIMESTAMP,
  ausschuss BOOLEAN
);

INSERT INTO produktion (ProduktionID, AuftragPositionID, MaschineID, Startzeit, Endzeit, Ausschuss) VALUES
(1, 1, 1, '2024-05-02 08:00', '2024-05-02 08:15', FALSE),
(2, 1, 1, '2024-05-02 08:20', '2024-05-02 08:35', FALSE),
(3, 2, 2, '2024-05-03 09:00', '2024-05-03 09:20', FALSE),
(4, 3, 3, '2024-05-04 10:00', '2024-05-04 10:25', TRUE),
(5, 4, 4, '2024-05-05 07:30', '2024-05-05 07:45', FALSE),
(6, 5, 5, '2024-05-06 08:00', '2024-05-06 08:30', FALSE),
(7, 6, 6, '2024-05-07 08:45', '2024-05-07 09:15', FALSE),
(8, 7, 7, '2024-05-08 10:00', '2024-05-08 10:45', TRUE),
(9, 8, 8, '2024-05-09 11:00', '2024-05-09 11:50', FALSE),
(10, 8, 9, '2024-05-10 12:00', '2024-05-10 12:55', FALSE);
