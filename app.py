import os
import traceback

import psycopg2
from flask import Flask, request, jsonify, send_from_directory,send_file
from dbconnect import get_connection
from flask_cors import CORS, cross_origin

#创建一个Flask对象
app = Flask(__name__)
CORS(app)
CORS(app, resources={
    r"/zahnrads*": {
        "origins": ["http://localhost:5000"],
        "methods": ["GET", "POST", "OPTIONS"],
        "allow_headers": ["Content-Type"]
    }
})

# 新增根路由
@app.route("/")
def serve_home():
    return send_file(os.path.join(os.path.dirname(__file__), "index.html"))

# GET: 查询所有 Zahnräder 产品
@app.route("/zahnrads", methods=["GET"])
@cross_origin()  # Add this decorator
def get_zahnrads():
    conn = None  # 初始化游标变量
    cur = None  # 初始化游标变量
    try:
        print("Attempting to connect to DB...")  # 添加调试点1
        conn = get_connection()
        print("Connection established.")  # 添加调试点2

        #创建一个数据库游标（cursor），用于执行 SQL 语句。
        # DictCursor 的作用是：让查询结果以 字典形式返回，字段名就是字典的 key，方便后续处理成 JSON。
        cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        print("Cursor created.")  # 添加调试点3

        #执行 SQL 查询语句，获取 zahnrads 表中所有的数据。
        cur.execute("SELECT * FROM zahnradTyp ORDER BY zahnradtypid ASC")
        print("Query executed.")  # 添加调试点4

        #获取查询的所有结果，并保存在 rows 中。每一行是一个字典（因为用了 DictCursor）。
        rows = cur.fetchall()
        print("Fetched rows:", rows) # 添加调试点5

        #确保得出来的结果是列表+字典结构，方便jsonify()转换成JSON
        result = [dict(row) for row in rows]

        # 输出调试信息，确保结果是列表
        print("Fetched rows:", result) # 添加调试点6

        #将 Python 列表对象转换成 JSON 格式，并作为 HTTP 响应返回给客户端
        return jsonify(result)
    #捕获异常 e，将错误信息以 JSON 格式返回，并设置 HTTP 状态码为 500（服务器内部错误）。
    except Exception as e:
        print("Error occurred:")
        traceback.print_exc()  # 打印完整异常堆栈
        return jsonify({"error": str(e)}), 500
    finally:
        # 只有在 cur 和 conn 成功创建后才进行关闭操作
        if cur:
            cur.close()
        if conn:
            conn.close()

# POST: 插入一个新 Zahnrads 产品
@app.route("/zahnrads", methods=["POST"])
def create_zahnrad():
    data = request.json
    try:
        typ = data["typbezeichnung"]
        durchmesser = float(data["durchmesser"])
        vorgabeproduktionszeit= int(data["vorgabeproduktionszeit"])

        conn = get_connection()
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO zahnradTyp (typbezeichnung, durchmesser,vorgabeproduktionszeit) VALUES (%s, %s,%s)",
            (typ, durchmesser,vorgabeproduktionszeit)
        )
        conn.commit()
        return jsonify({"message": "Zahnrad inserted successfully!"}), 201
    except Exception as e:
        print("Received data:", data)
        print("Exception:", e)
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()
        conn.close()

# GET: 获取所有 Kunden（客户）用于前端下拉选择
@app.route("/kunden", methods=["GET"])
@cross_origin()
def get_kunden():
    conn = None
    cur = None
    try:
        conn = get_connection()
        cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute("SELECT kundeid, name FROM kunde")  # 假设你有 name 字段
        rows = cur.fetchall()
        result = [dict(row) for row in rows]
        return jsonify(result)
    except Exception as e:
        print("Error in get_kunden:", e)
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500
    finally:
        if cur: cur.close()
        if conn: conn.close()

# POST: 创建新订单及其订单项
@app.route("/orders", methods=["POST"])
def create_order():
    data = request.json
    conn = None
    cur = None
    try:
        kunde_id = data["kundeid"]
        if not isinstance(kunde_id, int):
            return jsonify({"error": "kundeid 必须为整数"}), 400

        bestelldatum = data["bestelldatum"]
        # geplantes_fertig = data.get("geplantesfertigstellungsdatum")
        items = data["items"]  # 列表：每项为 {zahnradtypid, menge}

        conn = get_connection()
        cur = conn.cursor()

        # 插入订单
        #print(kunde_id, type(kunde_id))
        print(bestelldatum, type(bestelldatum))

        #获取auftragid
        cur.execute(
            "INSERT INTO auftrag (kundeid, bestelldatum) "
            "VALUES (%s, %s) RETURNING auftragid",
            (kunde_id, bestelldatum)
        )
        auftragid = cur.fetchone()[0]


        # 插入每个订单项
        for item in items:
            zahnradtypid = item["zahnradtypid"]
            menge = item["menge"]

            # 获取每个zahnradTyp的生产时间，用于估算生产总时间
            cur.execute("SELECT vorgabeproduktionszeit FROM zahnradtyp WHERE zahnradtypid = %s", (zahnradtypid,))
            result = cur.fetchone()
            if not result:
                raise ValueError(f"ZahnradTypID {zahnradtypid} 不存在")
            einzelzeit = result[0]
            geplante_dauer = float(einzelzeit) * int(menge)

            cur.execute(
                "INSERT INTO auftrag_position (auftragid,zahnradtypid, bestelltemenge, geplanteproduktionsdauer) "
                "VALUES (%s, %s, %s, %s)",
                (auftragid,zahnradtypid, menge, geplante_dauer)
            )

        conn.commit()
        return jsonify({"message": "Auftrag created successfully!"}), 201

    except Exception as e:
        print("Error while creating order:", e)
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500
    finally:
        if cur: cur.close()
        if conn: conn.close()

@app.route("/orders", methods=["GET"])
def get_orders():
    conn = get_connection()
    cur = conn.cursor()

    # 获取所有订单和客户名称
    cur.execute("""
        SELECT a.auftragid, a.kundeid, k.name, a.bestelldatum
        FROM auftrag a
        JOIN kunde k ON a.kundeid = k.kundeid
    """)
    auftraege = cur.fetchall()

    result = []
    for auftrag in auftraege:
        auftragid, kundeid, kundenname, bestelldatum = auftrag

        # 获取该订单的所有订单项
        cur.execute("""
            SELECT zahnradtypid, bestelltemenge
            FROM auftrag_position
            WHERE auftragid = %s
        """, (auftragid,))
        items = cur.fetchall()

        items_list = [{"zahnradtypid": item[0], "menge": item[1]} for item in items]

        result.append({
            "auftragid": auftragid,
            "kunde": kundenname,
            "bestelldatum": bestelldatum.strftime("%Y-%m-%d"),
            "items": items_list
        })

    cur.close()
    conn.close()

    return jsonify(result)

if __name__ == "__main__":
    app.run(debug=True, use_reloader=True)
