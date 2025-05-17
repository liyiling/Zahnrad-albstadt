# Zahnrad-albstadt

## Hindergrund:
Beschreibung der Fertigungsdomäne der „Zahnrad AG“
“Zahnrad AG”齿轮股份公司的生产领域描述

Die Zahnrad AG stellt unterschiedliche Typen von Zahnrädern her. Jeder Typ hat eine interne Bezeichnung und unter anderem als Erkennungsmerkmal einen bestimmten Durchmesser.Die Zahnräder verkauft die Firma an verschiedene Kunden. Die Kunden ordern in der Regel nicht nur ein Zahnrad, sondern mehrere Zahnräder verschiedener Typen.
齿轮股份公司（Zahnrad AG）生产不同类型的齿轮。每种类型都有一个内部名称，并以某一特定直径等特征作为识别标志。公司将齿轮销售给不同的客户。客户通常不会只订购一个齿轮，而是订购多个不同类型的齿轮。
Zur Fertigung der Zahnräder hat die Zahnrad AG einen Maschinenpark. Die Maschinen sind unterschiedlich alt und von verschiedenen Herstellern. Dabei ist zu beachten, dass nicht jeder Zahnradtyp auf jeder Maschine hergestellt werden kann. 
为了生产这些齿轮，齿轮股份公司配备了一套机器设备。机器的使用年限不同，来自不同的制造商。需要注意的是，并非每种齿轮类型都能在每台机器上生产。

Auf Basis von Vergangenheitsdaten hat das Unternehmen für jeden Produkttyp festgelegt, wie lange die Produktion eines spezifischen Zahnrads dauern sollte. Nachdem ein Auftrag in den Produktionsablauf eingeplant worden ist, startet die Produktion. Durch Störungen oder zu viele Aufträge kann es passieren, dass ein geplantes Fertigstellungs-Datum für einen Auftrag nicht eingehalten werden kann. Außerdem ist es möglich, dass ein Zahnrad als Ausschuss deklariert wird (d.h. es muss noch einmal gefertigt werden).
基于历史数据，公司为每种产品类型设定了生产一个特定齿轮所需的标准时间。在某个订单被纳入生产流程后，生产即开始。但由于故障或订单过多的原因，计划的完成日期可能无法实现。此外，也有可能某个齿轮被判定为次品（即需要重新生产）。

Die Zahnrad AG möchte gerne auf Basis der gesammelten Daten bestimmte Kennzahlen berechnen. Es soll ermittelt werden, zu wie viel Prozent die einzelnen Maschinen in einem bestimmten Zeitraum ausgelastet sind. Auch ist von Interesse, welche Aufträge und wie viel Prozent der Aufträge innerhalb eines Zeitraums in der geplanten Zeit fertiggestellt wurden. Zur Feststellung, ob ein Auftrag planmäßig fertiggestellt wurde, sollen die realen Produktionsdaten berücksichtigt werden. Hierbei soll auch festgestellt werden, ob ein Auftrag komplett fertiggestellt wurde (unter Berücksichtigung der „richtig“ gefertigten Zahnräder).
齿轮股份公司希望基于收集的数据计算特定的关键绩效指标（Kennzahlen）。例如，要计算各台机器在某一特定时间段内的利用率百分比。同时，公司也关心在某一时间段内有哪些订单按时完成，以及有多少百分比的订单如期完成。为判断一个订单是否按计划完成，应考虑实际的生产数据。同时还要确定一个订单是否已完全完成（需考虑“正确”生产出来的齿轮数量）。

## Anforderungen an den Webservice 对 Web 服务的要求：

Der Auftraggeber stellt einen Beispiel-Code in Python zur Verfügung, welcher als Ausgangsbasis für die Erfüllung der folgenden Anforderungen genutzt werden soll:
委托方提供了一个用 Python 编写的示例代码，作为实现以下要求的基础：

Es ist eine RESTful API zu erstellen, mit welcher die einzelnen Datenbankabfragen durchgeführt werden können.
需要创建一个 RESTful API，通过该接口可以执行各项数据库查询操作。
• Dabei sollen GET-Endpoints zur Abfrage von Daten und POST-Endpoints zum Einfügen von Daten genutzt werden. 应使用 GET 端点 来查询数据，使用 POST 端点 来插入数据。
• Die API soll die Daten im JSON-Format annehmen und ausgeben. API 应以 JSON 格式 接收和返回数据。

Der Auftraggeber wünscht sich, dass bei der Kennzahlen-Berechnung für einen bestimmten Zeitraum berücksichtigt wird, dass die Fertigung schon vor dem Anfangszeitpunkt des betrachteten Zeitraums begonnen worden sein kann bzw. am Ende des betrachteten Zeitraums noch nicht fertiggestellt wurde. Die Daten sollen dahingehend bereinigt werden, sodass nur Produktionsdaten für den betrachteten Zeitraum berücksichtigt werden.
客户方希望，在某一时间段内进行关键指标计算时，要考虑生产可能在该时间段开始前就已启动，或者在该时间段结束后仍未完成。数据应相应地进行清洗，只纳入该时间段内的生产数据。

Das Unternehmen hat aktuell circa 20 Kunden sowie 10 verschiedene Produkte. Der Maschinenpark umfasst 15 Maschinen. Ein Auftrag umfasst i.d.R. maximal 200 Zahnräder. Im letzten Jahr hat das Unternehmen zwei Millionen Zahnräder hergestellt.
目前，公司大约有 20 个客户和 10 种不同的产品。设备园区共有 15 台机器。一个订单通常最多包含 200 个齿轮。去年，公司共生产了两百万个齿轮。
