# SQL_FlightDataAnalysis
Here is a professional, ready-to-use README.md file for your GitHub repository.

I have structured it to highlight your skills (CTEs, Window Functions, Joins) and clearly explain the project to anyone visiting your profile.

✈️ Flight Operations & Passenger Analysis SQL Project

![alt text](https://img.shields.io/badge/Database-SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server)


![alt text](https://img.shields.io/badge/Status-Complete-green?style=for-the-badge)

📄 Project Overview

This project involves the design and analysis of a relational database for an Airline Management System. It simulates a real-world scenario containing data for airports, airlines, flights, passengers, and ticketing.

The goal of this project is to demonstrate Advanced SQL skills including schema design, data normalization, and complex querying using Window Functions, CTEs (Common Table Expressions), and Aggregations.

📊 Database Schema

The database consists of 5 related tables:

Airports: Stores airport details (ID, Name, Location, Country).

Airlines: Stores airline carrier information.

Passengers: Stores passenger profiles and frequent flyer status.

Flights: Contains flight schedules, linking Airlines and Airports.

Tickets: Transactional data linking Passengers to Flights with pricing.

Entity Relationship Diagram (ERD)
code
Mermaid
download
content_copy
expand_less
erDiagram
    AIRPORTS ||--o{ FLIGHTS : "origin/destination"
    AIRLINES ||--o{ FLIGHTS : "operates"
    PASSENGERS ||--o{ TICKETS : "purchases"
    FLIGHTS ||--o{ TICKETS : "assigned_to"

    AIRPORTS {
        int AirportID PK
        string Name
        string Location
        string Country
    }
    FLIGHTS {
        int FlightID PK
        int Origin FK
        int Destination FK
        datetime DepartureTime
        datetime ArrivalTime
        int AirlineID FK
    }
    TICKETS {
        int TicketID PK
        int PassengerID FK
        int FlightID FK
        decimal Price
    }
🧠 Key SQL Concepts Demonstrated

This project utilizes Microsoft SQL Server (T-SQL) syntax and highlights the following capabilities:

DDL (Data Definition Language): Creating tables with Primary Keys and Foreign Key constraints to ensure data integrity.

Joins: Inner and Self joins to combine data across 5 tables.

Window Functions: Using RANK() and ROW_NUMBER() (implied) to solve "Top N" problems per group.

CTEs (Common Table Expressions): improving readability for multi-step complex logic.

Date Functions: Using DATEDIFF to calculate flight durations.

CASE Statements: Categorizing flights into Short, Medium, and Long-haul.

Aggregations: COUNT, SUM, GROUP BY for reporting.

🔎 Business Problems Solved (Queries)

The SQL script addresses 10 specific business questions:

Airport Traffic: Find the busiest airport based on takeoff volume.

Airline Popularity: Calculate total tickets sold per airline.

Route Analysis: List all flights operated by 'IndiGo' with full location details.

Market Dominance: Identify the top airline for each airport using Window Functions.

Flight Duration: Categorize flights as Short (<2h), Medium (2-5h), or Long (>5h).

Passenger History: Determine the first and last flight date for every passenger.

Pricing Analysis: Find the most expensive ticket sold for every specific route.

Loyalty Analysis: Identify the highest-spending passenger within each Frequent Flyer tier.

Revenue Ranking: Rank airlines based on total revenue generated.

Brand Loyalty: Identify the most frequently used airline for each passenger.

💻 How to Use

Prerequisites: You need Microsoft SQL Server (or a compatible tool like Azure Data Studio / SSMS).

Note: If using MySQL or PostgreSQL, syntax for TOP and DATEDIFF will need adjustment.

Setup:

Clone this repository.

Open the .sql file in your query editor.

Execute the CREATE TABLE and INSERT statements to build the database.

Analysis:

Run the queries (Q1 - Q10) individually to view the analytical results.
