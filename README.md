# 🛠️ Hinweise zur Deployment und Ausführung des Programms

## 📌 Schritt 1: Datenbanktabellen erstellen
Führen Sie bitte das SQL-Skript `Tabelle erstellen.sql` aus, um die erforderlichen Tabellen in Ihrer PostgreSQL-Datenbank zu erstellen.

## 📌 Schritt 2: Projekt öffnen
Öffnen Sie die folgenden Dateien in PyCharm oder Ihrer bevorzugten Entwicklungsumgebung:

- `app.py`
- `dbconnect.py`
- `index.html`

## 📌 Schritt 3: Datenbankverbindung anpassen
Bearbeiten Sie die Datei `dbconnect.py` entsprechend Ihrer lokalen Datenbankkonfiguration. Passen Sie die Parameter der `get_connection()`-Funktion wie folgt an:

```python
def get_connection():
    return psycopg2.connect(
        dbname="zahnrad_db",      # Ihr Datenbankname
        user="admin",             # Ihr Benutzername
        password="admin",         # Ihr Passwort
        host="127.0.0.1",         # Datenbankadresse (lokal)
        port="5432"               # Port (Standard bei PostgreSQL)
    )
```

# 👥 Aufgabenverteilung im Projektteam

### 🧑‍💼 Maurice Koppenhagen
- 📘 Beschreibung und Annahmen zum Entity-Relationship-Modell  
- 🗂️ Tabellenübersicht mit Attributen  
- 🧩 Visualisierung des Entity-Relationship-Modells  
- 🛠️ Definition der SQL-Abfragen  

**📂 Dateien:**
- `Tabelle erstellen.sql`  
- `Tabelle füllen.sql`  
- `abfragen.sql`

---

### 👩 Yiling Li
- 🖥️ Entwicklung des Webservices (RESTful API und Frontend)  
- 📝 Autorin des Abschnitts **5. Programm des Webservices** in der Projektdokumentation

---

### 👨 Mirza Ibadzade
- 💾 Berechnung des Speicherplatzbedarfs für 10 Jahre Produktionsdaten  
- 🔧 Vorschläge zur Erweiterung der Datenbankanwendung
