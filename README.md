Gran Canaria Holiday Rental Supply and ADR (2019–2026)


An exploratory analysis of platform-observed holiday-home supply, reservation rates and average daily revenue across Gran Canaria’s 21 municipalities. The project uses PostgreSQL for data preparation and analysis, and Power BI for interactive visualisation.


Research question

How did these indicators change from January 2019 to August 2026, and were there visible changes around recent regulatory changes?


Key findings

- Available homes fell sharply during the 2020 pandemic period, then grew for several years. Year-over-year growth turned negative in October 2025 and reached a low in June 2026.
- In August 2026, available homes were lower year over year across the municipalities shown in the analysis.
- The reservation rate showed seasonal variation and was broadly stable outside the pandemic period.
- Average daily revenue peaked at about €177 in January 2025, then declined; its year-over-year change turned negative in September 2025.

These are descriptive findings. The data does not establish that a law, a change in demand, or platform enforcement caused the observed trends.


Data and definitions

The analysis uses two monthly ISTAC datasets, covering January 2019 to August 2026:

- [Holiday-home indicators](https://www3.gobiernodecanarias.org/istac/statistical-visualizer/visualizer/data.html?permalink=17kkj2n96id97weq1jel7pyhc6)
- [Average daily rate by accommodation capacity](https://www3.gobiernodecanarias.org/istac/statistical-visualizer/visualizer/data.html?permalink=10f6lymdhadumvsg1rodf8b63)

ISTAC’s experimental statistic uses whole-home listings from major digital booking platforms. A home is counted as available if it was booked at least once in the reference month or the previous month. The published methodology does not state that it verifies each listing’s VV licence.

Reservation rate is the share of available homes that were reserved; it is not the share of nights occupied. ADR is average daily accommodation revenue per occupied holiday home, excluding other services.

Tools and files

- PostgreSQL: cleaning, joins, CTEs and window functions for year-over-year comparisons.
- Power BI: time-series charts, a municipality-by-month matrix and interactive filters.
- SQL scripts
- Power BI file
- Project report
- Chart examples
- Data files

Limitations

The data does not represent all licensed properties or all holiday rentals. A change in homes counted as available may reflect booking activity as well as properties entering or leaving the market. The monthly indicators do not identify why a trend changed, so this analysis cannot attribute observed changes to legislation.
