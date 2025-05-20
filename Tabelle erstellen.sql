-- Kunde Table 客户表
CREATE TABLE kunde (
  kundeid SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  adresse TEXT,
  kontaktdaten TEXT
);

-- Zahnradtyp Table 齿轮类型表
CREATE TABLE zahnradtyp (
  zahnradtypid SERIAL PRIMARY KEY,
  typbezeichnung TEXT NOT NULL,
  durchmesser float,
  vorgabeproduktionszeit INT
);


-- Maschinen Table 机器表
CREATE TABLE maschine (
  maschineid SERIAL PRIMARY KEY,
  hersteller TEXT,
  baujahr INT
);

-- 机器适配的齿轮类型（多对多）
CREATE TABLE maschinenfaehigkeit (
  maschineid INT REFERENCES maschine(maschineid),
  zahnradtypid INT REFERENCES zahnradtyp(zahnradtypid),
  PRIMARY KEY (maschineid, zahnradtypid)
);

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

