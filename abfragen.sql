das sind die Abfragen der Datenbank : 

-- 1. Kundenname und Auftragsdatum
SELECT k.Name, a.Bestelldatum
FROM auftrag a
JOIN kunde k ON a.KundeID = k.KundeID;
 
-- 2. Zahnräder in einem Auftrag
SELECT ap.AuftragID, z.TypBezeichnung, ap.BestellteMenge
FROM auftrag_position ap
JOIN zahnradTyp z ON ap.ZahnradTypID = z.ZahnradTypID;
 
-- 3. Produktionsmaschine für ein Zahnrad
SELECT p.ProduktionID, m.Hersteller, z.TypBezeichnung
FROM produktion p
JOIN maschine m ON p.MaschineID = m.MaschineID
JOIN auftrag_position ap ON p.AuftragPositionID = ap.AuftragPositionID
JOIN zahnradTyp z ON ap.ZahnradTypID = z.ZahnradTypID;
 
-- 4. Auslastung pro Maschine (Anzahl Produktionen pro Maschine)
SELECT 
    m.MaschineID, 
    m.Hersteller, 
    COUNT(p.ProduktionID) AS Produktionen
FROM 
    maschine m
LEFT JOIN 
    produktion p ON m.MaschineID = p.MaschineID
GROUP BY 
    m.MaschineID, m.Hersteller
ORDER BY 
    Produktionen DESC;
 
-- 5. Durchschnittliche Produktionsdauer pro ZahnradTyp
SELECT z.TypBezeichnung, AVG(EXTRACT(EPOCH FROM (p.Endzeit - p.Startzeit))/60) AS Durchschnittszeit_min
FROM produktion p
JOIN auftrag_position ap ON p.AuftragPositionID = ap.AuftragPositionID
JOIN zahnradTyp z ON ap.ZahnradTypID = z.ZahnradTypID
WHERE p.Ausschuss = FALSE
GROUP BY z.TypBezeichnung;
