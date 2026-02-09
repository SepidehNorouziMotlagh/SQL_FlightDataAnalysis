--Q1 Find the busiest airport by the number of flights take off

SELECT TOP 1 a.Name , COUNT(*) AS TotalFlights
FROM Flights F JOIN Airports a
ON f.Origin=a.AirportID
GROUP BY a.Name
ORDER BY TotalFlights DESC

--Q2 Total number of tickets sold per airline

SELECT a.Name, COUNT(*) AS TotalTicketsSold
FROM Tickets t 
INNER JOIN Flights f ON t.FlightID = f.FlightID
INNER JOIN Airlines a ON f.AirlineID = a.AirlineID
GROUP BY a.Name
ORDER BY TotalTicketsSold DESC

--Q3 List all flights operated by 'IndiGo' with airport names (origin and destination)

SELECT f.FlightID, ap.Name AS OriginAirport, ap1.Name AS DestinationAirport
FROM Flights f
INNER JOIN Airlines a ON f.AirlineID = a.AirlineID
INNER JOIN Airports ap ON f.Origin = ap.AirportID
INNER JOIN Airports ap1 ON f.Destination = ap1.AirportID
WHERE a.Name = 'IndiGo'

--Q4 For each airport, show the top airline by number of flights departing from there

WITH CTE_FlightRank as (
SELECT *, RANK() OVER (PARTITION BY Origin ORDER BY FlightCount DESC) AS RankNum
FROM (
      SELECT f.Origin, f.AirlineID, COUNT(*) AS FlightCount
      FROM Flights f
      GROUP BY f.Origin, f.AirlineID ) t )
SELECT ap.Name as AirportName, al.Name as AirlineName, r.FlightCount
FROM CTE_FlightRank r
JOIN Airports ap ON r.Origin = ap.AirportID
JOIN Airlines al ON r.AirlineID = al.AirlineID
WHERE RankNum = 1

--Q5 For each flight, show time taken in hours and categorize it as Short (<2h), Medium (2-5h), or Long (>5h)

SELECT FlightID, DepartureTime, ArrivalTime,
DATEDIFF(MINUTE, DepartureTime, ArrivalTime) / 60 AS DurationHours,
CASE
WHEN DATEDIFF (MINUTE, DepartureTime, ArrivalTime) < 120 THEN 'Short'
WHEN DATEDIFF (MINUTE, DepartureTime, ArrivalTime) <= 300 THEN 'Medium'
ELSE 'Long'
END AS DurationCategory
FROM Flights

--Q6 Show each passenger's first and last flight dates and number of flights

WITH CTE_FlightsNo AS (
SELECT PassengerID,
MIN(F.DepartureTime) AS FirstFlight, MAX(F.DepartureTime) AS LastFlight,
COUNT(*) AS TotalFlights
FROM Tickets t
JOIN Flights F ON T.FlightID = F.FlightID
GROUP BY PassengerID)

SELECT p.Name, cte.FirstFlight, 
cte.LastFlight, cte.TotalFlights
FROM CTE_FlightsNo cte
JOIN Passengers P ON cte.PassengerID = P.PassengerID

--Q7 Find flights with the highest price ticket sold for each route (origin -> destination)

WITH CTE_TICKETS AS (
SELECT F.FlightID,
F.Origin, F.Destination,
T.TicketID, T.Price,
RANK() OVER (PARTITION BY F.Origin, F.Destination ORDER BY T.Price DESC) AS PriceRank
FROM Tickets T
JOIN FLIGHTS F ON T.FlightID = F.FlightID)

SELECT AP.Name AS Origin, AP1.Name AS Destination, 
TIC.TicketID, TIC.Price
FROM CTE_TICKETS TIC 
JOIN Airports AP ON TIC.Origin = AP.AirportID
JOIN Airports AP1 ON TIC.Destination = AP1.AirportID 
WHERE PriceRank = 1

--Q8 Find the highest spending passenger in each Frequent Flyer Status group

WITH CTE_SPENDING AS (
SELECT *, RANK() OVER (PARTITION BY FrequentFlyerStatus ORDER BY TotalSpent DESC) AS SpendingRank 
FROM (
SELECT P.PassengerID, P.Name,
P.FrequentFlyerStatus, SUM(T.Price) AS TotalSpent
FROM Passengers P
JOIN Tickets T
ON P.PassengerID = T.PassengerID
GROUP BY P.PassengerID, P.Name, P.FrequentFlyerStatus) t )

SELECT Name, FrequentFlyerStatus, TotalSpent
FROM CTE_SPENDING
WHERE SpendingRank = 1

--Q9 Find the total revenue and number of tickets sold for each airline and rank the airlines based on total revenue

WITH CTE_REVENUE AS (
SELECT A.AirlineID, A.Name AS AirlineName,
COUNT(T.TicketID) AS TicketsSoldNum,
SUM(T.Price) AS TotalRevenue
FROM Airlines A 
JOIN Flights F ON A.AirlineID = F.AirlineID
JOIN Tickets T ON F.FlightID = T.FlightID
GROUP BY A.AirlineID, A.Name )

SELECT AirlineID, AirlineName
TicketsSoldNum, TotalRevenue,
RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank
FROM CTE_REVENUE

--Q10 For each passeneger, identify their most frequently used airline. If a passenger has multiple airlines with the same highest usage show all suck airlines

WITH CTE_AIRLINERANK AS (
SELECT *, RANK() OVER (PARTITION BY PassengerID ORDER BY TicketsWithAirline) AS AirlinesUsedRank
FROM (
SELECT P.PassengerID, P.Name AS PassengerName, 
A.AirlineID, A.Name AS AirlineName,
COUNT(*) AS TicketsWithAirline
FROM Passengers P 
JOIN Tickets T ON P.PassengerID = T.PassengerID
JOIN Flights F ON T.FlightID = F.FlightID
JOIN Airlines A ON F.AirlineID = A.AirlineID
GROUP BY P.PassengerID, P.Name, A.AirlineID, A.Name) t )

SELECT PassengerID, PassengerName, AirlineID, AirlineName, TicketsWithAirline
FROM CTE_AIRLINERANK
WHERE AirlinesUsedRank = 1