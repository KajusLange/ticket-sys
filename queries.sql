-- Erstellen eines neuen Tickets inkl. Fehler --
	-- Fehler einfügen --
INSERT INTO tbl_fehler
(fehler_id, typ, beschreibung, betroffeneEinrichtung)
VALUES (1024, "hardware", "explodiert", "drucker");
	-- Ticket einfügen --
INSERT INTO tbl_ticket
(ticket_id, raum, status, fehler_id, einsteller, bearbeiter, datum_erstellt, datum_geschlossen)
VALUES (2048, "B15", 1024, "Taylor, Phillip", NULL, datetime("now", "localtime"), NULL);

-- Ticketstatus ändern --
	-- Ticket in Bearbeitung setzen --
UPDATE tbl_ticket
SET	status = "in Bearbeitung",
	bearbeiter = "Nash, Ricardo"
WHERE fehler_id = 1024;
	-- Ticket schließen --
UPDATE tbl_ticket
SET status = "behoben"
	datum_geschlossen = datetime("now", "localtime")
WHERE fehler_id = 1024;

-- Übersicht der aktuellen Tickets --
	-- Ältesten 50 offene Tickets --
SELECT ticket_id, tbl_fehler.fehler_id, raum, status, einsteller, datum_erstellt, typ, betroffeneEinrichtung, beschreibung
FROM tbl_ticket
	INNER JOIN ON tbl_ticket.fehler_id = tbl_fehler.fehler_id
WHERE tbl_ticket.status = "erstellt"
ORDER BY datum_erstellt ASC
LIMIT 50;
	-- Ältesten 50 Tickets in Bearbeitung --
SELECT ticket_id, tbl_fehler.fehler_id, raum, status, einsteller, bearbeiter, datum_erstellt, typ, betroffeneEinrichtung, beschreibung)
FROM tbl_ticket
	INNER JOIN ON tbl_ticket.fehler_id = tbl_fehler.fehler_id
WHERE tbl_ticket.status = "in Bearbeitung"
ORDER BY datum_erstellt ASC
LIMIT 50;
	-- Ältesten 50 behobenen Tickets
SELECT ticket_id, tbl_fehler.fehler_id, raum, status, einsteller, bearbeiter, datum_erstellt, datum_geschlossen, typ, betroffeneEinrichtung, beschreibung)
FROM tbl_ticket
	INNER JOIN on tbl_ticket.fehler_id = tbl_fehler.fehler_id
WHERE tbl_ticket.status = "behoben"
ORDER BY datum_erstellt ASC
LIMIT 50;

-- Fehlerauswertung eines Raums --
    -- Alle Fehler eines Raums (Raum: B18) --
SELECT t.ticket_id, t.raum, t.status, f.typ, f.beschreibung, f.betroffeneEinrichtung
FROM tbl_ticket AS t
    INNER JOIN tbl_fehler AS f ON t.fehler_id = f.fehler_id
WHERE t.raum = "B18"

    -- Verteilung der Fehlertypen (Software, Hardware) eines Raums (Raum: B18) --
SELECT t.raum, f.typ, COUNT(f.typ) AS Anzahl
FROM tbl_ticket AS t
    INNER JOIN tbl_fehler AS f ON t.fehler_id = f.fehler_id
WHERE t.raum = "B18"
GROUP BY f.typ
ORDER BY Anzahl DESC

    -- Verteilung der Softwarefehler in einem Raum (Raum: B18) --
SELECT t.raum, f.typ, f.beschreibung, COUNT(beschreibung) AS Anzahl
FROM tbl_ticket AS t
    INNER JOIN tbl_fehler AS f on t.fehler_id = f.fehler_id
WHERE t.raum = "B18" AND f.typ = "software"
GROUP BY beschreibung
ORDER BY Anzahl DESC

    -- Verteilung der Hardwarefehler in einem Raum (Raum: B18) --
SELECT t.raum, f.typ, f.beschreibung, COUNT(beschreibung) AS Anzahl
FROM tbl_ticket AS t
    INNER JOIN tbl_fehler AS f on t.fehler_id = f.fehler_id
WHERE t.raum = "B18" AND f.typ = "hardware"
GROUP BY beschreibung
ORDER BY Anzahl DESC